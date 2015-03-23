#version 330 core

struct Material {
        vec3 ambient;
        vec3 diffuse;
        vec3 specular;
        float shininess;
};

struct Light {
        vec3 position;
        vec3 ambient;
        vec3 diffuse;
        vec3 specular;
};

in vec3 Normal;
in vec3 FragPos;
in vec3 LightPos;

out vec4 colour;

uniform vec3 cubeColour;
uniform vec3 lightColour;
uniform Material material;
uniform Light light;

void main() {
        // Ambient Lighting
        vec3 ambient = light.ambient * material.ambient;

        // Diffuse Lighting
        vec3 norm     = normalize(Normal);
        vec3 lightDir = normalize(LightPos - FragPos);
        float diff    = max(dot(norm,lightDir),0.0);
        vec3 diffuse  = (diff * material.diffuse) * light.diffuse;

        // Specular Lighting
        vec3 viewDir    = normalize(-FragPos);
        vec3 reflectDir = reflect(-lightDir,norm);
        float spec      = pow(max(dot(viewDir,reflectDir),0.0),32);
        vec3 specular   = (material.specular * spec) * light.specular;
        
        vec3 result = (ambient + diffuse + specular) * cubeColour;

        colour = vec4(result, 1.0f);
}
