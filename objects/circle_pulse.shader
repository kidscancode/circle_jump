shader_type canvas_item;

uniform vec4 color : hint_color;
uniform float speed : hint_range(0, 20);
uniform float ring_duration : hint_range(0, 50);
uniform float brightness : hint_range(0, 2);
uniform float fade : hint_range(0, 10);

void fragment() {
	vec2 center = vec2(0.5);
	float l = distance(UV, center);
	vec4 c = color;
	vec4 nc = smoothstep(1.5, 6.5, fade * sin(l * ring_duration - speed * TIME) + brightness / l - vec4(0));
	c.rgb = color.rgb + nc.rgb;
	c.a = texture(TEXTURE, UV).a;
	COLOR = c;
	
	
}