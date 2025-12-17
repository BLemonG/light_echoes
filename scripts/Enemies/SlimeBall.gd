extends RigidBody2D

@onready var area: Area2D = $DetectionArea


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	area.body_entered.connect(_on_detection_area_body_entered)

func _on_detection_area_body_entered(body: Node2D) -> void:	
	if body.is_in_group("player"):
		body.apply_status_effect("slimed")
		queue_free()
	if body.is_in_group("environment"):
		queue_free()
