extends CharacterBody2D
class_name EnemyBase

enum States { IDLE, CHASE, ATTACK }
enum Reactivity {REACT_TO_BEAM, REACT_TO_PARTICLE, REACT_TO_BOTH}
var state = States.IDLE
var is_visible_on_screen = false

@export var reactivity: Reactivity = Reactivity.REACT_TO_BEAM

@onready var player: Player = null
@onready var ray: RayCast2D = $RayCast2D
@onready var timer: Timer = $Timer
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var vis_notifier: VisibleOnScreenEnabler2D = $VisibleOnScreenEnabler2D
@onready var attack_cooldown: Timer = $AttackCooldown

var direction: Vector2 = Vector2.ZERO
var SPEED: float = 0.0
var ATTACK_RANGE: float = 0.0
var PERCEPTION_RANGE: float = 0.0

func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")
	timer.one_shot = true
	add_to_group("enemy")
	
	attack_cooldown.wait_time = 2.0
	attack_cooldown.one_shot = true

func _physics_process(delta):
	if !player:
		print("No Player Found")
		return
		
	update_direction()
	update_state_based_on_player_mode()
	state_machine(delta)

			
func update_direction():
	direction = (player.global_position - global_position).normalized()
	
func update_sprite_and_ray(name: String, sprite_looking: String):
	if sprite_looking == "left":
		sprite.flip_h = direction.x < 0
	if sprite_looking =="right":
		sprite.flip_h = direction.x > 0 
	sprite.play(name)
	if ray:
		ray.target_position = direction.normalized() * PERCEPTION_RANGE

func state_machine(delta):
	match state:
		States.IDLE:
			_idle(delta)
		States.CHASE:
			_chase(delta)
		States.ATTACK:
			_attack(delta)

# -------- STATE WRAPPERS --------

func _idle(delta):
	perform_idle(delta)

func _chase(delta):
	perform_chase(delta)

func _attack(delta):
	perform_attack(delta)

# ---- ABSTRACT METHODS ----
func perform_idle(delta):
	pass

func perform_chase(delta):
	pass

func perform_attack(delta):
	pass

# -------- PLAYER DETECTION --------

func update_state_based_on_player_mode():
	var react_to_player: bool = false
	match reactivity:
		Reactivity.REACT_TO_BEAM:
			react_to_player = !player.is_particle_mode()
		Reactivity.REACT_TO_PARTICLE:
			react_to_player = player.is_particle_mode()
		Reactivity.REACT_TO_BOTH:
			react_to_player = true
	
	if react_to_player:
		#attack if in range
		var distance= player.global_position.distance_to(global_position)
		if player.global_position.distance_to(global_position) < ATTACK_RANGE:
			state = States.ATTACK
			return
		#raycast sees player -> chase
		if ray.is_colliding() and ray.get_collider() == player:
			chase_player()
			return
		stop_chase()
	else:
		state = States.IDLE
			
func chase_player() -> void:
	timer.stop()
	state = States.CHASE
	
func stop_chase() -> void:
	if timer.time_left <= 0:
		timer.start()

func _on_timer_timeout() -> void:
	state = States.IDLE


func _on_visible_on_screen_enabler_2d_screen_entered() -> void:
	is_visible_on_screen = true


func _on_visible_on_screen_enabler_2d_screen_exited() -> void:
	is_visible_on_screen = false
