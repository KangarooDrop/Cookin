extends Node2D

class_name CardNode

var cardOwner : SetupNode = null

var cardData : CardData = null
var hasMouseFocus : bool = false

var decaying : bool = false
var decayTimer : float = 0.0

const DECAY_MAX_TIME : float = 0.5
const DECAY_MOVE_SPEED : float = 128.0

@onready var frontNode : Node2D = $ScaleBottomUp/ScaleCenter/Front
@onready var backNode : Node2D = $ScaleBottomUp/ScaleCenter/Back

@onready var nameLabel : RichTextLabel = $ScaleBottomUp/ScaleCenter/Front/TextureRect/NameHolder/RichTextLabel
@onready var imageTextureRect : TextureRect = $ScaleBottomUp/ScaleCenter/Front/TextureRect/ImageHolder/ImageTextureRect
@onready var textLabel : RichTextLabel = $ScaleBottomUp/ScaleCenter/Front/TextureRect/TextHolder/RichTextLabel
@onready var shaderMat : ShaderMaterial = self.material as ShaderMaterial

@onready var scaleBottomUpNode : Node2D = $ScaleBottomUp
@onready var scaleCenterNode : Node2D = $ScaleBottomUp/ScaleCenter

signal clicked(cardNode : CardNode, buttonIndex : int, pressed : bool)
signal mouse_entered(cardNode : CardNode)
signal mouse_exited(cardNode : CardNode)

func setCardData(cardData : CardData) -> void:
	self.cardData = cardData
	nameLabel.text = "[center]" + cardData.name + "[/center]"
	imageTextureRect.texture = cardData.image
	textLabel.text = cardData.getDesc()

func onMouseEnter() -> void:
	emit_signal("mouse_entered", self)

func onMouseExit() -> void:
	emit_signal("mouse_exited", self)

func _input(event):
	if decaying:
		return
	
	if event is InputEventMouseButton:
		if hasMouseFocus and not event.is_echo():
			emit_signal("clicked", self, event.button_index, event.is_pressed())

func onDecay() -> void:
	decaying = true

func _process(delta):
	if decaying:
		decayTimer += delta
		position.y -= delta * DECAY_MOVE_SPEED * (1.0 - decayTimer/DECAY_MAX_TIME)
		shaderMat.set_shader_parameter("t", decayTimer/DECAY_MAX_TIME)
		if decayTimer >= DECAY_MAX_TIME:
			queue_free()

func setScaleBottomUp(amount : float) -> void:
	scaleBottomUpNode.scale = Vector2.ONE * amount

func setScaleCentered(amount : float) -> void:
	scaleCenterNode.scale = Vector2.ONE * amount
