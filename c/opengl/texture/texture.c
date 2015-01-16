#include <stdio.h>
#include <stdlib.h>
#include <GL/glew.h>  // This must be before other GL libs.
#include <GLFW/glfw3.h>
#include <SOIL/SOIL.h>
#include <math.h>

#include "ogls/opengl-shaders.h"
#include "ogls/dbg.h"

// --- //

void key_callback(GLFWwindow* w, int key, int code, int action, int mode) {
        if(key == GLFW_KEY_ESCAPE && action == GLFW_PRESS) {
                glfwSetWindowShouldClose(w, GL_TRUE);
        }
}

int main(int argc, char** argv) {
        GLfloat verts[] = {
                // Coords    // Colours       // Texture Coords
                0.5f,0.5f,   1.0f,0.0f,0.0f,  1.0f,1.0f,
                0.5f,-0.5f,  0.0f,1.0f,0.0f,  1.0f,0.0f,
                -0.5f,-0.5f, 0.0f,0.0f,1.0f,  0.0f,0.0f,
                -0.5f,0.5f,  1.0f,1.0f,0.0f,  0.0f,1.0f
        };

        GLuint ixs[] = {
                0,1,3,
                1,2,3
        };
        
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

        GLuint EBO;
        glGenBuffers(1,&EBO);
        
        // Vertex Array 1
        GLuint VAO1;
        glGenVertexArrays(1,&VAO1);

        // Vertex buffer for our data
        GLuint VBO1;
        glBindVertexArray(VAO1);  // VAO!
        glGenBuffers(1,&VBO1);
        glBindBuffer(GL_ARRAY_BUFFER, VBO1);
        glBufferData(GL_ARRAY_BUFFER,sizeof(verts),verts,GL_STATIC_DRAW);

        glBindBuffer(GL_ELEMENT_ARRAY_BUFFER,EBO);
        glBufferData(GL_ELEMENT_ARRAY_BUFFER,sizeof(ixs),ixs,GL_STATIC_DRAW);
        
        // Tell OpenGL how to process Vertex data.
        glVertexAttribPointer(0,2,GL_FLOAT,GL_FALSE,
                              7 * sizeof(GLfloat),(GLvoid*)0);
        glEnableVertexAttribArray(0);
        glVertexAttribPointer(1,3,GL_FLOAT,GL_FALSE,
                              7 * sizeof(GLfloat),(GLvoid*)(2 * sizeof(GLfloat)));
        glEnableVertexAttribArray(1);
        glVertexAttribPointer(2,2,GL_FLOAT,GL_FALSE,
                              7 * sizeof(GLfloat),(GLvoid*)(5 * sizeof(GLfloat)));
        glEnableVertexAttribArray(2);
        glBindVertexArray(0);  // Reset the VAO binding.

        // Create Shader Program
        log_info("Making shader program.");
        shaders_t* shaders = oglsShaders("vertex.glsl", "fragment.glsl");
        GLuint shaderProgram = oglsProgram(shaders);
        oglsDestroy(shaders);

        log_info("Shaders good.");
        
        // Texture
        int width,height;
        unsigned char* img = SOIL_load_image("container.jpg",
                                             &width,&height,0,SOIL_LOAD_RGB);
        check(img, "SOIL didn't load it right.");
        log_info("Image loaded.");

        GLuint texture;
        glGenTextures(1,&texture);
        glBindTexture(GL_TEXTURE_2D,texture);
        glTexImage2D(GL_TEXTURE_2D,0,GL_RGB,width,height,
                     0,GL_RGB,GL_UNSIGNED_BYTE,img);
        glGenerateMipmap(GL_TEXTURE_2D);
        SOIL_free_image_data(img);
        glBindTexture(GL_TEXTURE_2D,0);

        log_info("Texture created.");
        
        // Draw in Wireframe mode
        //glPolygonMode(GL_FRONT_AND_BACK, GL_LINE);
        
        // Render until you shouldn't.
        while(!glfwWindowShouldClose(w)) {
                glfwPollEvents();

                glClearColor(0.2f,0.3f,0.3f,1.0f);
                glClear(GL_COLOR_BUFFER_BIT);

                glUseProgram(shaderProgram);

                glBindTexture(GL_TEXTURE_2D, texture);
                glBindVertexArray(VAO1);
                glDrawElements(GL_TRIANGLES,6,GL_UNSIGNED_INT,0);
                glBindVertexArray(0);

                // Always comes last.
                glfwSwapBuffers(w);
        }

        // Clean up.
        glfwTerminate();

        log_info("And done.");

        return EXIT_SUCCESS;
 error:
        return EXIT_FAILURE;
}
