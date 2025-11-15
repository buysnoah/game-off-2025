extends Node2D

#signal hit(body: PhysicsBody2D)

@export var CLAP_SPEED: float = 1
@export var DAMAGE: float = 1
@export var FORCE: float = 600

var is_attacking = false

func attack():
	if is_attacking:
		return
	
	is_attacking = true
	$Sprite2D.visible = true
	
	for body in $Area2D.get_overlapping_bodies():
		if body.has_method("take_damage"):
			body.take_damage(DAMAGE)
			DamageNumbers.display_number(DAMAGE, body.position)
		
			body.velocity += global_position.direction_to(body.global_position) * FORCE
	
	await get_tree().create_timer(0.2).timeout
	$Sprite2D.visible = false
	is_attacking = false    

func _ready() -> void:
	$Timer.wait_time = 1 / CLAP_SPEED

func _process(_delta: float) -> void:
	pass

func _on_timer_timeout() -> void:
	attack()
