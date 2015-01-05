module.exports = function(grunt) {
    "use strict";
    grunt.initConfig({
        srcFiles: ["src/**/*.purs", "bower_components/**/src/**/*.purs"],
        psc: {
            options: {
                main: "Chapter2",
                modules: ["Chapter2"]
            },
            all: {
                src: ["<%=srcFiles%>"],
                dest: "dist/Main.js"
            }
        },
        dotPsci: ["<%=srcFiles%>"],
        execute: {
            target: {
                src: ["dist/Main.js"]
            }
        }
    });

    grunt.loadNpmTasks("grunt-purescript");
    grunt.loadNpmTasks("grunt-execute");
    grunt.registerTask("default", ["psc:all", "dotPsci"]);
    grunt.registerTask("run", ["execute"]);
};
