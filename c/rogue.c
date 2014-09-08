#include <stdio.h>
#include <errno.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>
#include "rogue.h"

// --- //

int Monster_attack(void* self, int damage) {
        Monster* monster = self;

        printf("You attack %s for %d damage!\n", monster->_(description), damage);

        monster->hp -= damage;

        if(monster->hp > 0) {
                puts("It's still alive.");
                return 0;
        } else {
                puts("You killed it!");
                return 1;
        }
}

int Monster_init(void* self) {
        Monster* monster = self;
        monster->hp = 10;
        return 1;
}

Object MonsterProto = {
        .init = Monster_init,
        .attack = Monster_attack
};

void *Room_move(void* self, Direction direction) {
        Room* room = self;
        Room* next = NULL;

        if(direction == North && room->north) {
                printf("You go north, into the ");
                next = room->north;
        } else if(direction == South && room->south) {
                printf("You go south, into the ");
                next = room->south;
        } else if(direction == East && room->east) {
                printf("You go east, into the ");
                next = room->east;
        } else if(direction == West && room->west) {
                printf("You go west, into the ");
                next = room->west;
        } else {
                puts("You can't go that way.");
                next = NULL;
        }

        if(next) {
                next->_(describe)(next);
        }

        return next;
}

int Room_attack(void* self, int damage) {
        Room* room = self;
        Monster* monster = room->enemy;

        if(monster) {
                monster->_(attack)(monster, damage);
                return 1;
        } else {
                puts("You flail nervously at your own shadow.");
                return 0;
        }
}

Object RoomProto = {
        .move = Room_move,
        .attack = Room_attack
};

void* Map_move(void* self, Direction direction) {
        Map* map = self;
        Room* location = map->location;
        Room* next = location->_(move)(location, direction);

        if(next) {
                map->location = next;
        }

        return next;
}

int Map_attack(void* self, int damage) {
        Map* map = self;
        Room* location = map->location;

        return location->_(attack)(location, damage);
}

int Map_init(void* self) {
        Map *map = self;

        Room* hall    = NEW(Room, "Great Hall");
        Room* throne  = NEW(Room, "throne room");
        Room* arena   = NEW(Room, "arena, with the Minotaur");
        Room* kitchen = NEW(Room, "kitchen, you have the knife now");

        arena->enemy = NEW(Monster, "The evil minotaur");

        hall->north = throne;

        throne->west = arena;
        throne->east = kitchen;
        throne->south = hall;

        arena->east = throne;
        kitchen->west = throne;

        map->start = hall;
        map->location = hall;

        return 1;
}

Object MapProto = {
        .init = Map_init,
        .move = Map_move,
        .attack = Map_attack
};

int process_input(Map* game) {
        printf("\n> ");

        char c = getchar();
        getchar();  // eats ENTER press

        int damage = rand() % 4;

        switch(c) {
        case -1:
                puts("You give up? Boo.");
                return 0;
                break;

        case 'n':
                game->_(move)(game, North);
                break;

        case 's':
                game->_(move)(game, South);
                break;

        case 'e':
                game->_(move)(game, East);
                break;

        case 'w':
                game->_(move)(game, West);
                break;

        case 'a':
                game->_(attack)(game, damage);
                break;

        case 'l':
                puts("You can go:");
                if(game->location->north) { puts("North"); }
                if(game->location->south) { puts("South"); }
                if(game->location->east)  { puts("East");  }
                if(game->location->west)  { puts("West");  }
                break;

        default:
                printf("Pardon?: %d\n", c);
        }

        return 1;
}

int main(int argc, char** argv) {
        srand(time(NULL));

        Map* game = NEW(Map, "The Hall of the Minotaur.");

        printf("You enter the ");
        game->location->_(describe)(game->location);

        while(process_input(game)) {}

        return EXIT_SUCCESS;
}
