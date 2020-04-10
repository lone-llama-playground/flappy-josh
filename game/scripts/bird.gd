extends RigidBody2D
class_name QBird # Why QBird?


func _ready() -> void:
	linear_velocity.x = 50
	pass


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("flap"):
		flap()


func _physics_process(delta: float) -> void:
	if rotation_degrees < -30: # Rising
		rotation_degrees = -30
		angular_velocity = 0

	if linear_velocity.y > 0: # Falling
		angular_velocity = 1.5


func flap() -> void:
	linear_velocity.y = -150
	angular_velocity = -3
