extends Node3D

@onready var cameraUI := $camera_UI

@export var isOrbiting : bool = true
@export var isVisibleUI : bool = true
var rotationSpeed : float = 0.5

func _ready() -> void:
	if isVisibleUI == true:
		cameraUI.show()
	else:
		cameraUI.hide()

func _process(delta: float) -> void:
	if isOrbiting == true:
		rotate_y(rotationSpeed * delta)

func _on_speed_slider_value_changed(value: float) -> void:
	rotationSpeed = value

func _on_oribting_toggled(button_pressed: bool) -> void:
	isOrbiting = !isOrbiting
