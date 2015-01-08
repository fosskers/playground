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

        // Buffer for our data
        GLuint buff;
        glGenBuffers(1,&buff);
        glBindBuffer(GL_ARRAY_BUFFER, buff);
        glBufferData(GL_ARRAY_BUFFER,sizeof(verts),verts,GL_STATIC_DRAW);

        // Compile Shaders and check success
        GLuint vertexShader = glCreateShader(GL_VERTEX_SHADER);
        glShaderSource(vertexShader,1,&vertexShaderSource,NULL);
        glCompileShader(vertexShader);

        GLint success;
        GLchar infoLog[512];
        glGetShaderiv(vertexShader,GL_COMPILE_STATUS,&success);

        if(!success) {
                glGetShaderInfoLog(vertexShader,512,NULL,infoLog);
                printf("Vertex Shader failed to compile:\n%s\n", infoLog);
        }
        
        // Render until you shouldn't.
        while(!glfwWindowShouldClose(w)) {
                glfwPollEvents();

                glClearColor(0.2f,0.3f,0.3f,1.0f);
                glClear(GL_COLOR_BUFFER_BIT);

                // Always comes last.
                glfwSwapBuffers(w);
        }

        // Clean up.
        glfwTerminate();

        printf("And done.\n");

        return EXIT_SUCCESS;
}
