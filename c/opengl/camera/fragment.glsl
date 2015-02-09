#version 330 core

in vec2 TexCoord;

out vec4 colour;

uniform sampler2D tex1;
uniform sampler2D tex2;

void main() {
        // Third arg is a `ratio` to mix by.
        colour = mix(texture(tex1,TexCoord),
                     texture(tex2,vec2(-1 * TexCoord.x,TexCoord.y)),0.2);
}
