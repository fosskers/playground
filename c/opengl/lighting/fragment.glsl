#version 330 core

out vec4 colour;

uniform vec3 cubeColour;
uniform vec3 lightColour;

void main() {
        colour = vec4(lightColour * cubeColour, 1.0f);
}
