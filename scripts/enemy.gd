extends CharacterBody2D

@export var TARGET: Node2D

@export var MIN_DISTANCE = 100

@export var ATTACK_TIME: float = 1

@export var SPEED = 500.0
@export var HEALTH = 3

@export var MOVEMENT_RIGIDITY = 0.9
@export var MOVEMENT_FLOAT = 2

func die():
	print("Wahahhhhhh! I died.")
	queue_free()

func _ready() -> void:
	$AttackTimer.wait_time = ATTACK_TIME

func _physics_process(delta: float) -> void:
	var direction
	
	if TARGET:
		direction = TARGET.position - position
	else:
		direction = velocity
	
	var desiredVelocity = direction.normalized() * SPEED
	
	if direction.length() > MIN_DISTANCE:
		var weight = delta * MOVEMENT_RIGIDITY
		velocity = velocity.lerp(desiredVelocity, weight)
	else:
		var deceleration = SPEED * delta * ( 1 / max(MOVEMENT_FLOAT, 0.01) )
		velocity = velocity.move_toward(Vector2.ZERO, deceleration)

	move_and_slide()

func _on_hurtbox_body_entered(body: Node2D) -> void:
	if "HEALTH" in body and body.has_method("die_to"):
		while body in $Hurtbox.get_overlapping_bodies():
			body.HEALTH -= 1
			var killed = body.HEALTH <= 0
			
			DamageNumbers.display_number(1, body.position)
			
			if killed:
				body.die_to(self)
			
			$AttackTimer.start()
			await $AttackTimer.timeout
