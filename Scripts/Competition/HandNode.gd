extends Node2D

class_name HandNode

var setup : SetupNode

var cardNodes : Array = []

var heldCardNode : CardNode = null


const PLAY_OFFSET : float = -300.0

const CARD_DIST_MAX : float = 165.0
const CARD_DIST_MIN : float = 80.0
const MOVE_SPEED : float = 280*2.0
const MOVE_THRESHOLD : float = 0.1

func addCard(cardData : CardData, cardPos = null) -> CardNode:
	var cardNode : CardNode = null
	if cardData is IngredientData:
		cardNode = Preloader.ingredientCardNode.instantiate()
	elif cardData is ActionData:
		cardNode = Preloader.actionCardNode.instantiate()
	else:
		assert(false, "ERROR: Unknown card type passed to addCard")
	
	add_child(cardNode)
	cardNode.cardOwner = setup
	cardNode.setCardData(cardData)
	cardNode.connect("clicked", self.onCardNodeClicked)
	cardNode.connect("mouse_entered", self.onCardNodeMouseEnter)
	cardNode.connect("mouse_exited", self.onCardNodeMouseExit)
	
	cardNodes.append(cardNode)
	if cardPos == null:
		cardNode.global_position = setup.stockpileNode.global_position
	else:
		cardNode.global_position = cardPos
	
	return cardNode

#Erases and frees the provided card node
func eraseCardNode(cardNode : CardNode) -> bool:
	if transferCardNode(cardNode):
		cardNode.queue_free()
		return true
	return false

#Erases the provided card node but does not free
func transferCardNode(cardNode : CardNode) -> bool:
	if cardNodes.has(cardNode):
		cardNode.disconnect("clicked", self.onCardNodeClicked)
		cardNodes.erase(cardNode)
		remove_child(cardNode)
		return true
	else:
		return false

var cardNodeHovering : CardNode = null
func onCardNodeMouseEnter(cardNode : CardNode) -> void:
	if not is_instance_valid(heldCardNode):
		if is_instance_valid(cardNodeHovering):
			cardNodeHovering.hasMouseFocus = false
		cardNodeHovering = cardNode
		cardNodeHovering.hasMouseFocus = true

func onCardNodeMouseExit(cardNode : CardNode) -> void:
	if cardNode == cardNodeHovering and cardNode != heldCardNode:
		cardNodeHovering.hasMouseFocus = false
		cardNodeHovering = null

func onCardNodeClicked(cardNode : CardNode, buttonIndex : int, pressed : bool) -> void:
	if pressed:
		if heldCardNode != null:
			if buttonIndex == MOUSE_BUTTON_LEFT:
				if heldCardNode.global_position.y <= global_position.y + PLAY_OFFSET:
					if not setup.recipeNode.waiting:
						playCardNode(cardNode)
						heldCardNode = null
						onCardNodeMouseExit(cardNode)
				else:
					heldCardNode = null
			elif buttonIndex == MOUSE_BUTTON_RIGHT:
				heldCardNode = null
		else:
			if buttonIndex == MOUSE_BUTTON_LEFT:
				heldCardNode = cardNode

func playCardNode(cardNode : CardNode) -> void:
	if cardNode is IngredientCardNode:
		var pos : Vector2 = cardNode.global_position
		transferCardNode(cardNode)
		setup.recipeNode.add_child(cardNode)
		cardNode.global_position = pos
		setup.recipeNode.addToRecipe(cardNode)
	else:
		if cardNode.cardData.canPlay(cardNode):
			var pos : Vector2 = cardNode.global_position
			transferCardNode(cardNode)
			setup.recipeNode.add_child(cardNode)
			cardNode.global_position = pos
			cardNode.cardData.onPlay(cardNode)
			cardNode.onDecay()

func _process(delta):
	var numCards : int = cardNodes.size()
	var handLength : float = float(numCards-1) * CARD_DIST_MAX
	var localMousePos : Vector2 = get_local_mouse_position()
	var mouseHoverVal : float = (localMousePos.x + handLength/2.0) / CARD_DIST_MAX
	mouseHoverVal = min(mouseHoverVal, numCards-0.5)
	mouseHoverVal = max(mouseHoverVal, -0.5)
	
	for i in range(numCards):
		var newPos : Vector2 = Vector2.ZERO
		if cardNodes[i] == heldCardNode:
			newPos = get_local_mouse_position()
			cardNodes[i].z_index = 1
			#cardNodes[i].z_index = numCards
		else:
			var pos : Vector2 = Vector2.ZERO
			if i < mouseHoverVal:
				pos = Vector2(-handLength/2.0 + lerp(CARD_DIST_MIN, CARD_DIST_MAX, float(i)/(mouseHoverVal)) * i, 0.0)
			elif i > mouseHoverVal:
				var i_ = numCards-i-1
				var mhv_ : float = numCards-mouseHoverVal-1
				pos = Vector2(handLength/2.0 - lerp(CARD_DIST_MIN, CARD_DIST_MAX, float(i_)/(mhv_)) * i_, 0.0)
			else:
				pos = Vector2(localMousePos.x, 0.0)
			pos.y = abs(i - mouseHoverVal) * 16.0
			#cardNodes[i].z_index = numCards - 1 - abs(floor(i-mouseHoverVal+0.5))
			
			var diff : Vector2 = pos - cardNodes[i].position
			if diff.length() < MOVE_SPEED * MOVE_THRESHOLD:
				newPos = pos
			else:
				var dir : Vector2 = diff.normalized() * MOVE_SPEED * delta
				newPos = cardNodes[i].position + dir * MOVE_SPEED * delta
		
		if cardNodes[i] == heldCardNode:
			#cardNodes[i].setScaleCentered(1.0)
			cardNodes[i].setScaleBottomUp(1.0)
			cardNodes[i].z_index = 2
		elif cardNodes[i].hasMouseFocus:
			#cardNodes[i].setScaleCentered(1.0)
			cardNodes[i].setScaleBottomUp(1.5)
			cardNodes[i].z_index = 1
		else:
			#cardNodes[i].setScaleCentered((1.0 + 1.0/(3.0+abs(i-mouseHoverVal))) * 0.5)
			#cardNodes[i].setScaleCentered(1.0)
			cardNodes[i].setScaleBottomUp((1.0 + 1.0/(3.0+abs(i-mouseHoverVal))) * 0.75)
			#cardNodes[i].setScaleBottomUp(1.0)
			cardNodes[i].z_index = 0
		
		cardNodes[i].position = newPos
		cardNodes[i].rotation = (i - mouseHoverVal) * PI / 128.0
	
	if heldCardNode != null:
		var heldIndex : int = cardNodes.find(heldCardNode)
		var mouseHoverIndex : int = int(min(max(mouseHoverVal+1.0, 0.0), numCards))
		if mouseHoverIndex != heldIndex:
			if heldIndex < mouseHoverIndex:
				mouseHoverIndex -= 1
		cardNodes.remove_at(heldIndex)
		cardNodes.insert(mouseHoverIndex, heldCardNode)
