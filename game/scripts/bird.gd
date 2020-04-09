extends RigidBody2D


func _ready():
	pass


func _input(event):
	if event.is_action_pressed("flap"):
		flap()


func _physics_process(delta):
	if rotation_degrees < -30: # Rising
		rotation_degrees = -30
		angular_velocity = 0

	if linear_velocity.y > 0: # Falling
		angular_velocity = 1.5


func flap():
	linear_velocity.y = -150
	angular_velocity = -3
