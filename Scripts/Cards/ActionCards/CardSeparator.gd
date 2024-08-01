extends ActionData

class_name CardSeparator

func _init():
	super._init("Separator", RARITY.COMMON, Preloader.art_separator, 1)

func getDesc() -> String:
	return super.getDesc() + "Return the first component of your recipe to your hand."

func canPlay(cardNode : CardNode) -> bool:
	return super.canPlay(cardNode) and cardNode.cardOwner.recipeNode.getSize() > 0

func onPlay(cardNode : CardNode) -> void:
	var component : Component = null
	if cardNode.cardOwner.recipeNode.getSize() > 0:
		component = cardNode.cardOwner.recipeNode.components[0]
		cardNode.cardOwner.recipeNode.removeFromRecipe(component, self.onComponentRemoved.bind(cardNode, component))

func onComponentRemoved(cardNode : CardNode, component : Component) -> void:
	cardNode.cardOwner.handNode.addCard(component.ingredientData, cardNode.cardOwner.recipeNode.getIndexToRestingPosition(0))
