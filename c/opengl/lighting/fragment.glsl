#version 330 core

out vec4 colour;
in vec3 Normal;
in vec3 FragPos;

uniform vec3 cubeColour;
uniform vec3 lightColour;
uniform vec3 lightPos;

void main() {
        vec3 norm = normalize(Normal);
        vec3 lightDir = normalize(lightPos - FragPos);

        float diff = max(dot(norm,lightDir),0.0);
        vec3 diffuse = diff * lightColour;

        float ambientStr = 0.1f;
        vec3 ambient = ambientStr * lightColour;

        colour = vec4((ambient + diffuse) * cubeColour, 1.0f);
}
