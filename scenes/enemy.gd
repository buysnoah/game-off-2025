extends CharacterBody2D

@export var TARGET: Node2D

@export var MIN_DISTANCE = 100

@export var ATTACK_TIME: float = 1

@export var SPEED = 500.0

@export var MOVEMENT_RIGIDITY = 0.9
@export var MOVEMENT_FLOAT = 2

func _ready() -> void:
	$AttackTimer.wait_time = ATTACK_TIME

func _physics_process(delta: float) -> void:
	var direction = TARGET.position - position
	
	var desiredVelocity = direction.normalized() * SPEED
	
	if direction.length() > MIN_DISTANCE:
		var weight = delta * MOVEMENT_RIGIDITY
		velocity = velocity.lerp(desiredVelocity, weight)
	else:
		var deceleration = SPEED * delta * ( 1 / max(MOVEMENT_FLOAT, 0.01) )
		velocity = velocity.move_toward(Vector2.ZERO, deceleration)

	move_and_slide()


func _on_hurtbox_body_entered(body: Node2D) -> void:
	while body in $Hurtbox.get_overlapping_bodies():
		print("Attack!!")
		$AttackTimer.start()
		await $AttackTimer.timeout
