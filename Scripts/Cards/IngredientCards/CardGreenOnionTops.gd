extends IngredientData

class_name CardGreenOnionTops

const textureInc : int = 1

func _init():
	super._init("Green Onion Tops", RARITY.COMMON, Preloader.art_green_onion_tops)

####################################################################################################

func getDesc() -> String:
	return super.getDesc() + "Loses all bonuses if not the last ingredient."

func getFlavors() -> Dictionary:
	return {FLAVORS.APPEARANCE : 1, FLAVORS.TEXTURE : 1}

func getTags() -> Array[TAGS]:
	return [TAGS.VEGITABLE, TAGS.GARNISH]

####################################################################################################

func apply(recipeNode : RecipeNode) -> void:
	var component : Component = getComponent(recipeNode)
	var index : int = recipeNode.getComponentIndex(component)
	var size : int = recipeNode.getSize()
	if index != size-1:
		for flavor in flavors.keys():
			component.flavorsModified[flavor] = 0
