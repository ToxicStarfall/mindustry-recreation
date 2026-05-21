shader_type canvas_item;

uniform float pixels = 64.0;
uniform float speed = 48.0;
uniform int dir_x = 0;
uniform int dir_y = 0;

// Called for every vertex the material is visible on.
void vertex() {}

// Called for every pixel the material is visible on.
void fragment() {
	float track_left = float(dir_y);
	float track_right = float(dir_y);
	
	if (dir_x != 0) {
		
	}
	
	if (UV.x > 0.5) {
		COLOR = texture(TEXTURE, vec2(UV.x, UV.y + (track_left / 64.0) * (TIME * speed)));  // Move forwards
	} else {
		COLOR = texture(TEXTURE, vec2(UV.x, UV.y + (track_right / 64.0) * (TIME * speed)));  // Move forwards
	}
	
}
