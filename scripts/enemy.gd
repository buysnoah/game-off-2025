extends CharacterBody2D

@export var TARGET: Node2D

@export var MIN_DISTANCE = 100

@export var ATTACK_TIME: float = 1
@export var DAMAGE: float = 1

@export var SPEED = 300.0
@export var HEALTH = 3

@export var MOVEMENT_RIGIDITY: float = 0.9

func die():
	DAMAGE = 0
	SPEED = 0
	$AnimationPlayer.play("die")
	await $AnimationPlayer.animation_finished
	queue_free()

func take_damage(damage):
	HEALTH = max(0, HEALTH - damage)
	if HEALTH == 0:
		die()

func _ready() -> void:
	$AttackTimer.wait_time = ATTACK_TIME

func _physics_process(delta: float) -> void:
	var old_direction = velocity.normalized()
	var direction = old_direction 
	
	if TARGET:
		direction = position.direction_to(TARGET.position) 
		direction = old_direction.lerp(direction, MOVEMENT_RIGIDITY)
	
	var desired_velocity = direction.normalized() * SPEED
	
	velocity = velocity.lerp(desired_velocity, delta)

	move_and_slide()

func _on_hurtbox_body_entered(body: Node2D) -> void:
	if body.has_method("take_damage"):
		while body in $Hurtbox.get_overlapping_bodies():
			var damage = DAMAGE
			
			var info = body.take_damage(damage, self)
			DamageNumbers.display_number(info.damage_taken, body.position, info.is_killing_blow)
			
			if info.is_killing_blow:
				$Sprite2D.modulate = Color(0.0, 0.62, 0.0, 1.0)
				
			$AttackTimer.start()
			await $AttackTimer.timeout
