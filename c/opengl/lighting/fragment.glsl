#version 330 core

out vec4 colour;
in vec3 Normal;
in vec3 FragPos;

uniform vec3 viewPos;
uniform vec3 cubeColour;
uniform vec3 lightColour;
uniform vec3 lightPos;

void main() {
        // Ambient Lighting
        float ambientStr = 0.1f;
        vec3 ambient = ambientStr * lightColour;

        // Diffuse Lighting
        vec3 norm     = normalize(Normal);
        vec3 lightDir = normalize(lightPos - FragPos);
        float diff    = max(dot(norm,lightDir),0.0);
        vec3 diffuse  = diff * lightColour;

        // Specular Lighting
        float specStr   = 0.5f;
        vec3 viewDir    = normalize(viewPos - FragPos);
        vec3 reflectDir = reflect(-lightDir,norm);
        float spec      = pow(max(dot(viewDir,reflectDir),0.0),32);
        vec3 specular   = specStr * spec * lightColour;
        
        vec3 result = (ambient + diffuse + specular) * cubeColour;

        colour = vec4(result, 1.0f);
}
