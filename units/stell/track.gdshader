shader_type canvas_item;

uniform bool enabled = true;
/** The length of the tracks in pixels. */
uniform float pixels = 64.0;
/** The speeed of the track aniamtion. */
uniform float speed = 48.0;
uniform int dir_x = 0;
uniform int dir_y = 0;


// Called for every vertex the material is visible on.
void vertex() {}

// Called for every pixel the material is visible on.
void fragment() {
	if (enabled) {
		float track_left = float(dir_y * -1);
		float track_right = float(dir_y * -1);
		
		if (dir_x == -1) {
			track_left = -1.0;
			track_right = 1.0;
			if (dir_y != 0) {
				track_left = 0.4;
			}
		}
		else if (dir_x == 1) {
			track_left = 1.0;
			track_right = -1.0;
			if (dir_y != 0) {
				track_right = 0.4;
			}
		}
		
		// Left track animations
		if (UV.x > 0.5) {
			COLOR = texture(TEXTURE, vec2(UV.x, UV.y + (track_left / 64.0) * (TIME * speed)));
		}
		// Right track animations
		else {
			COLOR = texture(TEXTURE, vec2(UV.x, UV.y + (track_right / 64.0) * (TIME * speed)));
		}
	}
}
