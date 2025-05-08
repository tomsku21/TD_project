shader_type canvas_item;

uniform float wave_progress : hint_range(0.0, 1.0) = 0.0;
uniform float wave_speed : hint_range(0.1, 5.0) = 1.0;
uniform float wave_thickness : hint_range(0.01, 0.5) = 0.1;
uniform float wave_intensity : hint_range(0.1, 2.0) = 1.0;

void fragment() {
    vec2 uv = UV - vec2(0.5); // Center UV coordinates
    float dist = length(uv); // Distance from center

    // Calculate wave position based on progress
    float wave_pos = wave_progress * wave_speed;
    float wave = smoothstep(wave_pos - wave_thickness, wave_pos, dist);
    wave *= smoothstep(wave_pos, wave_pos + wave_thickness, dist);
    
    // Green healing color with fade
    float alpha = (1.0 - wave_progress) * wave * 0.8;
    vec3 heal_color = vec3(0.2, 1.0, 0.4) * wave * wave_intensity;
    
    COLOR = vec4(heal_color, alpha);
}