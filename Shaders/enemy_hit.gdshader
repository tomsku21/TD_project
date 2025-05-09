shader_type canvas_item;

uniform float flash_amount : hint_range(0.0, 1.0) = 0.0;
uniform float red_tint_amount : hint_range(0.0, 1.0) = 0.0;
uniform float ice_tint_amount : hint_range(0.0, 1.0) = 0.0;

void fragment() {
    vec4 current_color = texture(TEXTURE, UV);

    // Apply red tint separately
    vec3 red_tint_color = vec3(0.7, 0.0, 0.0);
    vec3 red_tinted = mix(current_color.rgb, red_tint_color, red_tint_amount);

    // Apply ice tint separately to the result of red tint
    vec3 ice_tint_color = vec3(0.0, 0.4, 0.7);
    vec3 ice_tinted = mix(red_tinted, ice_tint_color, ice_tint_amount);

    // Apply flash effect
    vec3 flash_color = vec3(1.0, 1.0, 1.0);
    vec3 final_color = mix(ice_tinted, flash_color, flash_amount);

    // Output final color with original alpha
    COLOR = vec4(final_color, current_color.a);
}
