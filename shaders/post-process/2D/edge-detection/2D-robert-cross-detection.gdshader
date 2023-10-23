// Robert Cross Edge Detection Shader written by absentSpaghetti
//
// This shader is a part of my tutorial/learning Github repository: https://github.com/absentSpaghetti/Shader-Basics-With-Spaghetti
// Feel free to use, edit and share this shader according to your needs
//
// MIT License 
//
// prerequisites: color-to-greyscale

shader_type canvas_item;
render_mode unshaded;

uniform sampler2D screen_texture : hint_screen_texture, filter_linear_mipmap; // screen texture, in Godot 3.x we would use `SCREEN_TEXTURE`
uniform float min_step : hint_range(0.0, 1.0, 0.01) = 0.4;
uniform float max_step : hint_range(0.0, 1.0, 0.01) = 0.6;

// x direction matrix
const mat2 kx = mat2(
	vec2(1, 0),
	vec2(0, -1)
);
// y direction matrix 
const mat2 ky = mat2(
	vec2(0, 1),
	vec2(-1, 0)
);

// affects color
void fragment() { 
	
	vec4 texture_color = texture(screen_texture, SCREEN_UV); // sample screen texture
	
	mat2 I; // Matrix is an array ov vectors, in this case, vector2s
	for (int i = -1; i <= 1; i++ ) {
	    for (int j = -1; j <= 1; j++) {
	        vec3 sample_around_pixel = texelFetch(screen_texture, ivec2(FRAGCOORD.xy) + ivec2(i, j), 0).rgb; // lookup pixels on the screen_texture with given coordinates
	        vec3 sample_grey = vec3(sample_around_pixel.r * 0.3, sample_around_pixel.g * 0.59, sample_around_pixel.b * 0.11); // multiply looked up colors by greyscale weights
	        I[i+1][j+1] = sample_grey.r + sample_grey.g + sample_grey.b; // add the weights together to create a greyscale color
	    }
	}
	
	// apply the robert cross operator
	float gx = dot(kx[0], I[0]) + dot(kx[1], I[1]);
	float gy = dot(ky[0], I[0]) + dot(ky[1], I[1]);
	float g = sqrt(pow(gx, 2.0) + pow(gy, 2.0)); // combine x and y of the robert cross and get rid of negative values
	
	
	// strength of the effect;
	g = smoothstep(max_step, min_step, g);
	
	COLOR = vec4(vec3(g), 1.0);
	
//	color + robert cross edge detection
//	COLOR = vec4(texture_color.rgb * vec3(g), 1.0);
	
//	debug, uncomment to return to the screen_texture color
//	COLOR = texture_color.rgba;
}
