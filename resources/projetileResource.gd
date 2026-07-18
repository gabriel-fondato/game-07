# projectile_data.gd
extends Resource
class_name ProjectileData

@export var speed: float = 300.0
@export var damage: int = 10
@export var cooldown: float = 1
@export var lifetime: float = 5.0
@export var sprite_texture: Texture2D
@export var piercing: bool = false
@export var pierceLevel: int = 1
@export var explosion_radius: float = 0.0
@export var bounceOnWalls: bool = false
@export var bounceOnEnemies: bool = false
@export_range(0,100) var enemyBounceChance
@export var roaming: bool = false
@export var roamingRange: float = 0
@export var roamingDelay: float = 0
