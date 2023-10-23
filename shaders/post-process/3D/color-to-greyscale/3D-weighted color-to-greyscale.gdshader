// Weighted Color to Greyscale Shader written by absentSpaghetti
//
// This shader is a part of my tutorial/learning Github repository: https://github.com/absentSpaghetti/Shader-Basics-With-Spaghetti
// Feel free to use, edit and share this shader according to your needs
//
// MIT License 
//
// prerequisites:

shader_type spatial;
render_mode unshaded, cull_disabled;

uniform sampler2D screen_texture : hint_screen_texture, filter_linear_mipmap; // screen texture, in Godot 3.x we would use `SCREEN_TEXTURE`


// affects verticies
void vertex() { 
	POSITION = vec4(VERTEX, 1.0); // mesh's position assigned to viewport
}

// affects color
void fragment() { 
	vec4 texture_color = texture(screen_texture, SCREEN_UV); // screen_texture sampled at screen_coordinates
	
//	simple color-to-greyscale conversion is done by adding up the taking an average of the RGB values, but the most of the time, theweighted method is prefered
//	simple_color = (texture_color.r + texture_color.g + texture_color.b) / 3.0;
//	ALBEDO = vec3(simple_color);
	
//	 the colors are weighed because of how the human eye perceives color. Green and red contribute more than blue.
	vec3 color_weights = vec3(texture_color.r * 0.3, texture_color.g * 0.59, texture_color.b * 0.11);
	float new_color = (color_weights.r + color_weights.g + color_weights.b);
	ALBEDO = vec3(new_color); // assign the average of all colros to the ALBEDO value
	
//	//debug, uncomment to return to the screen_texture color
//	ALBEDO = texture_color.rgb;
}
