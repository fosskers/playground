#include <stdio.h>
#include <assert.h>
#include <stdlib.h>
#include <errno.h>
#include <string.h>

#define MAX_DATA 512
#define MAX_ROWS 100

// --- //

typedef struct ADDRESS {
        int id;
        int set;
        char name[MAX_DATA];
        char email[MAX_DATA];
} Address;

typedef struct DATABASE {
        Address rows[MAX_ROWS];
} Database;

typedef struct CONNECTION {
        FILE* file;
        Database* db;
} Connection;

// --- //

 void Database_close(Connection* c);

 // --- //

 void die(Connection* c, const char* message) {
         if(errno) {
                 perror(message);
         } else {
                 printf("ERROR: %s\n", message);
         }

         if(c) { Database_close(c); }

         exit(1);
 }

 void Address_print(const Address* addr) {
         printf("Address { id=%d, name=%s, email=%s }\n",
                addr->id, addr->name, addr->email);
 }

 void Database_load(Connection *c) {
         int rc = fread(c->db, sizeof(Database), 1, c->file);

         if(rc != 1) { die(c, "Failed to load database"); }
 }

 Connection* Database_open(const char* filename, char mode) {
         Connection* c = malloc(sizeof(Connection));
         if(!c) { die(c, "Memory error"); }

         c->db = malloc(sizeof(Database));
         if(!c->db) { die(c, "Memory error"); }

         if(mode == 'c') {
                 c->file = fopen(filename, "w");
         } else {
                 c->file = fopen(filename, "r+");

                 if(c->file) { Database_load(c); }
         }

         if(!c->file) { die(c, "Failed to open DB file"); }

         return c;
 }

 void Database_close(Connection* c) {
         if(c) {
                 if(c->file) { fclose(c->file); }
                 if(c->db) { free(c->db); }
                 free(c);
         }
 }

 void Database_write(Connection* c) {
         rewind(c->file);

         int rc = fwrite(c->db, sizeof(Database), 1, c->file);

         if(rc != 1) { die(c, "Failed to write to database"); }

         rc = fflush(c->file);
         if(rc == -1) { die(c, "Cannot flush database"); }
 }

 void Database_create(Connection* c) {
         int i;

         for(i = 0; i < MAX_ROWS; i++) {
                 Address addr = {.id = i, .set = 0};

                 c->db->rows[i] = addr;
         }
 }

 void Database_set(Connection* c, int id, const char* name, const char* email) {
         Address* addr = &(c->db->rows[id]);
         if(addr->set) { die(c,"Entry is already set"); }

         addr->set = 1;
         char* res = strncpy(addr->name, name, MAX_DATA);
         if(!res) { die(c,"Name copy failed"); }

         res = strncpy(addr->email, email, MAX_DATA);
         if(!res) { die(c,"Email copy failed"); }
 }

 void Database_get(Connection* c, int id) {
         Address* addr = &(c->db->rows[id]);

         if(addr->set) {
                 Address_print(addr);
         } else {
                 die(c,"Attempted `get` on unset entry");
         }
 }

 void Database_unset(Connection* c, int id) {
         Address addr = {.id = id, .set = 0};
         c->db->rows[id] = addr;
 }

 void Database_list(Connection* c) {
         int i;
         Database* db = c->db;

         for(i = 0; i < MAX_ROWS; i++) {
                 Address *curr = &(db->rows[i]);

                 if(curr->set) { Address_print(curr); }
         }
 }

 void Database_find(Connection* c, const char* name) {
         int i;

         for(i = 0; i < MAX_ROWS; i++) {
                 Address *curr = &(c->db->rows[i]);

                 if(strcmp(curr->name, name) == 0) { Address_print(curr); }
        }
}

int main(int argc, char** argv) {
        if(argc < 3) { die(NULL, "USAGE: db <file> <action> [action params]"); }

        char* filename = argv[1];
        char  action   = argv[2][0];
        Connection* c  = Database_open(filename, action);
        int id = 0;

        if(argc > 3) { id = atoi(argv[3]); }
        if(id >= MAX_ROWS) { die(c,"There aren't that many records"); }

        switch(action) {
        case 'c':
                Database_create(c);
                Database_write(c);
                break;

        case 'g':
                if(argc != 4) { die(c,"Need an ID"); }
                Database_get(c,id);
                break;

        case 's':
                if(argc != 6) { die(c,"Need an ID, name, and email to set"); }
                Database_set(c, id, argv[4], argv[5]);
                Database_write(c);
                break;

        case 'd':
                if(argc != 4) { die(c,"Need an ID to delete by"); }
                Database_unset(c, id);
                Database_write(c);
                break;

        case 'l':
                Database_list(c);
                break;

        case 'f':
                if(argc != 4) { die(c,"Need a name to search by"); }
                Database_find(c, argv[3]);
                break;

        default:
                die(c,"Invalid action. Use c=create, g=get, s=set, d=del, l=list");
        }

        Database_close(c);

        return 0;
}
