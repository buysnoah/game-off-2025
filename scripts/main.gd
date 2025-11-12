extends Node

@export var camera: Camera2D
@export var enemy: PackedScene
@export var player: Node2D

func _ready() -> void:
	camera.reparent($Player)
	var e = enemy.instantiate()
	e.TARGET = player
	add_child(e)
	

func _process(_delta: float) -> void:
	pass

func _on_player_died(killer) -> void:
	camera.reparent(killer)
	$Player.queue_free()
