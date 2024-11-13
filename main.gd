extends Node
@export var ballScene : PackedScene
var leftScore
var rightScore
var ball


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	newGame()

func _process(delta: float) -> void:
	hasScored()
	print(leftScore, rightScore)

# Called whenever a new ball needs to get served (when a ball leaves the screen)
func newServe():
	ball = ballScene.instantiate()
	add_child(ball)

# Called whenever a new game is created
func newGame():
	leftScore = 0
	rightScore = 0
	$LeftPlayer.start($LeftPaddleStart.position)
	$RightPlayer.start($RightPaddleStart.position)
	newServe()

func newBallVel(absX):
	ball.ballSpeed += 50
	ball.linear_velocity = ball.randLinearVel()
	ball.linear_velocity.x = absX

func hasScored():
	if !(ball == null):
		if ball.position.x < $LeftPlayer.position.x - 32:
			rightScore += 1
			ball.queue_free()
		elif ball.position.x > $RightPlayer.position.x + 32:
			leftScore += 1
			ball.queue_free()

func _on_leftHit() -> void:
	newBallVel(abs(ball.linear_velocity.x))
	
func _on_rightHit() -> void:
	newBallVel(-abs(ball.linear_velocity.x))
