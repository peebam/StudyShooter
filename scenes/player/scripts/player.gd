extends CharacterBody2D

@export_range(0.0, 1.0) var acceleration_factor := 0.2
@export_range(0.0, 1.0) var rotation_acceleration_factor := 0.2
@export var projectile_scene : PackedScene

@export var max_speed := Vector2(300.0, 300.0)
@export var speed := Vector2.ZERO

var direction := Vector2.ZERO
var input := Vector2.ZERO

signal projectile_fired(projectile:Node2D)

func _ready() -> void:
	pass

func _physics_process(delta: float) -> void:
	move()
	rotate_toward_mouse()

func _input(event: InputEvent) -> void:
	input = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	if input != Vector2.ZERO:
		direction = input

	if event.is_action_pressed("fire"):
		fire()

# Logic

func fire() -> void:
	var projectile := projectile_scene.instantiate()
	projectile.transform = global_transform
	projectile_fired.emit(projectile)

func move() -> void:
	var target_velocity = Vector2.ZERO if input == Vector2.ZERO else direction * max_speed

	velocity = lerp(velocity, target_velocity, acceleration_factor)
	move_and_slide()

func rotate_toward_mouse() -> void:
	var mouse_position = get_global_mouse_position()
	var angle := global_position.angle_to_point(mouse_position)
	rotation = lerp_angle(rotation, angle, rotation_acceleration_factor)
