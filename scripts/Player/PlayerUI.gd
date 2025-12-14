extends CanvasLayer

@onready var label: Label = $ScoreLabel
@onready var bar: HBoxContainer = $HealthBar
@onready var container: HBoxContainer = $StatusEffectsContainer
@onready var effect_icons = {
	"webbed": $StatusEffectsContainer/WebbedIcon,
	"slimed": $StatusEffectsContainer/SlimedIcon
}

@export var FONT_SIZE: int = 25
@export var HEART_SCALE: float = 2.0
@export var EFFECT_SCALE: float = 1.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	label.add_theme_font_size_override("font_size", FONT_SIZE)
	bar.scale = Vector2(HEART_SCALE, HEART_SCALE)
	container.scale = Vector2(EFFECT_SCALE, EFFECT_SCALE)
	
	for icon in effect_icons.values():
		icon.visible = false
		
	PlayerStats.effect_added.connect(_on_effect_added)
	PlayerStats.effect_removed.connect(_on_effect_removed)

func _on_effect_added(effect: String) -> void:
	if effect_icons.has(effect):
		effect_icons[effect].visible = true
		print(str(effect) + " is visible")
	
func _on_effect_removed(effect: String) -> void:
	if effect_icons.has(effect):
		effect_icons[effect].visible = false
