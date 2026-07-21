extends RigidBody2D

var data: EnemyData
var direction: = Vector2.LEFT
var velocity

@onready var sprite: Sprite2D = $sprite

func _ready() -> void:
	
	velocity = direction.normalized() * data.speed
	sprite.texture = data.sprite_texture
