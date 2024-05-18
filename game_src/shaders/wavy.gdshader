
shader_type canvas_item;

uniform float height = 3.0;
uniform float frequency = 20.0;
uniform float speed = 3.0;

void vertex() {
	VERTEX.y += height * sin((frequency * UV.x) + (speed * TIME));
	//COLOR.r += height * sin((frequency * UV.x) + (0.1 * speed * TIME));
	//COLOR.g += height * sin((frequency * UV.x) + (0.2 * speed * TIME));
	//COLOR.b += height * sin((frequency * UV.x) + (0.3 * speed * TIME));
}

void fragment() {
	// Called for every pixel the material is visible on.
	float alpha = texture(TEXTURE, UV).a;
    COLOR.a = step(0.5, alpha);
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
