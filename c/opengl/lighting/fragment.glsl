#version 330 core

out vec4 colour;
in vec3 Normal;
in vec3 FragPos;

uniform vec3 cubeColour;
uniform vec3 lightColour;
uniform vec3 lightPos;

void main() {
        // Ambient Lighting
        float ambientStr = 0.25f;
        vec3 ambient = ambientStr * lightColour;

        // Diffuse Lighting
        vec3 norm = normalize(Normal);
        vec3 lightDir = normalize(lightPos - FragPos);

        float diff = max(dot(norm,lightDir),0.0);
        vec3 diffuse = diff * lightColour;
        vec3 result = (ambient + diffuse) * cubeColour;

        colour = vec4(result, 1.0f);
}
