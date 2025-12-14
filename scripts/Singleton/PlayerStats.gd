extends Node

signal effect_added(effect: String)
signal effect_removed(effecr: String)

var score: int = 0
var start_time: float = 0.0
var effects: Array[String] = []

func add_points(points: int):
	score += points
	
func reset_score():
	score = 0

func add_effect(effect: String):
	if effect in effects:
		return
	effects.append(effect)
	effect_added.emit(effect)
	
func remove_effect(effect: String):
	if effect not in effects:
		return
	effects.erase(effect)
	effect_removed.emit(effect)
