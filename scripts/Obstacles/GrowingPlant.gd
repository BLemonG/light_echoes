extends StaticBody2D

@onready var area: Area2D = $Area2D
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var det: Area2D = $DetectionArea
@onready var coll: CollisionShape2D = $CollisionShape2D


@export var grow_scale := 20.0
@export var grow_speed = 1.0
@export var max_scale = 2.0
@export var min_scale = 1.0

var current_scale = 1.0
var is_growing = false
var collider_base_height = 0.0
var base_sprite_height = 0.0
var total_frames = 4
var player = null

func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")
	var tex = sprite.sprite_frames.get_frame_texture("growing", 0)
	base_sprite_height = tex.get_height()
	total_frames = sprite.sprite_frames.get_frame_count("growing")
	
func _process(delta: float) -> void:
	if is_growing and player.is_beam_mode():
		current_scale = min(current_scale + grow_speed * delta, max_scale)
	else:
		current_scale = max(current_scale - grow_speed * delta, min_scale)
		
	sprite.scale = Vector2(3, current_scale)	#3 as width of plant
	sprite.position = Vector2(0, - (base_sprite_height * (current_scale -1)) / 2.0)
	
	update_collider()
	update_animation()
	
func update_animation():
	var progress = (current_scale - min_scale) / (max_scale - min_scale)
	sprite.animation = "growing"
	var frame_idx = int(progress * (total_frames - 1))	
	sprite.frame = frame_idx

func update_collider():
	var shape = coll.shape as RectangleShape2D
	var height = base_sprite_height * current_scale
	shape.size.y = height
	coll.position.y = -height/2.0


func _on_detection_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		is_growing = true


func _on_detection_area_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		is_growing = false
