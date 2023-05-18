extends Node2D

@export var speed := 400.0

@onready var direction := Vector2.from_angle(rotation)

func _physics_process(delta: float) -> void:
	var velocity = speed * delta
	global_position += direction * velocity

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
