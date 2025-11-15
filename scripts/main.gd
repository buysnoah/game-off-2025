extends Node

@export var camera: Camera2D
@export var enemy: PackedScene
@export var player: Node2D

func _ready() -> void:
	camera.reparent($Player)
	
	while player:
		for i in range(10):
			var e: CharacterBody2D = enemy.instantiate()
			e.TARGET = player
			e.position = player.position + Vector2.from_angle(randf() * TAU) * 1000
			add_child(e)
			
		await $WaveTimer.timeout
	
	
func _process(_delta: float) -> void:
	pass

func _on_player_died(killer) -> void:
	camera.drag_vertical_enabled = false
	camera.drag_horizontal_enabled = false
	
	#camera.position_smoothing_enabled = false
	
	camera.reparent(killer, false)
	$Player.queue_free()
