extends IngredientData

class_name CardBakingSoda

func _init():
	super._init("Baking Soda", RARITY.COMMON, Preloader.art_baking_soda)

func getDesc() -> String:
	return super.getDesc() + "When added to your recipe, refresh (1) energy."

func getFlavors() -> Dictionary:
	return {FLAVORS.TEXTURE : -1}

func getTags() -> Array[TAGS]:
	return []

func apply(recipeNode : RecipeNode) -> void:
	var component : Component = getComponent(recipeNode)
	pass
