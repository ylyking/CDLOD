#version 150

in vec3 position;

uniform mat4 projection;
uniform mat4 view;
uniform vec4 color;
uniform vec3 translation;
uniform float scale;
uniform float range;
uniform vec3 cameraPos;

out vec4 fPosition;
out vec4 fColor;

vec2 gridDim = vec2(32.0,32.0);
vec2 morphVertex( vec2 gridPos, vec2 worldPos, float morph) {
	vec2 fracPart = fract(gridPos * gridDim * 0.5) * 2.0 / gridDim;
	return worldPos - fracPart * scale * morph;
}

void main(void)
{
	fColor = color;
	vec3 worldPos = scale*position + translation;
	float dist = distance(cameraPos, worldPos);
	float rangeDist = 1.0 - smoothstep(0.0, 0.1, (range-dist)/scale);
	float morphVal = rangeDist;
	worldPos.xz = morphVertex(position.xz, worldPos.xz, morphVal);
    fPosition = view * vec4(worldPos,1.0);

    gl_Position = projection * fPosition;
}
