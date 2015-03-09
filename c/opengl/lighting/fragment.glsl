#version 330 core

in vec3 Normal;
in vec3 FragPos;
in vec3 LightPos;

out vec4 colour;

uniform vec3 cubeColour;
uniform vec3 lightColour;

void main() {
        // Ambient Lighting
        float ambientStr = 0.1f;
        vec3 ambient = ambientStr * lightColour;

        // Diffuse Lighting
        vec3 norm     = normalize(Normal);
        vec3 lightDir = normalize(LightPos - FragPos);
        float diff    = max(dot(norm,lightDir),0.0);
        vec3 diffuse  = diff * lightColour;

        // Specular Lighting
        float specStr   = 0.5f;
        vec3 viewDir    = normalize(-FragPos);
        vec3 reflectDir = reflect(-lightDir,norm);
        float spec      = pow(max(dot(viewDir,reflectDir),0.0),32);
        vec3 specular   = specStr * spec * lightColour;
        
        vec3 result = (ambient + diffuse + specular) * cubeColour;

        colour = vec4(result, 1.0f);
}
