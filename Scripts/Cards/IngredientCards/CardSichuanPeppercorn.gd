extends IngredientData

class_name CardSichuanPeppercorn

const flavorInc : int = 1

func _init():
	super._init("Sichuan Peppercorn", RARITY.UNCOMMON, Preloader.art_sichuan_peppercorns)

func getDesc() -> String:
	return super.getDesc() + "Other spicy ingredients get +" + str(flavorInc) + " Chemesthesis."

func getFlavors() -> Dictionary:
	return {FLAVORS.CHEMESTHESIS : 1}

func getTags() -> Array[TAGS]:
	return [TAGS.SPICE]

func apply(recipeNode : RecipeNode) -> void:
	var component : Component = getComponent(recipeNode)
	var toAdd : Array[Component] = []
	for other : Component in recipeNode.components:
		if other != component and other.ingredientData.tags.has(TAGS.SPICY):
			toAdd.append(other)
	component.addFlavorOthers(toAdd, IngredientData.FLAVORS.CHEMESTHESIS, flavorInc)
