#include <stdio.h>
#include <stdlib.h>
#include <GL/glew.h>  // This must be before other GL libs.
#include <GLFW/glfw3.h>
#include <SOIL/SOIL.h>
#include <math.h>

#include "cog/camera/camera.h"
#include "cog/dbg.h"
#include "cog/linalg/linalg.h"
#include "cog/shaders/shaders.h"

// --- //

#define initialAspect tau/8

// Camera
camera_t* camera;
bool keys[1024];  // Why 1024?
GLfloat deltaTime = 0;
GLfloat lastFrame = 0;
GLfloat aspect = initialAspect;

void moveCamera() {
        cogcMove(camera,
                 keys[GLFW_KEY_W],
                 keys[GLFW_KEY_S],
                 keys[GLFW_KEY_A],
                 keys[GLFW_KEY_D]);
}

void key_callback(GLFWwindow* w, int key, int code, int action, int mode) {
        if(key == GLFW_KEY_ESCAPE && action == GLFW_PRESS) {
                glfwSetWindowShouldClose(w, GL_TRUE);
        }

        if(action == GLFW_PRESS) {
                keys[key] = true;
        } else if(action == GLFW_RELEASE) {
                keys[key] = false;
        }
}

void mouse_callback(GLFWwindow * w, double xpos, double ypos) {
        cogcPan(camera,xpos,ypos);
}

void scroll_callback(GLFWwindow* w, double xoffset, double yoffset) {
        GLfloat threshold = tau/100;
        
        if(aspect >= threshold && aspect <= initialAspect + 0.0001) {
                aspect -= yoffset / 10.0;
        }
        // Correction if they zoom past a threshold.
        if(aspect <= threshold) {
                aspect = threshold;
        } else if(aspect >= initialAspect) {
                aspect = initialAspect;
        }
}

int main(int argc, char** argv) {
        GLfloat verts[] = {
                -0.5f, -0.5f, -0.5f,  0.0f, 0.0f,
                0.5f, -0.5f, -0.5f,  1.0f, 0.0f,
                0.5f,  0.5f, -0.5f,  1.0f, 1.0f,
                0.5f,  0.5f, -0.5f,  1.0f, 1.0f,
                -0.5f,  0.5f, -0.5f,  0.0f, 1.0f,
                -0.5f, -0.5f, -0.5f,  0.0f, 0.0f,

                -0.5f, -0.5f,  0.5f,  0.0f, 0.0f,
                0.5f, -0.5f,  0.5f,  1.0f, 0.0f,
                0.5f,  0.5f,  0.5f,  1.0f, 1.0f,
                0.5f,  0.5f,  0.5f,  1.0f, 1.0f,
                -0.5f,  0.5f,  0.5f,  0.0f, 1.0f,
                -0.5f, -0.5f,  0.5f,  0.0f, 0.0f,

                -0.5f,  0.5f,  0.5f,  1.0f, 0.0f,
                -0.5f,  0.5f, -0.5f,  1.0f, 1.0f,
                -0.5f, -0.5f, -0.5f,  0.0f, 1.0f,
                -0.5f, -0.5f, -0.5f,  0.0f, 1.0f,
                -0.5f, -0.5f,  0.5f,  0.0f, 0.0f,
                -0.5f,  0.5f,  0.5f,  1.0f, 0.0f,

                0.5f,  0.5f,  0.5f,  1.0f, 0.0f,
                0.5f,  0.5f, -0.5f,  1.0f, 1.0f,
                0.5f, -0.5f, -0.5f,  0.0f, 1.0f,
                0.5f, -0.5f, -0.5f,  0.0f, 1.0f,
                0.5f, -0.5f,  0.5f,  0.0f, 0.0f,
                0.5f,  0.5f,  0.5f,  1.0f, 0.0f,

                -0.5f, -0.5f, -0.5f,  0.0f, 1.0f,
                0.5f, -0.5f, -0.5f,  1.0f, 1.0f,
                0.5f, -0.5f,  0.5f,  1.0f, 0.0f,
                0.5f, -0.5f,  0.5f,  1.0f, 0.0f,
                -0.5f, -0.5f,  0.5f,  0.0f, 0.0f,
                -0.5f, -0.5f, -0.5f,  0.0f, 1.0f,

                -0.5f,  0.5f, -0.5f,  0.0f, 1.0f,
                0.5f,  0.5f, -0.5f,  1.0f, 1.0f,
                0.5f,  0.5f,  0.5f,  1.0f, 0.0f,
                0.5f,  0.5f,  0.5f,  1.0f, 0.0f,
                -0.5f,  0.5f,  0.5f,  0.0f, 0.0f,
                -0.5f,  0.5f, -0.5f,  0.0f, 1.0f
        };

        GLfloat cubePositions[] = {
                0.0f, 0.0f, 0.0f,
                2.0f, 5.0f, -15.0f,
                -1.5f, -2.2f, -2.5f,
                -3.8f, -2.0f, -12.3f,
                2.4f, -0.4f, -3.5f,
                -1.7f, 3.0f, -7.5f,
                1.3f, -2.0f, -2.5f,
                1.5f, 2.0f, -2.5f,
                1.5f, 0.2f, -1.5f,
                -1.3f, 1.0f, -1.5f
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

        // Take Mouse input.
        glfwSetInputMode(w,GLFW_CURSOR,GLFW_CURSOR_DISABLED);
        glfwSetCursorPosCallback(w,mouse_callback);
        glfwSetScrollCallback(w,scroll_callback);

        // Depth Testing
        glEnable(GL_DEPTH_TEST);

        // Testing
        debug("tau/100: %f", tau/100);
        debug("tau/8: %f", tau/8);
        
        // Create Shader Program
        log_info("Making shader program.");
        shaders_t* shaders = cogsShaders("vertex.glsl", "fragment.glsl");
        GLuint shaderProgram = cogsProgram(shaders);
        cogsDestroy(shaders);

        check(shaderProgram > 0, "Shaders didn't compile.");
        log_info("Shaders good.");

        // Vertex Array
        GLuint VAO;
        glGenVertexArrays(1,&VAO);

        // Vertex buffer for our data
        GLuint VBO;
        glBindVertexArray(VAO);  // VAO!
        glGenBuffers(1,&VBO);
        glBindBuffer(GL_ARRAY_BUFFER, VBO);
        glBufferData(GL_ARRAY_BUFFER,sizeof(verts),verts,GL_STATIC_DRAW);
        
        // Tell OpenGL how to process Vertex data.
        glVertexAttribPointer(0,3,GL_FLOAT,GL_FALSE,
                              5 * sizeof(GLfloat),(GLvoid*)0);
        glEnableVertexAttribArray(0);
        glVertexAttribPointer(1,2,GL_FLOAT,GL_FALSE,
                              5 * sizeof(GLfloat),
                              (GLvoid*)(3 * sizeof(GLfloat)));
        glEnableVertexAttribArray(1);

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

        // Model Matrices
        matrix_t* models[10];
        GLuint i,j;
        GLfloat angle = 0.05;

        // Initialize MMs
        for(i = 0, j = 0; j < 10; i+=3, j++) {
                models[j] = coglMIdentity(4);
                models[j] = coglM4Translate(models[j],
                                            cubePositions[i],
                                            cubePositions[i+1],
                                            cubePositions[i+2]);
        }

        // Camera
        GLfloat camFS[] = {0,0,4};
        matrix_t* camPos = coglVFromArray(3,camFS);
        camFS[0] = 0; camFS[1] = 0; camFS[2] = -1;
        matrix_t* camDir = coglVFromArray(3,camFS);
        camFS[0] = 0; camFS[1] = 1; camFS[2] = 0;
        matrix_t* camUp = coglVFromArray(3,camFS);
        camera = cogcCreate(camPos,camDir,camUp);

        // View Matrix
        matrix_t* view = coglM4LookAtP(camPos,camDir,camUp);

        // Projection Matrix
        matrix_t* proj = coglMPerspectiveP(aspect, (float)width/(float)height,
                                           0.1f,1000.0f);

        GLfloat len,x,y,z;
        // Render until you shouldn't.
        while(!glfwWindowShouldClose(w)) {
                glfwPollEvents();
                moveCamera();

                // Update Frame info
                GLfloat currentFrame = glfwGetTime();
                deltaTime = currentFrame - lastFrame;
                lastFrame = currentFrame;
                
                glClearColor(0.2f,0.3f,0.3f,1.0f);
                glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);

                glUseProgram(shaderProgram);

                // Bind to texture units.
                glActiveTexture(GL_TEXTURE0);
                glBindTexture(GL_TEXTURE_2D, box_tex);
                glUniform1i(glGetUniformLocation(shaderProgram,"tex1"),0);
                glActiveTexture(GL_TEXTURE1);
                glBindTexture(GL_TEXTURE_2D, face_tex);
                glUniform1i(glGetUniformLocation(shaderProgram,"tex2"),1);

                GLuint modelLoc = glGetUniformLocation(shaderProgram,"model");
                GLuint viewLoc  = glGetUniformLocation(shaderProgram,"view");
                GLuint projLoc  = glGetUniformLocation(shaderProgram,"proj");

                // Update View Matrix
                coglMDestroy(view);
                view = coglM4LookAtP(camera->pos,camera->tar,camera->up);
                
                glUniformMatrix4fv(viewLoc,1,GL_FALSE,view->m);
                glUniformMatrix4fv(projLoc,1,GL_FALSE,proj->m);
                
                glBindVertexArray(VAO);
                for(i = 0, j = 0; j < 10; i += 3, j++) {
                        len = sqrt(cubePositions[i] * cubePositions[i] +
                                   cubePositions[i+1] * cubePositions[i+1] +
                                   cubePositions[i+2] * cubePositions[i+2]);

                        // We need this as Point (0,0,0) results in an
                        // invalid rotation axis.
                        if(len == 0) {
                                x = 1;
                                y = 0;
                                z = 0;
                        } else {
                                x = cubePositions[i] / len;
                                y = cubePositions[i+1] / len;
                                z = cubePositions[i+2] / len;
                        }

                        models[j] = coglM4Rotate(models[j],angle,x,y,z);

                        glUniformMatrix4fv(modelLoc,1,GL_FALSE,models[j]->m);
                        glDrawArrays(GL_TRIANGLES,0,36);
                }

                glBindVertexArray(0);

                // Always comes last.
                glfwSwapBuffers(w);
        }

        // Clean up.
        glfwTerminate();
        coglMDestroy(view);
        coglMDestroy(proj);

        log_info("And done.");

        return EXIT_SUCCESS;
 error:
        if(view)  { coglMDestroy(view); }
        if(proj)  { coglMDestroy(proj); }
        return EXIT_FAILURE;
}
