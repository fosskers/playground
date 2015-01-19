#version 330 core

layout (location = 0) in vec2 position;
layout (location = 1) in vec3 colour;
layout (location = 2) in vec2 texCoord;

out vec3 vertexColour;
out vec2 TexCoord;

uniform mat4 transform;

void main() {
        gl_Position = transform * vec4(position, 0.0, 1.0);
        vertexColour = colour;
        TexCoord = vec2(texCoord.x, 1.0f - texCoord.y);
}
