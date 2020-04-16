extends RigidBody2D
class_name QBird, "res://sprites/bird_orange_0.png"

onready var state
var prev_state
enum states {
	STATE_FLYING
	STATE_FLAPPING
	STATE_HIT
	STATE_GROUNDED
	STATE_ERROR = -1
}
signal state_changed

var speed: int = 50


func _ready() -> void:
	connect("body_entered", self, "_on_body_entered")
	add_to_group(game.GROUP_BIRDS)

	set_state(states.STATE_FLYING)


func _input(event: InputEvent) -> void:
	state.input(event)


func _physics_process(delta: float) -> void:
	state.update(delta)


func _on_body_entered(other_body: Node) -> void:
	state.on_body_entered(other_body)


func set_state(new_state: int) -> void:
	if state:
		state.exit()

	prev_state = get_state()

	if   new_state == states.STATE_FLYING:   state = FlyingState.new(self)
	elif new_state == states.STATE_FLAPPING: state = FlappingState.new(self)
	elif new_state == states.STATE_HIT:      state = HitState.new(self)
	elif new_state == states.STATE_GROUNDED: state = GroundedState.new(self)
	else:
		print("Error: Unexpected state (%d)" % new_state)

	emit_signal("state_changed", self)


func get_state() -> int:
	if   state is FlyingState:   return states.STATE_FLYING
	elif state is FlappingState: return states.STATE_FLAPPING
	elif state is HitState:      return states.STATE_HIT
	elif state is GroundedState: return states.STATE_GROUNDED
	else: return states.STATE_ERROR


# #############
# STATE MACHINE
# #############
class BirdState:
	var bird: QBird

	func _init(bird: QBird) -> void:
		self.bird = bird
		pass

	func update(delta: float) -> void:
		pass

	func input(event: InputEvent) -> void:
		pass

	func on_body_entered(other_body: Node) -> void:
		pass

	func exit() -> void:
		pass

# -------------------------------------------------------------------------
class FlyingState extends BirdState:
	var previous_gravity_scale: float

	func _init(b: QBird).(b) -> void:
		bird.get_node("anim").play("fly")

		previous_gravity_scale = bird.gravity_scale
		bird.gravity_scale = 0
		bird.linear_velocity.x = bird.speed


	func exit() -> void:
		bird.gravity_scale = previous_gravity_scale

		bird.get_node("anim").stop()
		bird.get_node("anim_sprite").position = Vector2.ZERO


# -------------------------------------------------------------------------
class FlappingState extends BirdState:
	func _init(b: QBird).(b) -> void:
		bird.linear_velocity.x = bird.speed
		flap()


	func update(delta: float) -> void:
		if bird.rotation_degrees < -30: # Rising
			bird.rotation_degrees = -30
			bird.angular_velocity = 0

		if bird.linear_velocity.y > 0: # Falling
			bird.angular_velocity = 1.5


	func input(event: InputEvent) -> void:
		if event.is_action_pressed("flap"):
			flap()
		elif(event.is_pressed() and event.button_index == BUTTON_LEFT):
			flap()


	func on_body_entered(other_body: Node) -> void:
		if other_body.is_in_group(game.GROUP_PIPES):
			bird.set_state(bird.states.STATE_HIT)
		elif other_body.is_in_group(game.GROUP_GROUNDS):
			bird.set_state(bird.states.STATE_GROUNDED)


	func flap() -> void:
		bird.linear_velocity.y = -150
		bird.angular_velocity = -3
		bird.get_node("anim").play("flap")

		audio_player.get_node("sfx_wing").play()


# -------------------------------------------------------------------------
class HitState extends BirdState:
	func _init(b: QBird).(b) -> void:
		bird.linear_velocity = Vector2.ZERO
		bird.angular_velocity = 2

		var other_body: Node = bird.get_colliding_bodies()[0]
		bird.add_collision_exception_with(other_body)

		audio_player.get_node("sfx_hit").play()
		audio_player.get_node("sfx_die").play()

	func on_body_entered(other_body: Node) -> void:
		if other_body.is_in_group(game.GROUP_GROUNDS):
			bird.set_state(bird.states.STATE_GROUNDED)


# -------------------------------------------------------------------------
class GroundedState extends BirdState:
	func _init(b: QBird).(b) -> void:
		bird.linear_velocity = Vector2.ZERO
		bird.angular_velocity = 0

		if bird.prev_state != bird.states.STATE_HIT:
			audio_player.get_node("sfx_hit").play()
