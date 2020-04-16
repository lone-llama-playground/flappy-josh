extends Node2D
class_name QSpawnerPipe, "res://sprites/pipe_green_top.png"

onready var scn_pipe: PackedScene = preload("res://scenes/pipe.tscn")

const PIPE_WIDTH: int = 26
const GROUND_HEIGHT = 55
const OFFSET_X: int = 65
const OFFSET_Y: int = 55
const AMOUNT_TO_FILL_VIEW: int = 3


func _ready() -> void:
	var bird: QBird = utils.get_main_node().get_node("bird")
	if bird:
		bird.connect("state_changed", self, "_on_bird_state_changed", [], CONNECT_ONESHOT)


func _on_bird_state_changed(bird: QBird) -> void:
	if bird.get_state() == bird.states.STATE_FLAPPING:
		start()


func start() -> void:
	go_init_position()

	for i in range(AMOUNT_TO_FILL_VIEW):
		spawn_and_move()


func go_init_position() -> void:
	randomize()

	var init_pos: Vector2 = Vector2()
	var viewport_size: Vector2 = get_viewport_rect().size

	init_pos.x = viewport_size.x + (PIPE_WIDTH / 2)
	init_pos.y = rand_range(0 + OFFSET_Y, viewport_size.y - GROUND_HEIGHT - OFFSET_Y)

	var camera: QCamera = utils.get_main_node().get_node("camera")
	if camera:
		init_pos.x += camera.get_total_position().x

	position = init_pos


func spawn_and_move() -> void:
	if is_inside_tree():
		spawn_pipe()
		go_next_position()


func spawn_pipe() -> void:
	var new_pipe: QPipe = scn_pipe.instance()
	new_pipe.connect("tree_exited", self, "spawn_and_move")
	new_pipe.position = position
	$container.call_deferred("add_child", new_pipe)


func go_next_position() -> void:
	randomize()

	var next_pos: Vector2 = position
	var viewport_size: Vector2 = get_viewport_rect().size

	next_pos.x += (PIPE_WIDTH / 2) + OFFSET_X + (PIPE_WIDTH / 2)
	next_pos.y = rand_range(0 + OFFSET_Y, viewport_size.y - GROUND_HEIGHT - OFFSET_Y)

	position = next_pos
