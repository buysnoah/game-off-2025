extends CharacterBody2D

signal died

@export var SPEED: float = 670
@export var ROTATION_SPEED: float = PI
@export var MAX_HEALTH: float = 10
@export var DECELERATION_FACTOR: float = 0.67

var health = MAX_HEALTH
var dead = false

func die(killer):
	dead = true
	
	if killer:
		print("Player died to " + killer.name)
	else:
		print("Player died")
	
	died.emit(killer)
	
func take_damage(damage, attacker):
	if dead or !$InvincibilityTimer.is_stopped():
		return {is_killing_blow = false, damage_taken = 0}
	
	$InvincibilityTimer.start()
	
	health = max(0, health - damage)
	
	var is_killing_blow = false
	if health == 0:
		die(attacker)
		is_killing_blow = true
		
	print("%d / %d" % [health, MAX_HEALTH])
	
	return {is_killing_blow = is_killing_blow, damage_taken = damage}

func _physics_process(delta: float) -> void:
	var rotation_direction = Input.get_axis("move_left", "move_right")
	var forward = transform.x
	
	var rotation_speed = ROTATION_SPEED
	if Input.is_action_pressed("move_down"):
		var deceleration = SPEED * delta * DECELERATION_FACTOR
		velocity = velocity.move_toward(Vector2.ZERO, deceleration)
		rotation_speed *= 1.5
	else:
		velocity = forward * SPEED
		
	if Input.is_action_pressed("move_up"):
		pass
		
	rotation += rotation_direction * rotation_speed * delta
	
	move_and_slide()
	
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("attack"):
		$ClapAttack.attack()
