shader_type canvas_item;

void vertex() {
	// Called for every vertex the material is visible on.
}

uniform float blur: hint_range(0.0, 0.25);
uniform float brightness: hint_range(0.0, 1.0);

void fragment() {
	COLOR = textureLod(SCREEN_TEXTTURE)
	
}

