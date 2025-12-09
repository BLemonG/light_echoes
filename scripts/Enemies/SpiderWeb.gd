extends Area2D
class_name WebArea

signal player_trapped(player)
signal player_released(player)

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

func _process(delta: float) -> void:
	sprite.play("default")

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		emit_signal("player_trapped", body)
		body.apply_status_effect("webbed")


func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		emit_signal("player_released", body)
		body.remove_status_effect("webbed")
