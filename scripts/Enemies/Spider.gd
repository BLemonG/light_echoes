extends EnemyBase
class_name SpiderEnemy

@export var MOVE_SPEED: float = 100
@export var MOVE_ATTACK_RANGE: float = 80
@export var MOVE_PERCEPTION_RANGE: float = 500
@export var WAIT_UNTIL_IDLE: int = 3
@export var NUMBER_WEBS: int = 5
@export var WEB_RADIUS: float = 20.0
@export var WEB_SIZE: float = 0.3

var player_is_trapped: bool = false
var trapped_ref: Node = null


const WEB = preload("uid://csm0m2enatdo8")

func _ready():
	super._ready()
	SPEED = MOVE_SPEED
	ATTACK_RANGE = MOVE_ATTACK_RANGE
	PERCEPTION_RANGE = MOVE_PERCEPTION_RANGE
	timer.wait_time = WAIT_UNTIL_IDLE
	reactivity = Reactivity.REACT_TO_BOTH
	await get_tree().process_frame
	spawn_webs()


func spawn_webs():
	for i in range(NUMBER_WEBS):
		var web = WEB.instantiate()
		if not get_tree():
			await(0.5)		#it sometimes crahses here, just weak bridge
		var root = get_tree().current_scene
		root.add_child(web)
		web.scale = Vector2(WEB_SIZE, WEB_SIZE)
		var angle = randf() * TAU
		var dist = randf() * WEB_RADIUS
		var offset = Vector2(cos(angle), sin(angle)) * dist
		web.global_position = global_position + offset

		web.player_trapped.connect(_on_player_trapped)
		web.player_released.connect(_on_player_released)
		
func _on_player_trapped(player):
	player_is_trapped = true
	trapped_ref = player

func _on_player_released(player):
	if player == trapped_ref:
		player_is_trapped = false
		trapped_ref = null
	
func perform_idle(delta):
	velocity = Vector2.ZERO
	update_sprite_and_ray("idle","left")
		

func perform_chase(delta):
	if player_is_trapped:
		velocity = direction * SPEED
		update_sprite_and_ray("chase","left")
		move_and_slide()

func perform_attack(delta):
	if player_is_trapped:
		bite()
		velocity = direction * SPEED
		update_sprite_and_ray("attack","left")
		move_and_slide()
		
func bite():
	get_tree().call_deferred("reload_current_scene")
