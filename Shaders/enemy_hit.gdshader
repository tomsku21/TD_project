shader_type canvas_item;
uniform float flash_amount : hint_range(0.0, 1.0) = 0.0;
uniform float red_tint_amount : hint_range(0.0, 1.0) = 0.0;

void fragment() {
	vec4 current_color = texture(TEXTURE, UV);

	vec3 red_tint_color = vec3(1.0, 0.0, 0.0);
	vec3 tinted_color = mix(current_color.rgb, red_tint_color, red_tint_amount);

	vec3 flash_color = vec3(1.0, 1.0, 1.0);
	vec3 final_color = mix(tinted_color, flash_color, flash_amount);
	COLOR = vec4(final_color, current_color.a);
}
