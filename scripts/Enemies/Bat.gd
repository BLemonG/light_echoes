extends EnemyBase
class_name FlyingEnemy

@export var FLY_SPEED: float = 100
@export var FLY_ATTACK_RANGE: float = 80
@export var FLY_PERCEPTION_RANGE: float = 300
@export var WAIT_UNTIL_IDLE: float = 3


func _ready():
	super._ready()
	SPEED = FLY_SPEED
	ATTACK_RANGE = FLY_ATTACK_RANGE
	PERCEPTION_RANGE = FLY_PERCEPTION_RANGE
	timer.wait_time = WAIT_UNTIL_IDLE
	
	reactivity = Reactivity.REACT_TO_PARTICLE
	
func perform_idle(delta):
	if player.is_beam_mode():
		velocity = velocity.move_toward(-direction * SPEED, 100 * delta)
	else:	
		velocity = Vector2.ZERO
	update_sprite_and_ray("idle", "left")
	move_and_slide()

func perform_chase(delta):
	velocity = velocity.move_toward(direction * SPEED, 100 * delta)
	update_sprite_and_ray("chase", "left")
	move_and_slide()

func perform_attack(delta):
	velocity = velocity.move_toward(direction * SPEED, 200 * delta)
	update_sprite_and_ray("attack", "left")
	bite()
	move_and_slide()
	
func bite():
	get_tree().call_deferred("reload_current_scene")
