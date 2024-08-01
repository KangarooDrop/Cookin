extends IngredientData

class_name CardChickpeas

func _init():
	super._init("Chickpeas", RARITY.COMMON, Preloader.art_chickpeas)

func getDesc() -> String:
	return super.getDesc() + "If the next ingredient is a spice, it provides double bonuses to other ingredients."

func getFlavors() -> Dictionary:
	return {FLAVORS.TEXTURE : 1}

func getTags() -> Array[TAGS]:
	return [TAGS.PROTEIN, TAGS.STARCH]

func apply(recipeNode : RecipeNode) -> void:
	var component : Component = getComponent(recipeNode)
	var nextComponents : Array[Component] = recipeNode.getComponentNextX(component, 1)
	if nextComponents.size() > 0 and nextComponents[0].ingredientData.tags.has(TAGS.SPICE):
		nextComponents[0].bonusMulOthers[FLAVORS.TASTE] = 2.0
		nextComponents[0].bonusMulOthers[FLAVORS.AROMA] = 2.0
		nextComponents[0].bonusMulOthers[FLAVORS.TEXTURE] = 2.0
		nextComponents[0].bonusMulOthers[FLAVORS.CHEMESTHESIS] = 2.0
		nextComponents[0].bonusMulOthers[FLAVORS.APPEARANCE] = 2.0
