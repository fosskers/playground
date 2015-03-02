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
#define wWidth  800
#define wHeight 600

// Light Source
matrix_t* lightPos = NULL;

// Camera
camera_t* camera = NULL;
bool keys[1024];  // Why 1024?
GLfloat deltaTime = 0;
GLfloat lastFrame = 0;
GLfloat aspect = initialAspect;

// --- //

/* Init/Reset the Camera */
void resetCamera() {
        if(camera) { cogcDestroy(camera); }

        matrix_t* camPos = coglV3(0,0,4);
        matrix_t* camDir = coglV3(0,0,-1);
        matrix_t* camUp  = coglV3(0,1,0);

        camera = cogcCreate(camPos,camDir,camUp);
}

void moveCamera() {
        cogcMove(camera,
                 deltaTime,
                 keys[GLFW_KEY_W],
                 keys[GLFW_KEY_S],
                 keys[GLFW_KEY_A],
                 keys[GLFW_KEY_D]);
}

void key_callback(GLFWwindow* w, int key, int code, int action, int mode) {
        if(action == GLFW_PRESS) {
                if(key == GLFW_KEY_Q) {
                        glfwSetWindowShouldClose(w, GL_TRUE);
                }
                else if(key == GLFW_KEY_C) {
                        resetCamera();
                }

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
                -0.5f, -0.5f, -0.5f,  0.0f,  0.0f, -1.0f,
                0.5f, -0.5f, -0.5f,  0.0f,  0.0f, -1.0f,
                0.5f,  0.5f, -0.5f,  0.0f,  0.0f, -1.0f,
                0.5f,  0.5f, -0.5f,  0.0f,  0.0f, -1.0f,
                -0.5f,  0.5f, -0.5f,  0.0f,  0.0f, -1.0f,
                -0.5f, -0.5f, -0.5f,  0.0f,  0.0f, -1.0f,

                -0.5f, -0.5f,  0.5f,  0.0f,  0.0f, 1.0f,
                0.5f, -0.5f,  0.5f,  0.0f,  0.0f, 1.0f,
                0.5f,  0.5f,  0.5f,  0.0f,  0.0f, 1.0f,
                0.5f,  0.5f,  0.5f,  0.0f,  0.0f, 1.0f,
                -0.5f,  0.5f,  0.5f,  0.0f,  0.0f, 1.0f,
                -0.5f, -0.5f,  0.5f,  0.0f,  0.0f, 1.0f,

                -0.5f,  0.5f,  0.5f, -1.0f,  0.0f,  0.0f,
                -0.5f,  0.5f, -0.5f, -1.0f,  0.0f,  0.0f,
                -0.5f, -0.5f, -0.5f, -1.0f,  0.0f,  0.0f,
                -0.5f, -0.5f, -0.5f, -1.0f,  0.0f,  0.0f,
                -0.5f, -0.5f,  0.5f, -1.0f,  0.0f,  0.0f,
                -0.5f,  0.5f,  0.5f, -1.0f,  0.0f,  0.0f,

                0.5f,  0.5f,  0.5f,  1.0f,  0.0f,  0.0f,
                0.5f,  0.5f, -0.5f,  1.0f,  0.0f,  0.0f,
                0.5f, -0.5f, -0.5f,  1.0f,  0.0f,  0.0f,
                0.5f, -0.5f, -0.5f,  1.0f,  0.0f,  0.0f,
                0.5f, -0.5f,  0.5f,  1.0f,  0.0f,  0.0f,
                0.5f,  0.5f,  0.5f,  1.0f,  0.0f,  0.0f,

                -0.5f, -0.5f, -0.5f,  0.0f, -1.0f,  0.0f,
                0.5f, -0.5f, -0.5f,  0.0f, -1.0f,  0.0f,
                0.5f, -0.5f,  0.5f,  0.0f, -1.0f,  0.0f,
                0.5f, -0.5f,  0.5f,  0.0f, -1.0f,  0.0f,
                -0.5f, -0.5f,  0.5f,  0.0f, -1.0f,  0.0f,
                -0.5f, -0.5f, -0.5f,  0.0f, -1.0f,  0.0f,

                -0.5f,  0.5f, -0.5f,  0.0f,  1.0f,  0.0f,
                0.5f,  0.5f, -0.5f,  0.0f,  1.0f,  0.0f,
                0.5f,  0.5f,  0.5f,  0.0f,  1.0f,  0.0f,
                0.5f,  0.5f,  0.5f,  0.0f,  1.0f,  0.0f,
                -0.5f,  0.5f,  0.5f,  0.0f,  1.0f,  0.0f,
                -0.5f,  0.5f, -0.5f,  0.0f,  1.0f,  0.0f
        };

        matrix_t* view = NULL;
        matrix_t* proj = NULL;
        
        // Initial settings.
        glfwInit();
        glfwWindowHint(GLFW_CONTEXT_VERSION_MAJOR, 3);
        glfwWindowHint(GLFW_CONTEXT_VERSION_MINOR, 3);
        glfwWindowHint(GLFW_OPENGL_PROFILE, GLFW_OPENGL_CORE_PROFILE);
        glfwWindowHint(GLFW_RESIZABLE, GL_FALSE);
        
        // Make a window.
        GLFWwindow* w = glfwCreateWindow(wWidth,wHeight,"OpenGL!",NULL,NULL);
        glfwMakeContextCurrent(w);

        // Fire up GLEW.
        glewExperimental = GL_TRUE;  // For better compatibility.
        glewInit();

        // For the rendering window.
        glViewport(0,0,wWidth,wHeight);

        // Register callbacks.
        glfwSetKeyCallback(w, key_callback);

        // Take Mouse input.
        glfwSetInputMode(w,GLFW_CURSOR,GLFW_CURSOR_DISABLED);
        glfwSetCursorPosCallback(w,mouse_callback);
        glfwSetScrollCallback(w,scroll_callback);

        // Depth Testing
        glEnable(GL_DEPTH_TEST);
        
        // Cube Shader Program
        log_info("Making Cube Shader.");
        shaders_t* shaders = cogsShaders("vertex.glsl", "fragment.glsl");
        GLuint cShaderP = cogsProgram(shaders);
        cogsDestroy(shaders);
        check(cShaderP > 0, "Shaders didn't compile.");

        // Light Source Shader Program
        log_info("Making Light Source Shader.");
        shaders = cogsShaders("lVertex.glsl", "lFragment.glsl");
        GLuint lShaderP = cogsProgram(shaders);
        cogsDestroy(shaders);
        check(lShaderP > 0, "Shaders didn't compile.");

        // Main Cube Stack
        GLuint cVAO;
        glGenVertexArrays(1,&cVAO);
        GLuint VBO;
        glBindVertexArray(cVAO);
        glGenBuffers(1,&VBO);
        glBindBuffer(GL_ARRAY_BUFFER, VBO);
        glBufferData(GL_ARRAY_BUFFER,sizeof(verts),verts,GL_STATIC_DRAW);
        glVertexAttribPointer(0,3,GL_FLOAT,GL_FALSE,
                              6 * sizeof(GLfloat),(GLvoid*)0);
        glEnableVertexAttribArray(0);
        glVertexAttribPointer(1,3,GL_FLOAT,GL_FALSE,
                              6 * sizeof(GLfloat),
                              (GLvoid*)(3 * sizeof(GLfloat)));
        glEnableVertexAttribArray(1);
        glBindVertexArray(0);  // Reset the VAO binding.

        // Light Source Stack
        GLuint lVAO;
        glGenVertexArrays(1,&lVAO);
        glBindVertexArray(lVAO);
        glBindBuffer(GL_ARRAY_BUFFER,VBO);
        glVertexAttribPointer(0,3,GL_FLOAT,GL_FALSE,
                              6 * sizeof(GLfloat),(GLvoid*)0);
        glEnableVertexAttribArray(0);
        glBindVertexArray(0);

        // Light Source Position and Model Matrix
        lightPos = coglV3(1.2f,1.0f,2.0f);
        matrix_t* lModel = coglMIdentity(4);
        lModel = coglMScale(lModel,0.2f);
        lModel = coglM4Translate(lModel,
                                 lightPos->m[0],
                                 lightPos->m[1],
                                 lightPos->m[2]);
        
        // Cube's Model Matrix
        matrix_t* cModel = coglMIdentity(4);

        // Camera
        resetCamera();

        // View Matrix
        view = coglM4LookAtP(camera->pos,camera->tar,camera->up);

        // Projection Matrix
        proj = coglMPerspectiveP(aspect, 
                                 (float)wWidth/(float)wHeight,
                                 0.1f,1000.0f);

        // Set Light Position
        glUseProgram(cShaderP);
        GLuint lightPosLoc = glGetUniformLocation(cShaderP,"lightPos");
        glUniform3f(lightPosLoc,lightPos->m[0],lightPos->m[1],lightPos->m[2]);

        // Render until you shouldn't.
        while(!glfwWindowShouldClose(w)) {
                glfwPollEvents();
                moveCamera();

                // Update Frame info
                GLfloat currentFrame = glfwGetTime();
                deltaTime = currentFrame - lastFrame;
                lastFrame = currentFrame;
                
                glClearColor(0.1f,0.1f,0.1f,1.0f);
                glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);

                /* Draw Cube */
                glUseProgram(cShaderP);

                // Set colours
                GLuint cubeL  = glGetUniformLocation(cShaderP,"cubeColour");
                GLuint lightL = glGetUniformLocation(cShaderP,"lightColour");
                glUniform3f(cubeL,1.0f,0.5f,0.31f);
                glUniform3f(lightL,1.0f,1.0f,1.0f);

                GLuint modelLoc = glGetUniformLocation(cShaderP,"model");
                GLuint viewLoc  = glGetUniformLocation(cShaderP,"view");
                GLuint projLoc  = glGetUniformLocation(cShaderP,"proj");

                // Update View Matrix
                coglMDestroy(view);
                coglMDestroy(proj);
                view = coglM4LookAtP(camera->pos,camera->tar,camera->up);
                proj = coglMPerspectiveP(aspect, (float)wWidth/(float)wHeight,
                                         0.1f,1000.0f);

                glUniformMatrix4fv(modelLoc,1,GL_FALSE,cModel->m);
                glUniformMatrix4fv(viewLoc,1,GL_FALSE,view->m);
                glUniformMatrix4fv(projLoc,1,GL_FALSE,proj->m);
                
                glBindVertexArray(cVAO);
                glDrawArrays(GL_TRIANGLES,0,36);
                glBindVertexArray(0);
                
                /* Draw Light Source */
                glUseProgram(lShaderP);

                modelLoc = glGetUniformLocation(lShaderP,"model");
                viewLoc  = glGetUniformLocation(lShaderP,"view");
                projLoc  = glGetUniformLocation(lShaderP,"proj");

                glUniformMatrix4fv(modelLoc,1,GL_FALSE,lModel->m);
                glUniformMatrix4fv(viewLoc,1,GL_FALSE,view->m);
                glUniformMatrix4fv(projLoc,1,GL_FALSE,proj->m);

                glBindVertexArray(lVAO);
                glDrawArrays(GL_TRIANGLES,0,36);
                glBindVertexArray(0);

                // Always comes last.
                glfwSwapBuffers(w);
        }

        // Clean up.
        glfwTerminate();
        coglMDestroy(view);
        coglMDestroy(proj);

        log_info("Done.");

        return EXIT_SUCCESS;
 error:
        if(view)  { coglMDestroy(view); }
        if(proj)  { coglMDestroy(proj); }
        return EXIT_FAILURE;
}
