extends EnemyBase
class_name FlyingEnemy2

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

	reactivity = Reactivity.REACT_TO_BEAM

func perform_idle(delta):
	velocity = velocity.move_toward(Vector2.ZERO, 100 * delta) 
	update_sprite_and_ray("flying", "left")
	move_and_slide()

func perform_chase(delta):
	if not player.is_beam_mode():
		pass 
		
	velocity = velocity.move_toward(direction * SPEED, 100 * delta)
	update_sprite_and_ray("flying", "left")
	move_and_slide()

func perform_attack(delta):
	if not attack_cooldown.is_stopped():
		velocity = Vector2.ZERO
		return
		
	bite()
	attack_cooldown.start()
	velocity = velocity.move_toward(direction * SPEED, 200 * delta)
	update_sprite_and_ray("attack", "left")
	move_and_slide()
	
func bite():
	if player.has_method("take_damage"):
		player.take_damage()
	
func die():
	set_physics_process(false) 
	collision.set_deferred("disabled", true)
	animated.play("dying") 
	var tween = create_tween()
	tween.set_parallel(true) 
	tween.tween_property(self, "position:y", position.y + 500, 1.5).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
	tween.tween_property(self, "rotation_degrees", 90.0, 1.5)
	tween.tween_property(self, "modulate:a", 0.0, 1.5)
	tween.chain().tween_callback(queue_free)
