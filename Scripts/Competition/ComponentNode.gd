extends Node2D

class_name ComponentNode

var recipeNode : RecipeNode = null
var component : Component = null

var startupTimer : float = 0.0
var popTimer : float = POP_MAX_TIME
var removeTimer : float = REMOVE_MAX_TIME

var hasMouseFocus : bool = false

var movePos = null

const STARTUP_MAX_TIME : float = 0.4
const POP_MAX_TIME : float = 0.4
const REMOVE_MAX_TIME : float = 0.4
const POP_SCALE_MAX : float = 1.25
const MOVE_SPEED = 128.0

signal mouse_entered(componentNode : ComponentNode)
signal mouse_exited(componentNode : ComponentNode)
signal clicked(componentNode : ComponentNode, buttonIndex : int, pressed : bool)

@onready var collisionShape : CollisionShape2D = $Area2D/CollisionShape2D
@onready var rectShape : RectangleShape2D = collisionShape.shape as RectangleShape2D
@onready var background : NinePatchRect = $NinePatchRect
@onready var label : Label = $NinePatchRect/Label

signal startup_finished(componentNode : ComponentNode)
signal remove_finished(componentNode : ComponentNode)
signal move_finished(ComponentNode : ComponentNode)

func getWidth() -> int:
	return int(rectShape.size.x)

func setWidth(width : int) -> void:
	rectShape.size.x = width
	background.size.x = width
	background.position.x = -width/2.0

func onMouseEntered() -> void:
	emit_signal("mouse_entered", self)

func onMouseExited() -> void:
	emit_signal("mouse_exited", self)

func _input(event):
	if removeTimer < REMOVE_MAX_TIME:
		return
	if event is InputEventMouseButton:
		if hasMouseFocus and not event.is_echo():
			emit_signal("clicked", self, event.button_index, event.is_pressed())

func setComponent(component : Component) -> void:
	self.component = component
	label.text = component.ingredientData.name
	onStart()

func onStart() -> void:
	startupTimer = 0.0
	scale = Vector2.ZERO

func onRemove() -> void:
	removeTimer = 0.0

func onPop() -> void:
	popTimer = 0.0

func _process(delta):
	if removeTimer < REMOVE_MAX_TIME:
		removeTimer += delta
		scale = Vector2.ONE * (1.0-removeTimer/REMOVE_MAX_TIME)
		if removeTimer >= REMOVE_MAX_TIME:
			emit_signal("remove_finished", self)
			queue_free()
		
	elif startupTimer < STARTUP_MAX_TIME:
		startupTimer += delta
		var t : float = startupTimer/STARTUP_MAX_TIME
		var s : float = t + (0.5 - cos(2*PI*t)/2.0)
		s = min(1.0, max(0.0, s))
		scale = Vector2.ONE * s
		if startupTimer >= STARTUP_MAX_TIME:
			emit_signal("startup_finished", self)
	
	elif popTimer < POP_MAX_TIME:
		popTimer += delta
		var t : float = popTimer/POP_MAX_TIME
		var f : float = 1.0 - 4.0 * pow(t - 0.5, 2.0)
		var s : float = (POP_SCALE_MAX - 1.0) * f + 1
		scale = Vector2.ONE * s
		if popTimer >= POP_MAX_TIME:
			scale = Vector2.ONE
	
	if movePos != null:
		var diff : Vector2 = movePos - global_position
		if diff.length() < MOVE_SPEED * delta:
			global_position = movePos
			movePos = null
			emit_signal("move_finished", self)
		else:
			var dir : Vector2 = diff.normalized()
			var d : Vector2 = dir * MOVE_SPEED * delta
			global_position += d
	
	if hasMouseFocus:
		pass
