extends Node
const MAXSCORE = 5
@export var ballScene : PackedScene
var gameActive
var leftScore
var rightScore
var ball
@onready var leftScoreLabel = $HUD/LeftScore
@onready var rightScoreLabel = $HUD/RightScore
@onready var messageLabel = $HUD/Message
@onready var startButton = $HUD/StartButton

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$LeftPlayer.hide()
	$RightPlayer.hide()
	leftScoreLabel.hide()
	rightScoreLabel.hide()
	messageLabel.hide()
	startButton.show()
	gameActive = false

func _process(delta: float) -> void:
	if !gameActive and Input.is_action_pressed("spaceBar"):
		newGame()
	#need to figure out timer
	#else:
		#messageLabel.hide()
		#startButton.show()
		
	if gameActive:
		hasScored()
		newServe()

# Called whenever a new game is created
func newGame():
	gameActive = true
	leftScore = 0
	rightScore = 0
	$LeftPlayer.start($LeftPaddleStart.position)
	$RightPlayer.start($RightPaddleStart.position)
	leftScoreLabel.show()
	rightScoreLabel.show()
	startButton.hide()
	newServe()

# Called whenever a new ball needs to get served (when a ball leaves the screen)
func newServe():
	#if there's no ball and spacebar is pressed, start a new serve
	if ball == null and Input.is_action_pressed("spaceBar"):
		ball = ballScene.instantiate()
		add_child(ball)

func newBallVel(absX):
	ball.ballSpeed += 50
	ball.linear_velocity = ball.randLinearVel()
	ball.linear_velocity.x = absX

func hasScored():
	#if ball is still in the game but behind paddles
	#	update score based off of position
	if !(ball == null):
		if ball.position.x < $LeftPlayer.position.x - 32:
			updateScore("right")
		elif ball.position.x > $RightPlayer.position.x + 32:
			updateScore("left")

func updateScore(paddle : String):
	if paddle == "left":
		leftScore += 1
		leftScoreLabel.text = str(leftScore)
	else:
		rightScore += 1
		rightScoreLabel.text = str(rightScore)
	if leftScore == MAXSCORE or rightScore == MAXSCORE:
		messageLabel.text = "Blue Paddle Wins!" if leftScore > rightScore else "Pink Paddle Wins!"
		messageLabel.show()
		startButton.show()
		gameActive = false
	ball.queue_free()

#change direction of the ball based off of which paddle hit ball
func _on_leftHit() -> void:
	newBallVel(abs(ball.linear_velocity.x))
func _on_rightHit() -> void:
	newBallVel(-abs(ball.linear_velocity.x))
