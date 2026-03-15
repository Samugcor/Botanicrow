shader_type canvas_item;

uniform sampler2D paper_texture;

uniform float color_mix : hint_range(0.0,1.0) = 0.35;
uniform float brightness : hint_range(0.5,2.0) = 1.15;
uniform float paper_strength : hint_range(0.0,1.0) = 0.25;
uniform float wobble_strength : hint_range(0.0,0.01) = 0.003;
uniform float pigment_strength : hint_range(0.0,1.0) = 0.25;

void fragment() {

    // Hand-drawn wobble distortion
    vec2 wobble = (texture(paper_texture, UV * 8.0).rg - 0.5) * wobble_strength;
    vec2 uv2 = UV + wobble;

    vec4 color = texture(TEXTURE, uv2);

    // Convert to grayscale pencil base
    float gray = dot(color.rgb, vec3(0.299, 0.587, 0.114));

    // Mix grayscale with original color (watercolor wash)
    vec3 watercolor = mix(vec3(gray), color.rgb, color_mix);

    // Brightness correction
    watercolor *= brightness;

    // Paper grain
    float paper = texture(paper_texture, UV * 4.0).r;
    watercolor = mix(watercolor, watercolor * paper, paper_strength);

    // Watercolor pigment variation
    float pigment = texture(paper_texture, UV * 6.0).r;
    watercolor *= mix(1.0, pigment, pigment_strength);

    // Slight ink bleed
    float edge_soft = texture(paper_texture, UV * 12.0).r;
    watercolor = mix(watercolor, watercolor * edge_soft, 0.08);

    COLOR = vec4(watercolor, color.a);
}
