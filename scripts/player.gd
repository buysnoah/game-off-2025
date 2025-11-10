extends CharacterBody2D

signal died

@export var SPEED = 500.0
@export var HEALTH = 4

@export var MOVE_RIGIDITY = 9
@export var MOVE_FLOAT = 0.2

func die(killer):
	print("Player dided to " + killer.name)
	died.emit(killer)

func _physics_process(delta: float) -> void:
	var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	
	var desiredVelocity = direction * SPEED
	
	if direction:
		var weight = delta * MOVE_RIGIDITY
		velocity = velocity.lerp(desiredVelocity, weight)
	else:
		var deceleration = SPEED * delta * ( 1 / max(MOVE_FLOAT, 0.01) )
		velocity = velocity.move_toward(Vector2.ZERO, deceleration)

	move_and_slide()

func _on_clap_attack_hit(body) -> void:
	if "HEALTH" in body and body.has_method("die"):
		body.HEALTH -= 1
		if body.HEALTH <= 0:
			body.die()
		
