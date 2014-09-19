#include <apr_general.h>
#include <apr_getopt.h>
#include <apr_lib.h>
#include <apr_strings.h>
#include <bstrlib.h>
#include <stdio.h>
#include <stdlib.h>

#include "../dbg.h"
#include "db.h"
#include "commands.h"

int main(int argc, const char const* argv[]) {
        apr_pool_t* p = NULL;
        apr_initialize();
        apr_pool_create(&p, NULL);

        apr_getopt_t* opt;
        apr_status_t rv;

        char ch = '\0';
        const char* optarg = NULL;
        const char* config_opts = NULL;
        const char* install_opts = NULL;
        const char* make_opts = NULL;
        const char* url = NULL;
        Command request = None;

        rv = apr_getopt_init(&opt, p, argc, argv);

        while(apr_getopt(opt, "I:Lc:m:i:d:SF:B:", &ch, &optarg) == APR_SUCCESS) {
                switch(ch) {
                case 'I':
                        request = Install;
                        url = optarg;
                        break;

                case 'L':
                        request = List;
                        break;

                case 'c':
                        config_opts = optarg;
                        break;

                case 'm':
                        make_opts = optarg;
                        break;

                case 'i':
                        install_opts = optarg;
                        break;

                case 'S':
                        request = Init;
                        break;

                case 'F':
                        request = Fetch;
                        url = optarg;
                        break;

                case 'B':
                        request = Build;
                        url = optarg;
                        break;
                }
        }

        switch(request) {
        case Install:
                check(url, "You must give a url.");
                Command_install(p, url, config_opts, make_opts, install_opts);
                break;

        case List:
                DB_list();
                break;

        case Fetch:
                check(url, "You must give a url.");
                Command_fetch(p, url, true);
                log_info("Downloaded to %s and in /tmp", BUILD_DIR);
                break;

        case Build:
                check(url, "You must give a url.");
                Command_build(p, url, config_opts, make_opts, install_opts);
                break;

        case Init:
                rv = DB_init();
                check(rv == 0, "Failed to make the database.");
                break;

        default:
                sentinel("Invalid command given.");
        }

        return EXIT_SUCCESS;

 error:
        return EXIT_FAILURE;
}
