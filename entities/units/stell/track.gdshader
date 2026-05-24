shader_type canvas_item;

/** Enables track animation shader. */
uniform bool enabled = true;

/** The length of the tracks in pixels. */
uniform float pixels = 64.0;
/** The speeed of the track aniamtion. */
uniform float speed = 45.0;
/** User horizontal movement input direction. */
uniform int dir_x = 0;
/** User vertical movement input  direction. */
uniform int dir_y = 0;

//varying vec2 track_state;
varying vec2 track_offset_left;
varying float track_offset_right;


// Called for every vertex the material is visible on.
void vertex() {}

// Called for every pixel the material is visible on.
void fragment() {
	if (enabled) {
		if (track_offset_left == vec2(0)) {
			//track_offset_left = UV;
			track_offset_left = vec2(1);
		}
		//if (track_state == vec2(0)) {
			//track_state = texture(TEXTURE, UV);
			//track_state = UV;
		//}
		float track_left = float(dir_y * -1);
		float track_right = float(dir_y * -1);
		
		// Turn left
		if (dir_x == -1) {
			track_left = 1.0;  // (Left track moves backwards)
			track_right = -1.0;  // (Right track moves forwards)
			if (dir_y != 0) {
				track_left = 0.4;
			}
		}
		// Turn right
		else if (dir_x == 1) {
			track_left = -1.0;  // (Left track moves forwards)
			track_right = 1.0;  // (Right track moves backwards)
			if (dir_y != 0) {
				track_right = 0.4;
			}
		}
		
		// Idle animation seter
		if (vec2(track_left, track_right) == vec2(0.0)) {
			// Left track animations
			//if (UV.x > 0.5) {
				////COLOR = texture(TEXTURE, vec2(UV.x, UV.y + (1.0 / 64.0) * (1.0 * speed)));
				////COLOR = texture(TEXTURE, vec2(UV.x, UV.y + (1.0 / 64.0) ));
				////COLOR = texture(TEXTURE, vec2(UV.x, track_offset_left));
				//COLOR = texture(TEXTURE, track_offset_left);
			//// Right track animations
			//} else {
				////COLOR = texture(TEXTURE, vec2(UV.x, UV.y + (2.0 / 64.0) * (1.0 * speed)));
				////COLOR = texture(TEXTURE, vec2(UV.x, UV.y + 2.0));
				////COLOR = texture(TEXTURE, vec2(UV.x, UV.y + (2.0 / 64.0) * speed));
			//}
		// Non idle animation
		} else {
			// Left track animations
			if (UV.x > 0.5) {
				COLOR = texture(TEXTURE, vec2(UV.x, UV.y + (track_left / 64.0) * (TIME * speed)));
				//track_state.y = track_state.y + (track_left / 64.0) * (TIME * speed);
				//track_offset_left = UV.y + (track_left / 64.0) * (TIME * speed);
				track_offset_left = vec2(UV.x, UV.y + (track_left / 64.0) * (TIME * speed));
			// Right track animations
			} else {
				COLOR = texture(TEXTURE, vec2(UV.x, UV.y + (track_right / 64.0) * (TIME * speed)));
				//track_state.y = track_state.y + (track_left / 64.0) * (TIME * speed);
			}
		}
	}
}
