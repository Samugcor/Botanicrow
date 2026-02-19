shader_type canvas_item;

uniform vec2 rect_size = vec2(200.0, 100.0);

uniform float radius : hint_range(0.0, 100.0) = 40.0;
uniform float thickness : hint_range(0.0, 50.0) = 10.0;

uniform vec4 border_color_hover : source_color = vec4(0.0, 0.0, 0.0, 1.0);
uniform vec4 border_color_selected : source_color = vec4(0.0, 0.0, 0.0, 1.0);
uniform vec4 fill_color : source_color = vec4(1.0, 1.0, 1.0, 1.0);

uniform float dash_count : hint_range(1.0, 50.0) = 10.0;
uniform float dash_ratio : hint_range(0.0, 1.0) = 0.5;
uniform float speed = 0.8;

// ✏ Mode selector: 0 = normal, 1 = hover, 2 = selected
uniform int mode : hint_range(0, 2) = 0; // ✏

float roundedBoxSDF(vec2 p, vec2 b, float r) {
	vec2 q = abs(p) - b + r;
	return length(max(q, 0.0)) + min(max(q.x, q.y), 0.0) - r;
}

void fragment() {
	vec2 size = rect_size;

	// Pixel position centered in the rect
	vec2 p = (UV - 0.5) * size;
	vec2 b = size * 0.5;

	// Clamp radius so it never exceeds the panel size
	float r = min(radius, min(b.x, b.y));

	// Signed distance to rounded rectangle
	float d = roundedBoxSDF(p, b, r);

	// ---- Rounded shape mask (inside vs outside) ----
	// 1 inside, 0 outside (with anti-aliasing)
	float shape_mask = smoothstep(0.5, -0.5, d);

	// ---- Border mask (ring around the edge) ----
	float border_mask = smoothstep(
		0.5, -0.5,
		abs(d + thickness * 0.5) - thickness * 0.5
	);

	// ✏ Default: no border at all
	float final_border_alpha = 0.0; // ✏

	// ✏ If mode is hover or selected, compute border alpha
	if (mode == 1 || mode == 2) { // ✏

		// ---- Dash path math ----
		vec2 inner = b - r;
		float total_len = 4.0 * (inner.x + inner.y) + 2.0 * PI * r;

		vec2 v = p;
		vec2 q = abs(v) - inner;
		float path_pos = 0.0;

		// Corner arcs
		if (q.x > 0.0 && q.y > 0.0) {
			vec2 dir = sign(v);
			vec2 center_offset = dir * inner;
			vec2 rel = v - center_offset;

			float angle = 0.0;

			// Top-right
			if (v.x > 0.0 && v.y < 0.0) {
				angle = atan(rel.x, -rel.y);
				path_pos = inner.x + angle * r;
			}
			// Bottom-right
			else if (v.x > 0.0 && v.y > 0.0) {
				angle = atan(rel.y, rel.x);
				path_pos = inner.x + (PI * 0.5 * r) + inner.y * 2.0 + angle * r;
			}
			// Bottom-left
			else if (v.x < 0.0 && v.y > 0.0) {
				angle = atan(-rel.x, rel.y);
				path_pos = inner.x + (PI * 1.0 * r) + inner.y * 2.0 + inner.x * 2.0 + angle * r;
			}
			// Top-left
			else {
				angle = atan(-rel.y, -rel.x);
				path_pos = inner.x + (PI * 1.5 * r) + inner.y * 2.0 + inner.x * 2.0 + inner.y * 2.0 + angle * r;
			}
		}
		// Straight edges
		else {
			// Top edge
			if (v.y <= -inner.y) {
				if (v.x >= 0.0) path_pos = v.x;
				else path_pos = total_len + v.x;
			}
			// Right edge
			else if (v.x >= inner.x) {
				path_pos = inner.x + (PI * 0.5 * r) + (v.y + inner.y);
			}
			// Bottom edge
			else if (v.y >= inner.y) {
				path_pos = inner.x + (PI * 1.0 * r) + inner.y * 2.0 + (inner.x - v.x);
			}
			// Left edge
			else if (v.x <= -inner.x) {
				path_pos = inner.x + (PI * 1.5 * r) + inner.x * 2.0 + inner.y * 2.0 + (inner.y - v.y);
			}
		}

		float normalized_path = path_pos / total_len;

		// ✏ Hover = dashed and moving
		if (mode == 1) { // ✏
			float segment = 1.0 / max(1.0, dash_count);
			float dash_offset = TIME * (speed * 0.1);
			float dash_mod = mod(normalized_path + dash_offset, segment) / segment;
			float dash_mask = step(dash_mod, dash_ratio);

			final_border_alpha = border_color_hover.a * border_mask * dash_mask; // ✏
		}
		// ✏ Selected = solid border (no dashes, no movement)
		else { // mode == 2 // ✏
			final_border_alpha = border_color_selected.a * border_mask; // ✏
		}
	} // ✏ end mode block

	// ---- Combine ----

	// Fill inside always
	vec4 fill = fill_color;

	// Border
	vec4 border = vec4(0.0); // ✏ start with transparent

	if (mode == 1) {
    	// Only draw the pixels that are inside a dash
    	border = vec4(border_color_hover.rgb, final_border_alpha); // final_border_alpha already = border_mask * dash_mask
	}
	// Selected solid border
	else if (mode == 2) {
    	border = vec4(border_color_selected.rgb, final_border_alpha); // solid alpha
	}

	// ✏ Now draw: fill is behind, border on top
	// For hover, the gaps in the dash are fully transparent, so the dashed border "floats"
	vec4 result;
	if (mode == 1) {
    	// Use the border as-is (transparent outside dash)
    	result = fill;                // background fill
    	result = result * vec4(1.0); // fill stays
    	result = mix(result, border, border.a); // only the dash pixels show
	} else {
    	// normal or selected: border is fully visible
    	result = mix(fill, border, border.a);
	}

	// Clip outside the rounded rect
	result.a *= shape_mask;

	COLOR = result;
}
