shader_type canvas_item;

uniform vec4 color : hint_color;
uniform float speed : hint_range(0, 20);
uniform float radius : hint_range(0, 1);
uniform float width : hint_range(0, 1);

void fragment() {
	vec2 center = vec2(0.5);
	float time = TIME * speed;
	float rad = radius - 0.005 * sin(time);
	float thickness = width + 0.05 * cos(time);
	float dist = distance(UV, center);
	COLOR.rgb = color.rgb;
	COLOR.a = texture(TEXTURE, UV).a + smoothstep(thickness/2.0, 0.0, abs(dist - rad));
}