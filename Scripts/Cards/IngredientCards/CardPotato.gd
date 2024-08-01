extends IngredientData

class_name CardPotato

func _init():
	super._init("Potato", RARITY.COMMON, Preloader.art_potato)

func getDesc() -> String:
	return super.getDesc() + "Gains double bonuses to " + IngredientData.getFlavorToString(FLAVORS.TASTE) + " and " + IngredientData.getFlavorToString(FLAVORS.TEXTURE) + "."

func getFlavors() -> Dictionary:
	return {}

func getTags() -> Array[TAGS]:
	return [TAGS.STARCH]

func apply(recipeNode : RecipeNode) -> void:
	var component : Component = getComponent(recipeNode)
	component.bonusMulSelf[FLAVORS.TASTE] = 2.0
	component.bonusMulSelf[FLAVORS.TEXTURE] = 2.0
