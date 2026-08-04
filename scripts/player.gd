extends CharacterBody2D

@export var SPEED := 300.0
@export var ACCELERATION := 10.0      # higher = snappier speed changes
@export var ROTATION_SPEED := 10.0    # higher = snappier turning
@export var PUSH_OBJECTS_FORCE := 20.0
@export var player_should_move := true
@export var projectileScene : PackedScene
@export var projectileTypes: Array[ProjectileData]
var currentProjectile := 2
var ammountOfAvaliableProjectiles := 3
var canShoot := true

func _physics_process(delta: float) -> void:
	_move_player(delta)
	_rotate_player(delta)
	_push_objects()
#	_projectile_switcher()
	_check_fireButton()

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

func shoot() -> void:
	var proj := projectileScene.instantiate()
	proj.data = projectileTypes.get(currentProjectile)
	proj.rotation = rotation
	proj.direction = Vector2.UP.rotated(rotation)
	proj.global_position = global_position
	get_tree().current_scene.add_child(proj)
	canShoot = false
	$weaponCooldownTimer.start(proj.data.cooldown)
	
func _projectile_switcher() -> void:
	ammountOfAvaliableProjectiles = projectileTypes.size()
	if Input.is_action_just_pressed("switchWeaponRight"):
		currentProjectile += 1
		if currentProjectile >= ammountOfAvaliableProjectiles:
			currentProjectile = 0
	if Input.is_action_just_pressed("switchWeaponLeft"):
		currentProjectile -= 1
		if currentProjectile < 0:
			currentProjectile = ammountOfAvaliableProjectiles - 1
	
func _check_fireButton() -> void:
	if Input.is_action_pressed("fire1") and canShoot:
		shoot()
		

func _on_weapon_cooldown_timer_timeout() -> void:
	canShoot = true
