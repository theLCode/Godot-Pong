extends Area2D
@export var rightSpeed = 600
var screenSize
signal rightHit

func _ready() -> void:
	screenSize = get_viewport_rect().size

# Processes the movement for right paddle, goes up or down
func _process(delta: float) -> void:
	var velocity = Vector2.ZERO
	if Input.is_action_pressed("rightPaddleDown"):
		velocity.y += 1
	if Input.is_action_pressed("rightPaddleUp"):
		velocity.y -= 1
	
	if velocity.length() > 0:
		velocity = velocity.normalized() * rightSpeed

	position += velocity * delta
	position = position.clamp(Vector2.ZERO, screenSize)

func start(pos):
	position = pos
	show()

func _on_body_entered(body: Node2D) -> void:
	rightHit.emit()
