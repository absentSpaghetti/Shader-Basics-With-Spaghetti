// Robert Cross Edge Detection Shader written by absentSpaghetti
//
// This shader is a part of my tutorial/learning Github repository: https://github.com/absentSpaghetti/Shader-Basics-With-Spaghetti
// Feel free to use, edit and share this shader according to your needs
//
// MIT License 
//
// prerequisites: color-to-greyscale, simple-box-blur

shader_type spatial;
render_mode unshaded, cull_disabled;

uniform sampler2D screen_texture : hint_screen_texture, filter_linear_mipmap;
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

void vertex() { 
	POSITION = vec4(VERTEX, 1.0); // assign mesh's position to viewport
}

void fragment() { 
	
	vec4 texture_color = texture(screen_texture, SCREEN_UV);
	
	mat2 I; // Matrix is essentially an array of vectors (in this case vector2s)
	for (int i = -1; i <= 1; i++ ) {
	    for (int j = -1; j <= 1; j++) {
	        vec3 sample_around_pixel = texelFetch(screen_texture, ivec2(FRAGCOORD.xy) + ivec2(i, j), 0).rgb;
	        vec3 sample_grey = vec3(sample_around_pixel.r * 0.3, sample_around_pixel.g * 0.59, sample_around_pixel.b * 0.11);
	        I[i+1][j+1] = sample_grey.r + sample_grey.g + sample_grey.b;
	    }
	}

	
	// apply the sobel operator
	float gx = dot(kx[0], I[0]) + dot(kx[1], I[1]);
	float gy = dot(ky[0], I[0]) + dot(ky[1], I[1]);
	float g = sqrt(pow(gx, 2.0) + pow(gy, 2.0)); // combine x and y of the sobel and get rid of negative values
	
	
	// strength of the effect;
	g = smoothstep(min_step, max_step, g);
	
	ALBEDO = vec3(g);
	
//	//color + sobel edge detection
//	ALBEDO = texture_color.rgb * vec3(g);
	
//	//debug, uncomment to return to the screen_texture color
//	ALBEDO = texture_color.rgb;
}
