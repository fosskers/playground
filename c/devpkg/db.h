#ifndef _db_h
#define _db_h

#define DB_FILE "/usr/local/devpkg/db"
#define DB_DIR  "/usr/local/devpkg"

#include <stdbool.h>

int DB_init();
int DB_list();
int DB_update(const char* url);
bool DB_find(const char* url);

#endif
