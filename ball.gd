extends RigidBody2D
@export var ballSpeed = 800
var screenSize
var screenMargin = 28.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	screenSize = get_viewport_rect().size
	position = (Vector2(screenSize.x / 2, screenSize.y / 2))
	linear_velocity = randLinearVel()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if global_position.y <= screenMargin:
		linear_velocity.y = abs(linear_velocity.y)
	elif global_position.y >= screenSize.y - screenMargin:
		linear_velocity.y = -abs(linear_velocity.y)

func createRandVectValue():
	return Vector2(cos(randf() * TAU), sin(randf() * TAU))

func randLinearVel():
	return createRandVectValue() * ballSpeed

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
