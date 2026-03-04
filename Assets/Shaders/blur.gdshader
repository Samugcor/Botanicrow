shader_type canvas_item;

uniform float blur_size : hint_range(0.0, 10.0) = 4.0;
uniform float opacity : hint_range(0.0, 1.0) = 1.0;

void fragment() {
    vec2 tex_size = 1.0 / TEXTURE_PIXEL_SIZE;
    vec4 color = vec4(0.0);
    float total_weight = 0.0;

    // 9x9 blur (adjust range for smoother blur)
    for (int x = -2; x <= 2; x++) {
        for (int y = -2; y <= 2; y++) {
            vec2 offset = vec2(float(x), float(y)) * TEXTURE_PIXEL_SIZE * blur_size;
            vec4 sample = texture(TEXTURE, UV + offset);

            // Ignore fully transparent pixels
            float weight = sample.a;
            color.rgb += sample.rgb * weight;
            color.a += sample.a;
            total_weight += weight;
        }
    }

    if (total_weight > 0.0) {
        color.rgb /= total_weight;
    }

    color.a /= 25.0; // average alpha

    // Apply opacity control
    COLOR = vec4(color.rgb, color.a * opacity);
}