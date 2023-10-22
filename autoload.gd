extends Node

func _input(event: InputEvent) -> void:
	if event.is_action_pressed('take_screenshot'):
		var image = get_viewport().get_texture().get_image()
		
		var dir = DirAccess.open("user://") 
		if dir.dir_exists("Screenshots") == false:
			dir.make_dir('Screenshots')
		
		var datetime_string = Time.get_datetime_string_from_system()
		datetime_string = datetime_string.replace(":", "-")
		image.save_png("user://Screenshots/" + datetime_string + ".png")
