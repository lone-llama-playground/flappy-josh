extends Node2D
class_name QSpawnerPipe

onready var scn_pipe: PackedScene = preload("res://scenes/pipe.tscn")

const PIPE_WIDTH: int = 26
const GROUND_HEIGHT = 55
const OFFSET_X: int = 65
const OFFSET_Y: int = 55
const AMOUNT_TO_FILL_VIEW: int = 3

func _ready() -> void:
	go_init_position()

	for i in range(AMOUNT_TO_FILL_VIEW):
		spawn_and_move()

func go_init_position() -> void:
	randomize()

	var init_pos: Vector2 = Vector2()
	var viewport_size: Vector2 = get_viewport_rect().size

	init_pos.x = viewport_size.x + (PIPE_WIDTH / 2)
	init_pos.y = rand_range(0 + OFFSET_Y, viewport_size.y - GROUND_HEIGHT - OFFSET_Y)

	position = init_pos

func spawn_and_move() -> void:
	spawn_pipe()
	go_next_position()

func spawn_pipe() -> void:
	var new_pipe: QPipe = scn_pipe.instance()

	new_pipe.position = position
	new_pipe.connect("tree_exited", self, "spawn_and_move")

	$container.add_child(new_pipe)

func go_next_position() -> void:
	randomize()

	var next_pos: Vector2 = position
	var viewport_size: Vector2 = get_viewport_rect().size

	next_pos.x += (PIPE_WIDTH / 2) + OFFSET_X + (PIPE_WIDTH / 2)
	next_pos.y = rand_range(0 + OFFSET_Y, viewport_size.y - GROUND_HEIGHT - OFFSET_Y)

	position = next_pos
