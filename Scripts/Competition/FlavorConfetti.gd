extends Node2D

class_name FlavorConfetti

var playing : bool = true
var flavors : Dictionary = {}
var lifeTimer : float = 0.0
var velocity : Vector2 = Vector2.ZERO
var gravity : Vector2 = GRAVITY_BASE

const LIFE_MAX_TIME : float = 0.5
const VELOCITY_START : Vector2 = Vector2(100.0, -200.0)
const GRAVITY_BASE : Vector2 = Vector2(0, 1000.0)

@onready var label : RichTextLabel = $RichTextLabel

func setFlavors(flavors : Dictionary) -> void:
	self.flavors = flavors
	label.text = IngredientData.getFlavorsToString(flavors)

func _ready():
	self.velocity = VELOCITY_START
	self.gravity = GRAVITY_BASE

func _process(delta):
	if playing:
		velocity += gravity * delta
		position += velocity * delta
		
		lifeTimer += delta
		modulate.a = 1.0 - lifeTimer/LIFE_MAX_TIME
		if lifeTimer >= LIFE_MAX_TIME:
			queue_free()
