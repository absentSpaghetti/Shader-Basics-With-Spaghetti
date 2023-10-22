extends Node3D

@onready var cameraUI := $camera_UI

var isOrbiting : bool = true
var rotationSpeed : float = 0.5

func _process(delta: float) -> void:
	if isOrbiting == true:
		rotate_y(rotationSpeed * delta)

func _on_speed_slider_value_changed(value: float) -> void:
	rotationSpeed = value

func _on_oribting_toggled(button_pressed: bool) -> void:
	isOrbiting = !isOrbiting
