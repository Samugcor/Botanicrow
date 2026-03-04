shader_type canvas_item;

uniform vec2 rect_size = vec2(200.0, 200.0);
uniform float thickness : hint_range(0.0, 50.0) = 10.0;

uniform vec4 border_color_hover : source_color = vec4(0.0, 0.0, 0.0, 1.0);
uniform vec4 border_color_selected : source_color = vec4(0.0, 0.0, 0.0, 1.0);
uniform vec4 fill_color : source_color = vec4(1.0, 1.0, 1.0, 1.0);

uniform float dash_count : hint_range(1.0, 50.0) = 10.0;
uniform float dash_ratio : hint_range(0.0, 1.0) = 0.5;
uniform float speed = 0.8;

// ✏ Mode selector: 0 = normal, 1 = hover, 2 = selected
uniform int mode : hint_range(0, 2) = 0;

void fragment() {
	// Use the smaller dimension to ensure it stays a circle even if the rect is non-square
	float radius = min(rect_size.x, rect_size.y) * 0.5;
	
	// Distance from center (UV 0.5 is center)
	vec2 p = (UV - 0.5) * rect_size;
	float dist = length(p);
	
	// SDF for a circle: distance from center minus the radius
	float d = dist - radius;

	// ---- Circle shape mask ----
	float shape_mask = smoothstep(0.5, -0.5, d);

	// ---- Border mask ----
	// We center the stroke on the edge of the circle
	float border_mask = smoothstep(0.5, -0.5, abs(d + thickness * 0.5) - thickness * 0.5);

	float final_border_alpha = 0.0;

	if (mode == 1 || mode == 2) {
		// For a circle, the path position is just the angle!
		// atan2 returns values from -PI to PI
		float angle = atan(p.y, p.x); 
		// Normalize angle to 0.0 - 1.0 range
		float normalized_path = (angle + PI) / (2.0 * PI);

		if (mode == 1) { // Hover: Animated Dashes
			float segment = 1.0 / max(1.0, dash_count);
			float dash_offset = TIME * (speed * 0.1);
			float dash_mod = mod(normalized_path + dash_offset, segment) / segment;
			float dash_mask = step(dash_mod, dash_ratio);

			final_border_alpha = border_color_hover.a * border_mask * dash_mask;
		} 
		else { // Selected: Solid Border
			final_border_alpha = border_color_selected.a * border_mask;
		}
	}

	// ---- Combine ----
	vec4 border = vec4(0.0);
	if (mode == 1) {
		border = vec4(border_color_hover.rgb, final_border_alpha);
	} else if (mode == 2) {
		border = vec4(border_color_selected.rgb, final_border_alpha);
	}

	// Mix fill and border based on border alpha
	vec4 result = mix(fill_color, border, final_border_alpha);

	// Apply the overall circle shape transparency
	result.a *= shape_mask;

	COLOR = result;
}