extends Node2D

@export var enemyScene: PackedScene
@export var possibleEnemies: Array[EnemyData]
@export var spawnFromOutsideOfTheScreen: bool = true
@export_range(0, 30) var cooldownTime: float = 2.0
@export var enemyAmount: int = 3

var currentEnemyCount: int = 0

func _ready() -> void:
	$Timer.wait_time = cooldownTime
	$Timer.one_shot = false
	$Timer.timeout.connect(_on_timer_timeout)
	$Timer.start()

func _on_timer_timeout() -> void:
	if currentEnemyCount < enemyAmount:
		_spawnEnemy()

func _spawnEnemy() -> void:
	if possibleEnemies.is_empty():
		push_warning("No enemy data assigned in possibleEnemies!")
		return
	
	var current_enemy := enemyScene.instantiate()
	current_enemy.data = possibleEnemies[randi() % possibleEnemies.size()]
	current_enemy.global_position = _get_spawn_position()

	get_tree().current_scene.add_child(current_enemy)
	currentEnemyCount += 1

	current_enemy.tree_exited.connect(func(): currentEnemyCount -= 1)

func _get_spawn_position() -> Vector2:
	var viewport_rect := get_viewport_rect()
	var screen_size := viewport_rect.size

	if spawnFromOutsideOfTheScreen:
		var edge := randi() % 4
		match edge:
			0: return Vector2(randf_range(0, screen_size.x), -50) # top
			1: return Vector2(randf_range(0, screen_size.x), screen_size.y + 50) # bottom
			2: return Vector2(-50, randf_range(0, screen_size.y)) # left
			_: return Vector2(screen_size.x + 50, randf_range(0, screen_size.y)) # right
	else:
		return Vector2(randf_range(0, screen_size.x), randf_range(0, screen_size.y))
