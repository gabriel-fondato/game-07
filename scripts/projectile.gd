# projectile.gd
extends Area2D

var data: ProjectileData
var direction: Vector2 = Vector2.RIGHT
var velocity: Vector2
var bodiesPierced

@onready var sprite: Sprite2D = $sprite

func _ready() -> void:
	body_entered.connect(_on_body_entered)


	velocity = direction.normalized() * data.speed
	sprite.texture = data.sprite_texture

	await get_tree().create_timer(data.lifetime).timeout
	queue_free()

func _physics_process(delta: float) -> void:
	position += velocity * delta

func _on_body_entered(body: Node2D) -> void:
	if not data:
		return
	if body.has_method("take_damage"):
		body.take_damage(data.damage)
		bodiesPierced =+ 1
		if data.piercing:
			if data.pierceLevel < bodiesPierced:
				queue_free()
			else:
				queue_free()
	if data.explosion_radius > 0:
		_explode()

func _explode() -> void:
	# TODO: query bodies in data.explosion_radius and apply damage/knockback
	pass
