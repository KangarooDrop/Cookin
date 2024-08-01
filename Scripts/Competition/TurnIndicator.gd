extends Node2D

const TIME_MAX : float = 1.0
const SPIN_FORWARD : float = PI*2.0*4.0
const SPIN_REVERSE : float = SPIN_FORWARD*2.0
const SCALE_START : float = 0.0
const SCALE_END : float = 1.0
const ALPHA_START : float = 0.0
const ALPHA_END : float = 1.0
const DELAY_TIME_MAX : float = 0.1

var spinning : bool = false
var timer : float = 0.0
var delay : float = 0.0
var velocity : float = 0.0
var reversing : bool = false

func _ready():
	spin()

func spin() -> void:
	show()
	modulate.a = ALPHA_START
	scale = Vector2.ONE * SCALE_START
	spinning = true
	timer = 0.0
	delay = 0.0
	velocity = SPIN_FORWARD

var lastRotation : float = 0.0
func _process(delta):
	if spinning:
		timer += delta
		if timer >= TIME_MAX and fmod(rotation, PI*2.0) < fmod(lastRotation, PI * 2.0):
			spinning = false
			reversing = true
			velocity = SPIN_FORWARD/2.0
	elif reversing:
		if delay < DELAY_TIME_MAX and velocity > 0.0 and velocity - SPIN_REVERSE * delta <= 0.0:
			delay += delta
		else:
			velocity -= SPIN_REVERSE * delta
		if velocity < 0.0 and fmod(rotation, PI*2.0) > PI and fmod(lastRotation, PI * 2.0) < PI:
			print(fmod(rotation, PI*2.0), "  ", fmod(lastRotation, PI * 2.0))
			reversing = false
			rotation = 0.0
			velocity = 0.0
	
	scale = Vector2.ONE * lerp(SCALE_START, SCALE_END, timer/TIME_MAX)
	modulate.a = lerp(ALPHA_START, ALPHA_END, timer/TIME_MAX)
	lastRotation = rotation
	rotation += velocity * delta
