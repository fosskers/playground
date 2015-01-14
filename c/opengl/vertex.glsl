#version 330 core

layout (location = 0) in vec2 position;
layout (location = 1) in vec3 colour;

out vec4 vertexColour;

uniform float offset;

void main() {
        gl_Position = vec4(position.x + offset, -1 * position.y, 0.0, 1.0);
        vertexColour = gl_Position;
}
