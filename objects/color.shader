shader_type canvas_item;

uniform vec4 color : hint_color;

void fragment() {
	COLOR.rgb = color.rgb;
	COLOR.a = texture(TEXTURE, UV).a;
}