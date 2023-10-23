// Sobel Edge Detection Shader written by absentSpaghetti
//
// This shader is a part of my tutorial/learning Github repository: https://github.com/absentSpaghetti/Shader-Basics-With-Spaghetti
// Feel free to use, edit and share this shader according to your needs
//
// MIT License 
//
// prerequisites: color-to-greyscale

shader_type spatial;
render_mode unshaded, cull_disabled;

uniform sampler2D screen_texture : hint_screen_texture, filter_linear_mipmap; // screen texture, in Godot 3.x we would use `SCREEN_TEXTURE`
uniform float min_step : hint_range(0.0, 1.0, 0.01) = 0.4; // min step for the smoothstep() function
uniform float max_step : hint_range(0.0, 1.0, 0.01) = 0.6; // max step for the smoothstep() function

// x direction kernel
const mat3 kx = mat3(
	vec3(-1, 0, 1),
	vec3(-2, 0, 2),
	vec3(-1, 0, 1)
);
// y direction kernel 
const mat3 ky = mat3(
	vec3(-1, -2, -1),
	vec3(0, 0, 0),
	vec3(1, 2, 1)
);

// By using a different set of kernels we can get different results. This is a kernel for the laplace operator
//// x direction kernel
//const mat3 kx = mat3(
//	vec3(0, -1, 0),
//	vec3(-1, 4, -1),
//	vec3(-0, -1, 0)
//);
//// y direction kernel 
//const mat3 ky = mat3(
//	vec3(-1, -1, -1),
//	vec3(-1, 8, -1),
//	vec3(-1, -1, -1)
//);

// affects verticies
void vertex() { 
	POSITION = vec4(VERTEX, 1.0); // assign mesh's position to viewport
}

// affects color
void fragment() { 
	
	vec4 texture_color = texture(screen_texture, SCREEN_UV); // sample screen texture
	
	mat3 I; // Matrix is essentially an array of vectors (in this case vector3s)
	for (int i = 0; i < 3; i++ ) {
		for (int j = 0; j < 3; j++) {
			vec3 sample_around_pixel = texelFetch(screen_texture, ivec2(FRAGCOORD.xy) + ivec2(i-1,j-1), 0).rgb; // lookup pixels on the screen_texture with given coordinates
			vec3 sample_grey = vec3(sample_around_pixel.r * 0.3, sample_around_pixel.g * 0.59, sample_around_pixel.b * 0.11); // multiply looked up colors by greyscale weights
			I[i][j] = sample_grey.r + sample_grey.g + sample_grey.b; // add the weights together to create a greyscale color
			
		}
	}
	
	// apply the sobel operator
	float gx = dot(kx[0], I[0]) + dot(kx[1], I[1]) + dot(kx[2], I[2]); // convolution of the image's and intensity's 'x' values
	float gy = dot(ky[0], I[0]) + dot(ky[1], I[1]) + dot(ky[2], I[2]); // convolution of the image's and intensity's 'y' values
	float g = sqrt(pow(gx, 2.0) + pow(gy, 2.0)); // combine x and y of the sobel and get rid of negative values
	
	
	// strength of the effect;
	g = smoothstep(min_step, max_step, g); // smoothstep() smooths out a value over a curve if it is within min and max steps. Otherwise, it returns 0 (if smaller than min_step) and 1 (if bigger than max_step)
	
	ALBEDO = vec3(g);
	
//	//color + sobel edge detection
//	ALBEDO = texture_color.rgb * vec3(g);
	
//	//debug, uncomment to return to the screen_texture color
//	ALBEDO = texture_color.rgb;
}
