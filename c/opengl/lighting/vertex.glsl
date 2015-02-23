#version 330 core

layout (location = 0) in vec3 position;

out vec2 TexCoord;

uniform mat4 model;
uniform mat4 view;
uniform mat4 proj;

void main() {
        gl_Position = proj * view * model * vec4(position, 1.0);
}
