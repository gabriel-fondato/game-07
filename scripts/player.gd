extends CharacterBody2D

@export var SPEED := 300.0
@export var ACCELERATION := 10.0      # higher = snappier speed changes
@export var ROTATION_SPEED := 10.0    # higher = snappier turning
@export var PUSH_OBJECTS_FORCE := 20.0
@export var player_should_move := true
@export var projectileScene : PackedScene
@export var projectileData: ProjectileData

func _physics_process(delta: float) -> void:
	_move_player(delta)
	_rotate_player(delta)
	_push_objects()

func _move_player(delta: float) -> void:
	var direction := Input.get_vector("left", "right", "up", "down")
	var target_velocity := direction * SPEED if player_should_move else Vector2.ZERO

	# smoothly move current velocity toward target instead of snapping
	velocity = velocity.lerp(target_velocity, 1.0 - exp(-ACCELERATION * delta))
	move_and_slide()

func _rotate_player(delta: float) -> void:
	var target_angle := (get_global_mouse_position() - global_position).angle()
	rotation = lerp_angle(rotation, target_angle + deg_to_rad(90.0), 1.0 - exp(-ROTATION_SPEED * delta))

func _push_objects() -> void:
	for i in get_slide_collision_count():
		var collision := get_slide_collision(i)
		if collision.get_collider() is RigidBody2D:
			collision.get_collider().apply_central_impulse(-collision.get_normal() * PUSH_OBJECTS_FORCE)
