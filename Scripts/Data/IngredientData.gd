extends CardData

class_name IngredientData

class IngredientEffect:
	enum AFFECT_TYPE\
	{
		POSITIVE,
		NEUTRAL,
		NEGATIVE,
		MODIFY
	}
	
	var from : IngredientData = null
	var to : IngredientData = null
	var type : AFFECT_TYPE = AFFECT_TYPE.MODIFY
	var strength : int = 0
	
	func _init(from : IngredientData, to : IngredientData, type : AFFECT_TYPE, strength : int):	
		self.from = from
		self.to = to
		self.type = type
		self.strength = strength

####################################################################################################

enum FLAVORS\
{
	TASTE = 0,
	AROMA = 1,
	TEXTURE = 2,
	CHEMESTHESIS = 3,
	APPEARANCE = 4,
}

enum TAGS\
{
	NONE = 			0,
	SPICY = 		1,
	MENTHOL = 		2,
	LICORICE = 		3,
	
	PROTEIN = 		4,
	STARCH = 		5,
	FAT = 			6,
	
	FRUIT = 		7,
	VEGITABLE = 	8,
	
	SUGAR = 		9,
	DAIRY = 		10,
	
	SPICE = 		11,
	
	GARNISH = 		12,
}

var flavors : Dictionary = IngredientData.fillFlavors(getFlavors())
var tags : Array[TAGS] = getTags()

func _init(name : String, rarity : RARITY, image : Texture2D, \
		):
	super._init(name, CARD_TYPE.INGREDIENT, rarity, image)

static func fillFlavors(flavors : Dictionary) -> Dictionary:
	for flav in FLAVORS.values():
		if not flav in flavors:
			flavors[flav] = 0
	return flavors

static func getFlavorsToString(flavorDict : Dictionary, delimeter : String = "; ", withIcon : bool = true) -> String:
	var flavorsToCheck : Dictionary = {}
	for flavor in flavorDict.keys():
		if flavorDict[flavor] != 0:
			flavorsToCheck[flavor] = flavorDict[flavor]
	if flavorsToCheck.size() <= 0:
		return ""
	var string : String = ""
	var ord : Array = []
	while flavorsToCheck.size() > 0:
		var highestFlavors : Array = []
		var highestScore : int = 0
		for flavor in flavorsToCheck.keys():
			if highestScore == 0 or flavorsToCheck[flavor] > highestScore:
				highestFlavors = [flavor]
				highestScore = flavorsToCheck[flavor]
			elif flavorsToCheck[flavor] == highestScore:
				highestFlavors.append(flavor)
		ord.append([highestScore, highestFlavors])
		for flavor in highestFlavors:
			flavorsToCheck.erase(flavor)
	
	for i in range(ord.size()):
		var data : Array = ord[i]
		var score : int = data[0]
		var flavors : Array = data[1]
		if flavors.size() == 1:
			var flavor : FLAVORS = flavors[0]
			string += IngredientData.getFlavorScoreToString(score, flavor, withIcon)
		else:
			for j in range(flavors.size()):
				var flavor : FLAVORS = flavors[j]
				string += IngredientData.getFlavorScoreToString(score, flavor, withIcon)
				if j == flavors.size()-1:
					pass
				elif flavors.size() != 2:
					string += ", "
				else:
					string += " "
				if j == flavors.size()-2:
					string += "and "
		if i < ord.size()-1:
			string += delimeter
		
	return string

static func getFlavorToString(flavor : FLAVORS, withIcon : bool = true) -> String:
	var rtn : String = ""
	rtn += (FLAVORS.keys()[flavor] as String).capitalize()
	if withIcon:
		rtn += " [img=24x24 region=0," + str(int(flavor)*128) +",128,128]res://Art Assets/card/flavors.png[/img]"
	return rtn

static func getFlavorScoreToString(score : int, flavor : FLAVORS, withIcon : bool = true) -> String:
	var rtn : String = ""
	if score >= 0:
		rtn += "[color=#" + Preloader.COLOR_STAT_UP.to_html() + "]+" + str(score) + " "
	else:
		rtn += "[color=#" + Preloader.COLOR_STAT_DOWN.to_html() + "]" + str(score) + " "
	rtn += getFlavorToString(flavor, withIcon)
	rtn += "[/color]"
	return rtn

func getFlavorString() -> String:
	return IngredientData.getFlavorsToString(flavors)

####################################################################################################

func getFlavors() -> Dictionary:
	return {}

func getTags() -> Array[TAGS]:
	return []

func getDesc() -> String:
	var fs : String = getFlavorString()
	if fs.length() > 0:
		return getFlavorString() + ". "
	else:
		return ""

####################################################################################################

func beforeAddToRecipe(_recipe : RecipeNode) -> void:
	pass

func afterAddToRecipe(_recipe : RecipeNode) -> void:
	pass

####################################################################################################

func beforeRemoveFromRecipe(_recipe : RecipeNode) -> void:
	pass

func afterRemoveFromRecipe(_recipe : RecipeNode) -> void:
	pass

####################################################################################################

func beforeOtherAddToRecipe(_recipe : RecipeNode, _other : Component) -> void:
	pass

func afterOtherAddToRecipe(_recipe : RecipeNode, _other : Component) -> void:
	pass

####################################################################################################

func beforeOtherRemoveFromRecipe(_recipt : RecipeNode, _other : Component) -> void:
	pass

func afterOtherRemoveFromRecipe(_recipt : RecipeNode, _other : Component) -> void:
	pass

####################################################################################################

func beforeMoveInRecipe(_recipe : RecipeNode, _index : int) -> void:
	pass

func afterMoveInRecipe(_recipe : RecipeNode, _index : int) -> void:
	pass

####################################################################################################

func beforeOtherMoveInRecipe(_recipe : RecipeNode, _other : Component, _newIndex : int) -> void:
	pass

func afterOtherMoveInRecipe(_recipe : RecipeNode, _other : Component, _oldIndex : int) -> void:
	pass

####################################################################################################

func apply(_recipeNode : RecipeNode) -> void:
	pass

func getComponent(recipeNode : RecipeNode) -> Component:
	return recipeNode.getIngredientComponent(self)

func getAffect(_recipe : RecipeNode, other : Component) -> IngredientEffect:
	return IngredientEffect.new(self, other.ingredientData, IngredientEffect.AFFECT_TYPE.MODIFY, 0)
