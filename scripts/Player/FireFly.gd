extends CharacterBody2D
class_name Player

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var next_level_timer: Timer = $NextLevelTimer

@export var SLIMED_TIMER = 5.0
@export var SLIME_EFFECT = Vector2(0.7, 10000)
var SPEED = 300.0
var particle_mode := true
var beam_mode := false

var aim_dir = Vector2.RIGHT #as default
var slimed = false
var timer


func _ready():
	add_to_group("player")
	
func _process(delta):
	sprite.play("default")
	var input = Vector2(
		Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"),
		Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	)
	if input != Vector2.ZERO:
		sprite.flip_h = input.x > 0
		velocity = input.normalized() * SPEED
		aim_dir = input.normalized() 
		
	else:
		velocity = Vector2.ZERO
		
	if slimed:
		velocity.x *= SLIME_EFFECT.x
		velocity.y += SLIME_EFFECT.y * delta
		timer -= delta
		if timer <= 0:
			slimed = false
			timer = SLIMED_TIMER
	move_and_slide()

	if Input.is_action_just_pressed("space"):   # space for party
		particle_mode = !particle_mode
		beam_mode = !beam_mode
		print("ParticleMode: ", particle_mode, "BeamMode: ", beam_mode)
		
func is_particle_mode():
	return particle_mode

func is_beam_mode():
	return beam_mode

func get_beam_origin():
	return global_position
	
func get_beam_direction():
	return aim_dir
	
func apply_status_effect(effect: String):
	if (effect == "webbed"):
		SPEED = SPEED/2
	if (effect == "slimed"):
		slimed = true
		timer = SLIMED_TIMER
		
		
func remove_status_effect(effect: String):
	if (effect == "webbed"):
		SPEED = SPEED*2
		
func go_to_next_level():
	next_level_timer.start()
	
func _on_next_level_timer_timeout() -> void:
	get_tree().call_deferred("reload_current_scene")
