extends IngredientData

class_name CardChileCrisp

func _init():
	super._init("Chile Crisp", RARITY.COMMON, Preloader.art_chile_crips)

func getDesc() -> String:
	return super.getDesc() + ""

func getFlavors() -> Dictionary:
	return {FLAVORS.TEXTURE : 2, FLAVORS.CHEMESTHESIS : 1}

func getTags() -> Array[TAGS]:
	return [TAGS.SPICY, TAGS.GARNISH]
