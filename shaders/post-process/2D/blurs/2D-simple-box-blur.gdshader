// Simple Box Blur Shader written by absentSpaghetti
//
// This shader is a part of my tutorial/learning Github repository: https://github.com/absentSpaghetti/Shader-Basics-With-Spaghetti
// Feel free to use, edit and share this shader according to your needs
//
// MIT License 
//
// prerequisites: 

shader_type canvas_item;
render_mode unshaded;

uniform sampler2D screen_texture : hint_screen_texture, filter_linear_mipmap;
uniform float mix_amount : hint_range(0.0, 1.0, 0.01) = 1.0; // mix amount between the original image and the blurred image

// box blur uses a simple matrix.
// [1, 1, 1,
//  1, 1, 1,
//  1, 1, 1]

void fragment() {
	
	vec4 screen_colors = texture(screen_texture, SCREEN_UV); // sample the screen texture, it can be then later used to mix between the blur and the original image 
	vec3 blur_values = vec3(0.0); // declare a vector3 for later use
	
	for (int i = -1; i <= 1; i++) { // iterate over the surrounding pixels and add their RGB values to 'blur_values'
		for (int j = -1; j <= 1; j++) {
			blur_values += texelFetch(screen_texture, ivec2(FRAGCOORD.xy) + ivec2(i, j), 0).rgb;  // sample screen_texture at current pixel coordinates + vector2(value of i, value of j)
		};
	};
	
	blur_values /= 9.0; // divide blur_values by the sum of cells (in this case, 9)
	
	COLOR = mix(screen_colors, vec4(blur_values, 1.0), mix_amount); // mix the original color with the blur_values color
}
