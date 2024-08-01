extends IngredientData

class_name CardSalt

const flavorInc : int = 1
const flavorDec : int = -3
const numSaltToNegative : int = 3

func _init():
	super._init("Salt", RARITY.COMMON, Preloader.art_salt)

func getDesc() -> String:
	return super.getDesc() + "Each previous ingredient gets " + IngredientData.getFlavorScoreToString(flavorInc, FLAVORS.TASTE) + \
		". If they are affected by " + str(numSaltToNegative) + " or more Salt, instead they get " + IngredientData.getFlavorScoreToString(flavorDec, FLAVORS.TASTE) + "."

func getFlavors() -> Dictionary:
	return {}

func getTags() -> Array[TAGS]:
	return []

func apply(recipeNode : RecipeNode) -> void:
	var counter : int = numSaltToNegative-1
	var component : Component = getComponent(recipeNode)
	var index : int = recipeNode.getComponentIndex(component)
	var positives : Array[Component] = []
	var negatives : Array[Component] = []
	for i in range(index-1, -1, -1):
		var other : Component = recipeNode.components[i]
		if counter > 0:
			positives.append(other)
		else:
			negatives.append(other)
		
		if other.ingredientData is CardSalt:
			counter -= 1
	
	component.addFlavorOthers(positives, FLAVORS.TASTE, flavorInc)
	component.addFlavorOthers(negatives, FLAVORS.TASTE, flavorDec)
