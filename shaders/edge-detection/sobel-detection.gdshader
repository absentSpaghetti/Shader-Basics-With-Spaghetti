// Sobel Edge Detection Shader written by absentSpaghetti
//
// This shader is a part of a tutorial Github repository
// Feel free to use, edit and share this shader according to your needs
//
// MIT License 

// prerequisites: weighed color-to-greyscale

shader_type spatial;
render_mode unshaded, cull_disabled;

uniform sampler2D screen_texture : hint_screen_texture, filter_linear_mipmap; // screen texture, in Godot 3.x we would use `SCREEN_TEXTURE`
uniform float threshold : hint_range(0.0, 1.0, 0.01) = 0.5;

// x direction matrix
const mat3 kx = mat3(
	vec3(-1, 0, 1),
	vec3(-2, 0, 2),
	vec3(-1, 0, 1)
);
// y direction matrix 
const mat3 ky = mat3(
	vec3(-1, -2, -1),
	vec3(0, 0, 0),
	vec3(1, 2, 1)
);

// affects verticies
void vertex() { 
	POSITION = vec4(VERTEX, 1.0); // we assign the mesh's position to viewport
}

// affects color
void fragment() { 
	
	vec4 texture_color = texture(screen_texture, SCREEN_UV);
	
	// color-to-greysacle
	vec3 color_weights = vec3(texture_color.r * 0.3, texture_color.g * 0.59, texture_color.b * 0.11);
	float new_color = (color_weights.r + color_weights.g + color_weights.b) / 3.0;
	
	mat3 I;
	for (int i = 0; i < 3; i++ ) {
		for (int j = 0; j < 3; j++) {
			vec3 sample_around_pixel = texelFetch(screen_texture, ivec2(FRAGCOORD.xy) + ivec2(i-1,j-1), 0).rgb;
			I[i][j] = length(sample_around_pixel);
			
		}
	}
	
	// apply the sobel operator
	float gx = dot(kx[0], I[0]) + dot(kx[1], I[1]) + dot(kx[2], I[2]);
	float gy = dot(ky[0], I[0]) + dot(ky[1], I[1]) + dot(ky[2], I[2]);
	float g = sqrt(pow(gx, 2.0) + pow(gy, 2.0)); // combine x and y of the sobel and get rid of negative values	
	
	
	// strength of the effect; cuts out values higher than the threshold
	if (g < threshold){
		g = 1.0;
	}
	else {
		g = 0.0;
	}
	
//	ALBEDO = texture_color.rgb * vec3(g);
	ALBEDO = vec3(g);
	
//	debug, uncomment to return to the screen_texture color
//	ALBEDO = texture_color.rgb;
}
