extends IngredientData

class_name CardGarlic

const tasteInc : int = 1
const aromaInc : int = 1
const numCardsAffected : int = 2

func _init():
	super._init("Garlic", RARITY.COMMON, Preloader.art_garlic)

func getDesc() -> String:
	return super.getDesc() + "The " + str(numCardsAffected) + " ingredients after this get " + IngredientData.getFlavorsToString({FLAVORS.TASTE : tasteInc, FLAVORS.AROMA : aromaInc}) + " if they are Vegitables or Starches."

func getFlavors() -> Dictionary:
	return {FLAVORS.CHEMESTHESIS : 1, FLAVORS.AROMA : 1}

func getTags() -> Array[TAGS]:
	return [TAGS.VEGITABLE]

func apply(recipeNode : RecipeNode) -> void:
	var component : Component = getComponent(recipeNode)
	var toAdd : Array[Component] = []
	for otherComponent : Component in recipeNode.getComponentNextX(component, 2):
		if otherComponent.ingredientData.tags.has(TAGS.VEGITABLE) or otherComponent.ingredientData.tags.has(TAGS.STARCH):
			toAdd.append(otherComponent)
	component.addFlavorOthers(toAdd, IngredientData.FLAVORS.TASTE, tasteInc)
	component.addFlavorOthers(toAdd, IngredientData.FLAVORS.AROMA, aromaInc)
