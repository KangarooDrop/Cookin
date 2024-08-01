extends Node

const toCheck : Array = \
[
	{
		IngredientData.FLAVORS.TASTE : 1,
		IngredientData.FLAVORS.AROMA : 1,
		IngredientData.FLAVORS.TEXTURE : 1,
		IngredientData.FLAVORS.CHEMESTHESIS : 1,
		IngredientData.FLAVORS.APPEARANCE : 1,
	},
	
	{
		IngredientData.FLAVORS.APPEARANCE : 1,
	},
	
	{
		IngredientData.FLAVORS.TASTE : 2,
		IngredientData.FLAVORS.AROMA : 2,
		IngredientData.FLAVORS.TEXTURE : 1,
		IngredientData.FLAVORS.CHEMESTHESIS : 1,
	},
	
	{
		IngredientData.FLAVORS.TASTE : 3,
		IngredientData.FLAVORS.AROMA : 2,
		IngredientData.FLAVORS.TEXTURE : 1,
	},
	
	{
		IngredientData.FLAVORS.TASTE : 1,
		IngredientData.FLAVORS.AROMA : 1,
		IngredientData.FLAVORS.TEXTURE : 1,
	},
	
	{
		IngredientData.FLAVORS.TASTE : 5,
		IngredientData.FLAVORS.AROMA : -1,
		IngredientData.FLAVORS.TEXTURE : 5,
	},
	
	{
		IngredientData.FLAVORS.TASTE : 2,
		IngredientData.FLAVORS.AROMA : 2,
		IngredientData.FLAVORS.TEXTURE : 2,
		IngredientData.FLAVORS.CHEMESTHESIS : 1,
		IngredientData.FLAVORS.APPEARANCE : 1,
	},
	
]

func _ready():
	for flavorDict in toCheck:
		print(IngredientData.getFlavorsToString(flavorDict))
		print("")
