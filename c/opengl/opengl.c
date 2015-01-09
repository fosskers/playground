#include <stdio.h>
#include <stdlib.h>
#include <GL/glew.h>  // This must be before other GL libs.
#include <GLFW/glfw3.h>

/* NOTES
 * We should use `GL` prefixed types, as OpenGL sets these up in
 * a cross-platform manner.
 */

// --- //

// Shaders. Looks like C code.
const GLchar* vertexShaderSource = "#version 330 core\n"
        "layout (location = 0) in vec2 position;\n"
        "void main() {\n"
        "gl_Position = vec4(position.x, position.y, 0.0, 1.0);\n"
        "}\0";

const GLchar* fragmentShaderSource = "#version 330 core\n"
        "out vec4 color;\n"
        "void main() {\n"
        "color = vec4(1.0f, 0.5f, 0.2f, 1.0f);\n"
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
        GLfloat verts[] = {
                -0.5f,-0.5f,
                0.5f,-0.5,
                0,0.5
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

        // Vertex Array
        GLuint VAO;
        glGenVertexArrays(1,&VAO);

        // Buffer for our data
        GLuint VBO;
        glBindVertexArray(VAO);  // VAO!
        glGenBuffers(1,&VBO);
        glBindBuffer(GL_ARRAY_BUFFER, VBO);
        glBufferData(GL_ARRAY_BUFFER,sizeof(verts),verts,GL_STATIC_DRAW);

        // Tell OpenGL how to process Vertex data.
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

        // Shader Program - linking shaders
        GLuint shaderProgram = glCreateProgram();
        glAttachShader(shaderProgram,vertexShader);
        glAttachShader(shaderProgram,fragmentShader);
        glLinkProgram(shaderProgram);

        // No longer needed.
        glDeleteShader(vertexShader);
        glDeleteShader(fragmentShader);
        
        // Render until you shouldn't.
        while(!glfwWindowShouldClose(w)) {
                glfwPollEvents();

                glClearColor(0.2f,0.3f,0.3f,1.0f);
                glClear(GL_COLOR_BUFFER_BIT);

                // Draw object
                glUseProgram(shaderProgram);
                glBindVertexArray(VAO);
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
