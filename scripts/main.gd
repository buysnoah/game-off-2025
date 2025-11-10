extends Node

@export var camera: Camera2D

func _ready() -> void:
	camera.reparent($Player)

func _process(_delta: float) -> void:
	pass

func _on_player_died(killer) -> void:
	camera.reparent(killer)
	$Player.queue_free()
