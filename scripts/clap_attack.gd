extends Node2D

signal hit(body: PhysicsBody2D)

@export var CLAP_SPEED: float = 1
@export var RADIUS = 200

func _ready() -> void:
	$Timer.wait_time = 1 / CLAP_SPEED
	var circle = $Area2D/CollisionShape2D.shape as CircleShape2D 
	circle.radius = RADIUS

func _process(_delta: float) -> void:
	pass

func _on_timer_timeout() -> void:
	$Sprite2D.visible = true
	
	for body in $Area2D.get_overlapping_bodies():
		hit.emit(body)
	
	await get_tree().create_timer(0.2).timeout
	$Sprite2D.visible = false
