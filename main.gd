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
		
	if gameActive:
		hasScored()
		newServe()

# Called whenever a new game is created
func newGame():
	gameActive = true
	leftScore = 0
	rightScore = 0
	leftScoreLabel.text = str(leftScore)
	rightScoreLabel.text = str(rightScore)
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
	print(leftScore, rightScore)
	if !(ball == null):
		if ball.position.x < $LeftPlayer.position.x - 32:
			updateScore("right")
		elif ball.position.x > $RightPlayer.position.x + 32:
			updateScore("left")

func updateScore(paddle : String):
	print(leftScore, rightScore)
	if paddle == "left":
		leftScore += 1
	else:
		rightScore += 1
	
	if leftScore > 5:
		leftScore = 5
	elif rightScore > 5:
		rightScore = 5
		
	leftScoreLabel.text = str(leftScore)
	rightScoreLabel.text = str(rightScore)
		
	print(leftScore, rightScore)
	if leftScore == MAXSCORE or rightScore == MAXSCORE:
		messageLabel.text = "Blue Paddle Wins!" if leftScore > rightScore else "Pink Paddle Wins!"
		messageLabel.show()
		await get_tree().create_timer(2.0).timeout
		startButton.show()
		leftScoreLabel.hide()
		rightScoreLabel.hide()
		messageLabel.hide()
		$LeftPlayer.hide()
		$RightPlayer.hide()
		gameActive = false
	if !(ball == null):
		ball.queue_free()

#change direction of the ball based off of which paddle hit ball
func _on_leftHit() -> void:
	newBallVel(abs(ball.linear_velocity.x))
func _on_rightHit() -> void:
	newBallVel(-abs(ball.linear_velocity.x))
