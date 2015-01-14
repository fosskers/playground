#include <stdio.h>
#include <stdlib.h>
#include <GL/glew.h>  // This must be before other GL libs.
#include <GLFW/glfw3.h>
#include <math.h>

#include "ogls/opengl-shaders.h"
#include "ogls/dbg.h"

/* NOTES
 * We should use `GL` prefixed types, as OpenGL sets these up in
 * a cross-platform manner.
 */

// --- //

void key_callback(GLFWwindow* w, int key, int code, int action, int mode) {
        if(key == GLFW_KEY_ESCAPE && action == GLFW_PRESS) {
                glfwSetWindowShouldClose(w, GL_TRUE);
        }
}

int main(int argc, char** argv) {
        /* Normalized Device Coordinates
         * These are always from -1 to 1, form a Cartesian plane,
         * and are translated to screen coordinates later.
         */
        GLfloat verts[] = {
                0.5f,-0.5f,  1.0f,0.0f,0.0f,  // BR
                -0.5f,-0.5f, 0.0f,1.0f,0.0f,  // BL
                0.0f,0.5f,   0.0f,0.0f,1.0f   // Top
        };

        /*
        GLfloat tri1[] = {
                -0.5f,0.5f,
                -0.5f,-0.5f,
                0,-0.5f
        };

        GLfloat tri2[] = {
                0,0.5f,
                0.5f,0.5f,
                0.5f,-0.5f
        };

        // For an EBO
        GLuint ixs[] = {
                0,1,3,  // First triangle
                1,2,3   // Second triangle
        };
        */
        
        // Initial settings.
        glfwInit();
        glfwWindowHint(GLFW_CONTEXT_VERSION_MAJOR, 3);
        glfwWindowHint(GLFW_CONTEXT_VERSION_MINOR, 3);
        glfwWindowHint(GLFW_OPENGL_PROFILE, GLFW_OPENGL_CORE_PROFILE);
        glfwWindowHint(GLFW_RESIZABLE, GL_FALSE);
        
        // Make a window.
        GLFWwindow* w = glfwCreateWindow(800,600,"OpenGL!",NULL,NULL);
        glfwMakeContextCurrent(w);

        // Fire up GLEW.
        glewExperimental = GL_TRUE;  // For better compatibility.
        glewInit();

        // For the rendering window.
        glViewport(0,0,800,600);

        // Register callbacks.
        glfwSetKeyCallback(w, key_callback);

        // Element Buffer
        //GLuint EBO;
        //glGenBuffers(1,&EBO);

        // Vertex Array 1
        GLuint VAO1;
        glGenVertexArrays(1,&VAO1);

        // Vertex buffer for our data
        GLuint VBO1;
        glBindVertexArray(VAO1);  // VAO!
        glGenBuffers(1,&VBO1);
        glBindBuffer(GL_ARRAY_BUFFER, VBO1);
        glBufferData(GL_ARRAY_BUFFER,sizeof(verts),verts,GL_STATIC_DRAW);

        // Bound EBO is stored in VAO.
        //glBindBuffer(GL_ELEMENT_ARRAY_BUFFER,EBO);
        //glBufferData(GL_ELEMENT_ARRAY_BUFFER,sizeof(ixs),ixs,GL_STATIC_DRAW);

        // Tell OpenGL how to process Vertex data.
        glVertexAttribPointer(0,2,GL_FLOAT,GL_FALSE,
                              5 * sizeof(GLfloat),(GLvoid*)0);
        glEnableVertexAttribArray(0);
        glVertexAttribPointer(1,3,GL_FLOAT,GL_FALSE,
                              5 * sizeof(GLfloat),(GLvoid*)(2 * sizeof(GLfloat)));
        glEnableVertexAttribArray(1);
        glBindVertexArray(0);  // Reset the VAO binding.

        /*
        // Stack for the second Triangle
        GLuint VAO2;
        glGenVertexArrays(1,&VAO2);

        GLuint VBO2;
        glBindVertexArray(VAO2);  // VAO!
        glGenBuffers(1,&VBO2);
        glBindBuffer(GL_ARRAY_BUFFER, VBO2);
        glBufferData(GL_ARRAY_BUFFER,sizeof(tri2),tri2,GL_STATIC_DRAW);
        glVertexAttribPointer(0,2,GL_FLOAT,GL_FALSE,0,(GLvoid*)0);
        glEnableVertexAttribArray(0);
        glBindVertexArray(0);  // Reset the VAO binding.
        */
                
        // Create Shader Program
        log_info("Making shader program.");
        shaders_t* shaders = oglsShaders("vertex.glsl", "fragment.glsl");
        GLuint shaderProgram = oglsProgram(shaders);
        oglsDestroy(shaders);
        
        // Draw in Wireframe mode
        //glPolygonMode(GL_FRONT_AND_BACK, GL_LINE);
        
        // Render until you shouldn't.
        while(!glfwWindowShouldClose(w)) {
                glfwPollEvents();

                glClearColor(0.2f,0.3f,0.3f,1.0f);
                glClear(GL_COLOR_BUFFER_BIT);

                glUseProgram(shaderProgram);
                glBindVertexArray(VAO1);
                glDrawArrays(GL_TRIANGLES,0,3);
                //glDrawElements(GL_TRIANGLES,6,GL_UNSIGNED_INT,0);
                glBindVertexArray(0);

                /*
                glBindVertexArray(VAO2);
                glDrawArrays(GL_TRIANGLES,0,3);
                glBindVertexArray(0);
                */

                // Always comes last.
                glfwSwapBuffers(w);
        }

        // Clean up.
        glfwTerminate();

        log_info("And done.");

        return EXIT_SUCCESS;
}
