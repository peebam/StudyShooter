extends CharacterBody2D

@export_range(0.0, 1.0) var acceleration_factor := 0.2
@export_range(0.0, 1.0) var rotation_acceleration_factor := 0.2
@export var projectile_scene : PackedScene

@export var linear_max_speed := Vector2(300.0, 300.0)
var linear_velocity := Vector2.ZERO

@export var orbital_max_speed := PI / 32
var orbital_velocity := 0.0 


var last_input := Vector2.ZERO

var direction := Vector2.ZERO

signal projectile_fired(projectile:Node2D)

func _ready() -> void:
	pass

func _physics_process(delta: float) -> void:
	rotate_toward_mouse()
	move(delta)
	

func _input(event: InputEvent) -> void:
	var input = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	if input.y != last_input.y:
		direction.y = input.y
		
	if input.x != last_input.x:
		direction.x = input.x * (-1 if get_global_mouse_position().y < global_position.y else 1)
	
	last_input = input
	
	if event.is_action_pressed("fire"):
		fire()

# Logic

func fire() -> void:
	var projectile := projectile_scene.instantiate()
	projectile.transform = global_transform
	projectile_fired.emit(projectile)

func move(delta: float) -> void:
	var mouse_position := get_global_mouse_position()
	var distance_to_mouse = mouse_position.distance_to(global_position)
	var angle := global_position.angle_to_point(mouse_position) - PI
	
	var orbital_direction := direction.x
	orbital_velocity = lerp(orbital_velocity, orbital_direction * orbital_max_speed, acceleration_factor)
	
	var target_angle := angle + orbital_velocity
	var orbital_target = Vector2(
		cos(target_angle) * distance_to_mouse, 
		sin(target_angle) * distance_to_mouse
		) + mouse_position - global_position

	global_position += orbital_target
	
	var linear_direction = Vector2.from_angle(target_angle) * direction.y
	linear_velocity = lerp(linear_velocity, linear_direction * linear_max_speed, acceleration_factor)
	var position_target = linear_velocity * delta
	
	global_position += position_target
	
func rotate_toward_mouse() -> void:
	var mouse_position = get_global_mouse_position()
	var angle := global_position.angle_to_point(mouse_position)
	rotation = lerp_angle(rotation, angle, rotation_acceleration_factor)
