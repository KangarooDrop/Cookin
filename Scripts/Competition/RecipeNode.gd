extends Node2D

class_name RecipeNode

var setup : SetupNode = null

var components : Array[Component] = []
var componentToNode : Dictionary = {}

const ADDING_MAX_TIME : float = 0.65
const INGREDIENT_OFFSET : float = 48.0
const HEIGHT_MIN : float = 200

@onready var background : NinePatchRect = $NinePatchRect
@onready var componentNodeHolder : Node2D = $ComponentNodeHolder
@onready var pointScaler : Node2D = $NinePatchRect/PointHolder/PointScaler
@onready var pointLabel : Label = $NinePatchRect/PointHolder/PointScaler/Label

@onready var animQueueLabel : Label = $AnimQueueLabel

####################################################################################################
#Helper functions for IngredientData
####################################################################################################

func getIngredientComponent(ingredientData : IngredientData) -> Component:
	for c in components:
		if c.ingredientData == ingredientData:
			return c
	return null

func getComponentIndex(component : Component) -> int:
	return components.find(component)

func getIndexComponent(index : int) -> Component:
	if index < getSize() and index >= 0:
		return components[index]
	else:
		return null

func getSize() -> int:
	return components.size()

func getComponentToNode(component : Component) -> ComponentNode:
	if componentToNode.has(component):
		return componentToNode[component]
	else:
		return null

func getComponentPreviousAll(component : Component) -> Array[Component]:
	var rtn : Array[Component] = []
	for i in range(0, getComponentIndex(component)):
		rtn.append(components[i])
	return rtn

func getComponentPreviousX(component : Component, num : int) -> Array[Component]:
	var rtn : Array[Component] = []
	for i in range(0, getComponentIndex(component)):
		rtn.append(components[i])
		num -= 1
		if num <= 0:
			break
	return rtn

func getComponentNextAll(component : Component) -> Array[Component]:
	var rtn : Array[Component] = []
	for i in range(getComponentIndex(component)+1, getSize()):
		rtn.append(components[i])
	return rtn

func getComponentNextX(component : Component, num : int) -> Array[Component]:
	var rtn : Array[Component] = []
	for i in range(getComponentIndex(component)+1, getSize()):
		rtn.append(components[i])
		num -= 1
		if num <= 0:
			break
	return rtn

####################################################################################################
#Callable functions outside of the scripts scope
####################################################################################################

func addToRecipe(ingredientCardNode : IngredientCardNode, index : int = -1) -> void:
	addCardAnim(ingredientCardNode, index)

func addIngredient(ingredientData : IngredientData, index : int = -1) -> void:
	if index == -1:
		index = components.size()
	addIngredientDataAnim(ingredientData, index)

func removeFromRecipe(component : Component, callableOnFinished = null) -> void:
	addRemoveComponentAnim(component, callableOnFinished)

####################################################################################################
#Helper functions for this script
####################################################################################################

func getIngredientCardNodePosition(startPosition : Vector2, endPosition : Vector2, t : float) -> Vector2:
	var pos : Vector2 = lerp(startPosition, endPosition, t)
	pos.x += (startPosition.x - endPosition.x)/2.0 * (-4 * pow(t - 0.5, 2.0) + 1) * 1.5
	pos.y += -abs(startPosition.y - endPosition.y)/2.0 * (t * pow(t - 1, 4) / 0.082) * 2.0
	return pos

func getIndexToRestingPosition(index : int) -> Vector2:
	return componentNodeHolder.global_position + Vector2.DOWN * INGREDIENT_OFFSET * index


####################################################################################################
#Animation handling
####################################################################################################

var waiting : bool = false
func _process(delta):
	waiting = currentAnimData != null
	
	if pointTimer < POINT_MAX_TIME:
		pointTimer += delta
		var t : float = pointTimer / POINT_MAX_TIME
		var s : float = -2.0 * pow(t - 0.5, 2.0) + 1.5
		pointScaler.scale = Vector2.ONE * s
	
	if currentAnimData == null:
		if animQueue.size() > 0:
			currentAnimData = animQueue.pop_front()
			if currentAnimData[0] == ANIM_TYPE.ARROW:
				createArrowAnims(currentAnimData)
			elif currentAnimData[0] == ANIM_TYPE.ADD_COMPONENT:
				createComponentNodeAnim(currentAnimData)
			elif currentAnimData[0] == ANIM_TYPE.REMOVE_COMPONENT:
				createRemoveComponentAnim(currentAnimData)
			elif currentAnimData[0] == ANIM_TYPE.MOVE_COMPONENT:
				createMoveComponentAnim(currentAnimData)
			elif currentAnimData[0] == ANIM_TYPE.ADD_CARD:
				createCardAnim(currentAnimData)
	else:
		if currentAnimData[0] == ANIM_TYPE.ARROW:
			if currentAnimData[3] == 0:
				if currentAnimData[6] != null:
					currentAnimData[6].call()
				currentAnimData = null
		elif currentAnimData[0] == ANIM_TYPE.ADD_COMPONENT:
			if currentAnimData[3] == 0:
				if currentAnimData[4] != null:
					currentAnimData[4].call()
				currentAnimData = null
		elif currentAnimData[0] == ANIM_TYPE.REMOVE_COMPONENT:
			if currentAnimData[2] == 0:
				if currentAnimData[3] != null:
					currentAnimData[3].call()
				currentAnimData = null
				var comps : Array[Component] = []
				var poss : Array[Vector2] = []
				for i in range(components.size()):
					comps.append(components[i])
					poss.append(getIndexToRestingPosition(i))
				pushMoveComponentAnim(comps, poss)
		elif currentAnimData[0] == ANIM_TYPE.MOVE_COMPONENT:
			if currentAnimData[3] == 0:
				if currentAnimData[4] != null:
					currentAnimData[4].call()
				currentAnimData = null
		elif currentAnimData[0] == ANIM_TYPE.ADD_CARD:
			var lastPos : Vector2 = currentAnimData[1].global_position
			var t : float = currentAnimData[4]/ADDING_MAX_TIME
			var index : int = currentAnimData[2]
			if index == -1:
				index = components.size()
			currentAnimData[1].global_position = getIngredientCardNodePosition(currentAnimData[3], getIndexToRestingPosition(index), t)
			var angle : float = (currentAnimData[1].global_position - lastPos).angle() + PI/2.0
			currentAnimData[1].rotation = lerp_angle(currentAnimData[1].rotation, angle, delta * 8.0)
			currentAnimData[1].scale = Vector2.ONE * lerp(0.1, 1.0, 1-t)
			
			currentAnimData[4] += delta
			if currentAnimData[4] > ADDING_MAX_TIME:
				addIngredientDataAnim(currentAnimData[1].cardData, index)
				currentAnimData[1].queue_free()
				if currentAnimData[5] != null:
					currentAnimData[5].call()
				currentAnimData = null
		
		setPoints()
	
	setBackgroundSize()
	
	animQueueLabel.text = ""
	animQueueLabel.text += "=====================\n"
	if currentAnimData != null:
		animQueueLabel.text += "(" + str("C") + ") :: " + ANIM_TYPE.keys()[currentAnimData[0]].capitalize() + "\n\t" + str(currentAnimData) + "\n"
	for i in range(animQueue.size()):
		animQueueLabel.text += "(" + str(i) + ") :: " + ANIM_TYPE.keys()[animQueue[i][0]].capitalize() + "\n\t" + str(animQueue[i]) + "\n"
	animQueueLabel.text += "====================="
#
func onArrowAnimFinished(animData : Array, arrowNode : RecipeArrowNode):
	pass

func setBackgroundSize() -> void:
	var lowest : float = 0.0
	for componentNode : ComponentNode in componentToNode.values():
		if componentNode.position.y > lowest:
			lowest = componentNode.position.y
	
	var height : float = max(HEIGHT_MIN, lowest + 135.0)
	background.size.y = height

const ANIM_ARROW_MAX_TIME : float = 1.0
enum ANIM_TYPE \
{
	ARROW,
	ADD_COMPONENT,
	REMOVE_COMPONENT,
	MOVE_COMPONENT,
	ADD_CARD,
}
var currentAnimData = null
var animQueue : Array[Array] = []
func addArrowAnim(from : Component, to : Array[Component], color : Color, blocking : bool = true, callableOnFinish = null):
	var animData : Array = [ANIM_TYPE.ARROW, from, to, to.size(), blocking, color, callableOnFinish]
	if blocking:
		animQueue.append(animData)
	else:
		return createArrowAnims(animData)

func createArrowAnims(animData : Array) -> Array[RecipeArrowNode]:
	var arrows : Array[RecipeArrowNode] = []
	var c0 : ComponentNode = componentToNode[animData[1]]
	var p0 : Vector2 = c0.global_position
	for i in range(animData[3]):
		var c1 : ComponentNode = componentToNode[animData[2][i]]
		var p1 : Vector2 = c1.global_position
		var startPos : Vector2 = p0 + Vector2.RIGHT * c0.getWidth()/2.0 * (-1 if p0.x > p1.x else 1)
		var endDir : float = 0.0
		if abs(p1.x - p0.x) < c0.getWidth()+c1.getWidth():
			endDir = -1 if p0.x > p1.x else 1
		else:
			endDir = 1 if p0.x > p1.x else -1
		var endPos : Vector2 = p1 + Vector2.RIGHT * c1.getWidth()/2.0 * endDir
		
		var arrowNode : RecipeArrowNode = Preloader.recipeArrowNode.instantiate()
		add_child(arrowNode)
		arrowNode.freeOnFinish = animData[4]
		arrowNode.connect("travel_finished", (func(_recipeArrowNode : RecipeArrowNode, animData : Array): animData[3] -= 1).bind(animData))
		arrowNode.global_position = startPos
		arrowNode.setEndPos(endPos - startPos)
		arrowNode.setColor(animData[5])
		arrows.append(arrowNode)
	return arrows

func addIngredientDataAnim(ingredientData : IngredientData, index : int, callableOnFinish = null) -> void:
	var animData : Array = [ANIM_TYPE.ADD_COMPONENT, ingredientData, index, 1, callableOnFinish]
	animQueue.append(animData)

func createComponentNodeAnim(animData) -> ComponentNode:
	var component : Component = Component.new()
	component.setRecipeNode(self)
	component.setIngredientData(animData[1])
	
	var componentNode : ComponentNode = Preloader.componentNode.instantiate()
	componentNodeHolder.add_child(componentNode)
	if components.size() == 0:
		componentNode.position = Vector2.ZERO
	else:
		componentNode.global_position = getIndexToRestingPosition(components.size())
	
	components.insert(animData[2], component)
	componentNode.setComponent(component)
	componentNode.recipeNode = self
	componentNode.connect("mouse_entered", self.onComponentNodeMouseEntered)
	componentNode.connect("mouse_exited", self.onComponentNodeMouseExited)
	componentNode.connect("clicked", self.onComponentNodeClicked)
	componentNode.connect("startup_finished", (func(_componentNode : ComponentNode, animData : Array): animData[3] -= 1).bind(animData))
	componentToNode[component] = componentNode
	
	reset()
	
	return componentNode

func addRemoveComponentAnim(component : Component, callableOnFinish = null) -> void:
	var animData : Array = [ANIM_TYPE.REMOVE_COMPONENT, component, 1, callableOnFinish]
	animQueue.append(animData)

func createRemoveComponentAnim(animData : Array) -> void:
	var component : Component = animData[1]
	if componentToNode.has(component):
		var componentNode : ComponentNode = componentToNode[component]
		components.erase(component)
		componentNode.connect("remove_finished", (func(_componentNode : ComponentNode, animData : Array): animData[2] -= 1).bind(animData))
		componentToNode.erase(component)
		componentNode.onRemove()
		
		reset()
	else:
		animData[2] = 0

func pushMoveComponentAnim(components : Array[Component], positions : Array[Vector2], callableOnFinish = null) -> void:
	var animData : Array = [ANIM_TYPE.MOVE_COMPONENT, components, positions, components.size(), callableOnFinish]
	animQueue.insert(0, animData)

func addMoveComponentAnim(components : Array[Component], positions : Array[Vector2], callableOnFinish = null) -> void:
	var animData : Array = [ANIM_TYPE.MOVE_COMPONENT, components, positions, components.size(), callableOnFinish]
	animQueue.append(animData)

func createMoveComponentAnim(animData : Array) -> void:
	var callable : Callable = func(componentNode : ComponentNode, animData : Array, moveCallable : Callable):
		animData[3] -= 1
		componentNode.disconnect("move_finished", moveCallable)
	for i in range(animData[1].size()):
		var componentNode : ComponentNode = componentToNode[animData[1][i]]
		componentNode.connect("move_finished", callable.bind(animData, callable))
		componentNode.movePos = animData[2][i]

func addCardAnim(cardNode : CardNode, index : int, callableOnFinish = null) -> void:
	var animData : Array = [ANIM_TYPE.ADD_CARD, cardNode, index, cardNode.global_position, 0.0, callableOnFinish]
	animQueue.append(animData)

func createCardAnim(animData : Array) -> void:
	pass

####################################################################################################
#Tracking and setting score
####################################################################################################

func reset() -> void:
	for component in components:
		component.reset()
	for component in components:
		component.apply()
	setPoints()

const POINT_MAX_TIME : float = 0.25
var pointTimer : float = POINT_MAX_TIME
var points : int = 0
func setPoints() -> void:
	var stats : Dictionary = {}
	for flavor : IngredientData.FLAVORS in IngredientData.FLAVORS.values():
		stats[flavor] = 0
		for component : Component in components:
			stats[flavor] += component.flavorsModified[flavor]
	var total : int = 0
	for flavor : IngredientData.FLAVORS in IngredientData.FLAVORS.values():
		total += stats[flavor]
	
	if self.points != total:
		self.points = total
		pointLabel.text = str(points)
		pointTimer = 0.0

####################################################################################################
#Click handling
####################################################################################################

var highlightArrows : Array[RecipeArrowNode] = []
var componentNodeHovering : ComponentNode = null
func onComponentNodeMouseEntered(componentNode : ComponentNode) -> void:
	if is_instance_valid(componentNodeHovering):
		onComponentNodeMouseExited(componentNodeHovering)
	componentNodeHovering = componentNode
	componentNodeHovering.hasMouseFocus = true
	
	print(componentNode.component.flavorsModified)
	highlightArrows.append_array(componentNode.component.showAffecting())

func onComponentNodeMouseExited(componentNode : ComponentNode) -> void:
	if componentNode == componentNodeHovering:
		componentNodeHovering.hasMouseFocus = false
		componentNodeHovering = null
	
		for arrowNode : RecipeArrowNode in highlightArrows:
			arrowNode.freeOnFinish = true
		highlightArrows.clear()

func onComponentNodeClicked(componentNode : ComponentNode, buttonIndex : int, pressed : bool) -> void:
	pass

func _input(event):
	if event is InputEventKey and event.is_pressed() and not event.is_echo() and event.keycode == KEY_F12:
		animQueueLabel.visible = not animQueueLabel.visible
