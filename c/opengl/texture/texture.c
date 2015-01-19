#include <stdio.h>
#include <stdlib.h>
#include <GL/glew.h>  // This must be before other GL libs.
#include <GLFW/glfw3.h>
#include <SOIL/SOIL.h>
#include <math.h>

#include "ogll/opengl-linalg.h"
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

        // Create Shader Program
        log_info("Making shader program.");
        shaders_t* shaders = oglsShaders("vertex.glsl", "fragment.glsl");
        GLuint shaderProgram = oglsProgram(shaders);
        oglsDestroy(shaders);

        check(shaderProgram > 0, "Shaders didn't compile.");
        log_info("Shaders good.");

        // Element buffer
        GLuint EBO;
        glGenBuffers(1,&EBO);
        
        // Vertex Array
        GLuint VAO;
        glGenVertexArrays(1,&VAO);

        // Vertex buffer for our data
        GLuint VBO;
        glBindVertexArray(VAO);  // VAO!
        glGenBuffers(1,&VBO);
        glBindBuffer(GL_ARRAY_BUFFER, VBO);
        glBufferData(GL_ARRAY_BUFFER,sizeof(verts),verts,GL_STATIC_DRAW);

        glBindBuffer(GL_ELEMENT_ARRAY_BUFFER,EBO);
        glBufferData(GL_ELEMENT_ARRAY_BUFFER,sizeof(ixs),ixs,GL_STATIC_DRAW);
        
        // Tell OpenGL how to process Vertex data.
        glVertexAttribPointer(0,2,GL_FLOAT,GL_FALSE,
                              7 * sizeof(GLfloat),(GLvoid*)0);
        glEnableVertexAttribArray(0);
        glVertexAttribPointer(1,3,GL_FLOAT,GL_FALSE,
                              7 * sizeof(GLfloat),
                              (GLvoid*)(2 * sizeof(GLfloat)));
        glEnableVertexAttribArray(1);
        glVertexAttribPointer(2,2,GL_FLOAT,GL_FALSE,
                              7 * sizeof(GLfloat),
                              (GLvoid*)(5 * sizeof(GLfloat)));
        glEnableVertexAttribArray(2);
        glBindVertexArray(0);  // Reset the VAO binding.

        // Box Texture
        int width,height;
        unsigned char* img = SOIL_load_image("container.jpg",
                                             &width,&height,0,SOIL_LOAD_RGB);
        check(img, "Container image didn't load.");
        GLuint box_tex;
        glGenTextures(1,&box_tex);
        glBindTexture(GL_TEXTURE_2D,box_tex);
        glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_WRAP_S,GL_REPEAT);
        glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_WRAP_T,GL_REPEAT);
        glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_MIN_FILTER,GL_LINEAR);
        glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_MAG_FILTER,GL_LINEAR);
        glTexImage2D(GL_TEXTURE_2D,0,GL_RGB,width,height,
                     0,GL_RGB,GL_UNSIGNED_BYTE,img);
        glGenerateMipmap(GL_TEXTURE_2D);
        SOIL_free_image_data(img);
        glBindTexture(GL_TEXTURE_2D,0);

        log_info("Box texture created.");

        // Face texture
        GLuint face_tex;
        img = SOIL_load_image("awesomeface.png",
                              &width,&height,0,SOIL_LOAD_RGB);
        check(img, "Face image didn't load.");
        glGenTextures(1,&face_tex);
        glBindTexture(GL_TEXTURE_2D,face_tex);
        glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_WRAP_S,GL_MIRRORED_REPEAT);
        glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_WRAP_T,GL_MIRRORED_REPEAT);
        glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_MIN_FILTER,GL_LINEAR);
        glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_MAG_FILTER,GL_LINEAR);
        glTexImage2D(GL_TEXTURE_2D,0,GL_RGB,width,height,
                     0,GL_RGB,GL_UNSIGNED_BYTE,img);
        glGenerateMipmap(GL_TEXTURE_2D);
        SOIL_free_image_data(img);
        glBindTexture(GL_TEXTURE_2D,0);

        log_info("Face texture created.");

        // Draw in Wireframe mode
        //glPolygonMode(GL_FRONT_AND_BACK, GL_LINE);
        
        // Render until you shouldn't.
        while(!glfwWindowShouldClose(w)) {
                glfwPollEvents();

                glClearColor(0.2f,0.3f,0.3f,1.0f);
                glClear(GL_COLOR_BUFFER_BIT);

                glUseProgram(shaderProgram);

                // Bind to texture units.
                glActiveTexture(GL_TEXTURE0);
                glBindTexture(GL_TEXTURE_2D, box_tex);
                glUniform1i(glGetUniformLocation(shaderProgram,"tex1"),0);
                glActiveTexture(GL_TEXTURE1);
                glBindTexture(GL_TEXTURE_2D, face_tex);
                glUniform1i(glGetUniformLocation(shaderProgram,"tex2"),1);

                // Applying transformations
                matrix_t* m = ogllMIdentity(4);
                ogllMScale(m,0.5);
                ogllMSet(m,3,3,1);

                GLuint transformLoc = glGetUniformLocation(shaderProgram,"transform");
                glUniformMatrix4fv(transformLoc,1,GL_TRUE,m->m);

                glBindVertexArray(VAO);
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
