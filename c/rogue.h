#ifndef _rogue_h
#define _rogue_h

#include "object.h"

typedef struct {
        Object proto;
        int hp;
} Monster;

int Monster_attack(void* self, int damage);
int Monster_init(void* self);

typedef struct Room Room;

struct Room {
        Object proto;

        Monster* enemy;

        Room* north;
        Room* south;
        Room* east;
        Room* west;
};

void* Room_move(void* self, Direction direction);
int Room_attack(void* self, int damage);
int Room_init(void* self);

typedef struct {
        Object proto;
        Room* start;
        Room* location;
} Map;

void* Map_move(void* self, Direction direction);
int Map_attack(void* self, int damage);
int Map_init(void* self);

#endif
