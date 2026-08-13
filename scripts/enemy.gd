extends RigidBody2D

@export var data: EnemyData
var direction: = Vector2.RIGHT
var velocity
var shouldMove:= true
var health:= 100

@onready var sprite: Sprite2D = $sprite

func _ready() -> void:
	pass
	sprite.texture = data.sprite
	health = data.health

func _physics_process(delta: float) -> void:
	_checkIfIsOnCenter()
	if (shouldMove):
		_move()
	
func _move() -> void:
	direction = -position - Vector2.ZERO
	#print("linear velocity: ", linear_velocity)
	if (linear_velocity.x < data.maxAceleration or linear_velocity.y < data.maxAceleration or linear_velocity.x < -data.maxAceleration or linear_velocity.y < -data.maxAceleration):
		apply_central_force(direction.normalized() * data.speed)
	else:
		apply_central_force(-linear_velocity.normalized())
	
func _checkIfIsOnCenter() -> void:
	#print(position)
	pass
func take_damage(damage) -> void:
	health -= damage
	if (health <= 0):
		queue_free()
