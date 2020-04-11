extends Node


const GROUP_PIPES   = "pipes"
const GROUP_GROUNDS = "grounds"
const GROUP_BIRDS   = "birds"

var score_best: int = 0 setget _set_score_best
var score_current: int = 0 setget _set_score_current

signal score_best_changed
signal score_current_changed


func _ready() -> void:
	pass


func _set_score_best(new_value: int) -> void:
	score_best = new_value
	emit_signal("score_best_changed")


func _set_score_current(new_value: int) -> void:
	score_current = new_value
	emit_signal("score_current_changed")
