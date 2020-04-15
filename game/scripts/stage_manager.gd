extends CanvasLayer

const STAGE_GAME = "res://stages/game_stage.tscn"
const STAGE_MENU = "res://stages/menu_stage.tscn"

var is_changing: bool = false

signal stage_changed


func _ready() -> void:
	pass # Replace with function body.


func change_stage(stage_path: String) -> void:
	if is_changing: return

	layer = 5 # This prevents this scene from blocking clickes to lower scenes
	is_changing = true
	get_tree().get_root().set_disable_input(true)

	$anim.play("fade_in")
	yield($anim, "animation_finished")

	get_tree().change_scene(stage_path)
	emit_signal("stage_changed")

	$anim.play("fade_out")
	yield($anim, "animation_finished")

	layer = 1
	is_changing = false
	get_tree().get_root().set_disable_input(false)
