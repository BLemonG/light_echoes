extends EnemyBase
class_name FlyingEnemy

@export var FLY_SPEED: float = 200
@export var FLY_ATTACK_RANGE: float = 80
@export var FLY_PERCEPTION_RANGE: float = 300
@export var WAIT_UNTIL_IDLE: float = 3
@onready var animated: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision: CollisionShape2D = $CollisionShape2D

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
	update_sprite_and_ray("flying", "left")
	move_and_slide()

func perform_chase(delta):
	velocity = velocity.move_toward(direction * SPEED, 100 * delta)
	update_sprite_and_ray("flying", "left")
	move_and_slide()

var is_attacking: bool = false

func perform_attack(delta):
	if is_attacking:
		velocity = velocity.move_toward(Vector2.ZERO, 100 * delta)
		move_and_slide()
		return

	if not attack_cooldown.is_stopped():
		velocity = Vector2.ZERO
		move_and_slide()
		return
	start_attack_sequence()

func start_attack_sequence():
	is_attacking = true
	update_sprite_and_ray("attack", "left") 
	animated.play("attack")
	velocity = direction * (SPEED * 1.5)
	await animated.animation_finished
	bite()
	attack_cooldown.start()
	is_attacking = false
	
func bite():
	player.take_damage()
	
func die():
	set_physics_process(false)
	collision.set_deferred("disabled", true)
	PlayerStats.add_points(20)
	animated.play("dying")
	await sprite.animation_finished
	
	queue_free()
	
