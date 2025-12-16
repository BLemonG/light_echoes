extends Area2D

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var area: Area2D = $DetectionArea
@onready var coll: CollisionShape2D = $CollisionShape2D

var player = null
var extend = false
var base_sprite_height = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")
	coll.disabled = true

func _process(delta: float) -> void:
	if player.is_particle_mode():
		sprite.play("spike")
		coll.disabled = false
		
	else:
		sprite.play("idle")
		coll.disabled = true
		

func _on_detection_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		extend = true

func _on_detection_area_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		extend = false

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		body.die()
	if body.is_in_group("enemy") and body.is_visible_on_screen:
		body.queue_free()
		print("spike hit enemy (+10 points)")
		PlayerStats.add_points(10)
		
