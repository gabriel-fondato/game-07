extends Node2D

@export var enemyScene: PackedScene
@export var possibleEnemies: Array[EnemyData]
@export var spawnFromOutsideOfTheScreen: bool = true
@export_range(0,30) var cooldownTime
@export var enemyAmount: int = 3

func _ready() -> void:
	pass
	
func _spawnEnemy() -> void:
	var current_enemy:= enemyScene
	
