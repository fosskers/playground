#version 330 core

in vec3 vertexColour;
in vec2 TexCoord;

out vec4 colour;

uniform sampler2D ourTexture;

void main() {
        colour = texture(ourTexture,TexCoord) * vec4(vertexColour,1.0f);
}
