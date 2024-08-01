shader_type canvas_item;

varying flat vec4 modulate;

const float SPEED = 3.0;

void vertex() {
	modulate = COLOR;
}

void fragment() 
{
	COLOR = texture(TEXTURE, vec2(UV.x - TIME * SPEED, UV.y)) * modulate;
}