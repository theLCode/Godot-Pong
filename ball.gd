extends RigidBody2D
@export var ballSpeed = 500
var screenSize
var screenMargin = 32.0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	screenSize = get_viewport_rect().size
	print(screenSize.x)
	print(screenSize.y)
	position = (Vector2(screenSize.x / 2, screenSize.y / 2))
	var randDir = randf() * TAU
	var dir = Vector2(cos(randDir), sin(randDir))
	linear_velocity = dir * ballSpeed


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if global_position.y <= screenMargin:
		linear_velocity.y = abs(linear_velocity.y)
	elif global_position.y >= screenSize.y - screenMargin:
		linear_velocity.y = -abs(linear_velocity.y)
		
