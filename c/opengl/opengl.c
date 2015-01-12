#include <stdio.h>
#include <stdlib.h>
#include <GL/glew.h>  // This must be before other GL libs.
#include <GLFW/glfw3.h>
#include <math.h>

/* NOTES
 * We should use `GL` prefixed types, as OpenGL sets these up in
 * a cross-platform manner.
 */

// --- //

// Shaders. Looks like C code.
const GLchar* vertexShaderSource = "#version 330 core\n"
        "layout (location = 0) in vec2 position;\n"
        "out vec4 vertexColor;\n"
        "void main() {\n"
        "gl_Position = vec4(position.x, position.y, 0.0, 1.0);\n"
        "vertexColor = vec4(0.5f, 0.0f, 0.0f, 1.0f);\n"
        "}\0";

const GLchar* fragmentShaderSource = "#version 330 core\n"
        "out vec4 color;\n"
        "uniform vec4 ourColour;\n"
        "void main() {\n"
        "color = ourColour;\n"
        "}\0";

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
        /*
        GLfloat verts[] = {
                0.5f,0.5f,    // TR
                0.5f,-0.5f,   // BR
                -0.5f,-0.5f,  // BL
                -0.5f,0.5f    // TL
        };
        */

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
        glBufferData(GL_ARRAY_BUFFER,sizeof(tri1),tri1,GL_STATIC_DRAW);

        // Bound EBO is stored in VAO.
        //glBindBuffer(GL_ELEMENT_ARRAY_BUFFER,EBO);
        //glBufferData(GL_ELEMENT_ARRAY_BUFFER,sizeof(ixs),ixs,GL_STATIC_DRAW);

        // Tell OpenGL how to process Vertex data.
        glVertexAttribPointer(0,2,GL_FLOAT,GL_FALSE,0,(GLvoid*)0);
        glEnableVertexAttribArray(0);
        glBindVertexArray(0);  // Reset the VAO binding.

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
                
        // Compile Shaders and check success
        GLuint vertexShader = glCreateShader(GL_VERTEX_SHADER);
        glShaderSource(vertexShader,1,&vertexShaderSource,NULL);
        glCompileShader(vertexShader);

        GLuint fragmentShader = glCreateShader(GL_FRAGMENT_SHADER);
        glShaderSource(fragmentShader,1,&fragmentShaderSource,NULL);
        glCompileShader(fragmentShader);

        /*
        GLint success;
        GLchar infoLog[512];
        glGetShaderiv(vertexShader,GL_COMPILE_STATUS,&success);

        if(!success) {
                glGetShaderInfoLog(vertexShader,512,NULL,infoLog);
                printf("Vertex Shader failed to compile:\n%s\n", infoLog);
        }
        */

        // Shader Programs - linking shaders
        GLuint shaderProgram = glCreateProgram();
        glAttachShader(shaderProgram,vertexShader);
        glAttachShader(shaderProgram,fragmentShader);
        glLinkProgram(shaderProgram);

        // No longer needed.
        glDeleteShader(vertexShader);
        glDeleteShader(fragmentShader);
        
        // Draw in Wireframe mode
        //glPolygonMode(GL_FRONT_AND_BACK, GL_LINE);
        
        // Render until you shouldn't.
        while(!glfwWindowShouldClose(w)) {
                glfwPollEvents();

                glClearColor(0.2f,0.3f,0.3f,1.0f);
                glClear(GL_COLOR_BUFFER_BIT);

                glUseProgram(shaderProgram);

                // Setting fragment shader colour over time.
                GLfloat timeValue = glfwGetTime();
                GLfloat greenValue = (sin(timeValue) / 2) + 0.5;
                GLint vColourLoc = glGetUniformLocation(shaderProgram,"ourColour");

                // Draw object
                glUniform4f(vColourLoc,0.0f,greenValue,0.0f,1.0f);

                glBindVertexArray(VAO1);
                glDrawArrays(GL_TRIANGLES,0,3);
                //glDrawElements(GL_TRIANGLES,6,GL_UNSIGNED_INT,0);
                glBindVertexArray(0);

                glBindVertexArray(VAO2);
                glDrawArrays(GL_TRIANGLES,0,3);
                glBindVertexArray(0);

                // Always comes last.
                glfwSwapBuffers(w);
        }

        // Clean up.
        glfwTerminate();

        printf("And done.\n");

        return EXIT_SUCCESS;
}
