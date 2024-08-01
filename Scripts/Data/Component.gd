extends Resource

class_name Component

var ingredientData : IngredientData = null
var flavorsModified : Dictionary = {}
var bonusMulSelf : Dictionary = {}
var bonusMulOthers : Dictionary = {}

var affectedBy : Dictionary = {}

var recipeNode : RecipeNode = null

func _init():
	pass

func setRecipeNode(recipeNode : RecipeNode) -> void:
	self.recipeNode = recipeNode

func setIngredientData(ingredientData : IngredientData) -> void:
	self.ingredientData = ingredientData
	reset()

func reset() -> void:
	flavorsModified = ingredientData.flavors.duplicate()
	bonusMulSelf.clear()
	bonusMulOthers.clear()
	for flavor : IngredientData.FLAVORS in IngredientData.FLAVORS.values():
		bonusMulSelf[flavor] = 1.0
		bonusMulOthers[flavor] = 1.0
	affectedBy.clear()

func apply() -> void:
	ingredientData.apply(recipeNode)

####################################################################################################

func showAffecting() -> Array[RecipeArrowNode]:
	var affecting : Dictionary = {}
	for otherComponent : Component in recipeNode.components:
		if self in otherComponent.affectedBy:
			affecting[otherComponent] = otherComponent.affectedBy[self]
	
	var arrows : Array[RecipeArrowNode] = []
	for otherComponent : Component in affecting.keys():
		var flavorDict : Dictionary = affecting[otherComponent]
		var total : int = 0
		for flavor in flavorDict.keys():
			total += flavorDict[flavor]
		var arrow : RecipeArrowNode = null
		if total >= 0:
			arrow = recipeNode.addArrowAnim(self, [otherComponent], Preloader.COLOR_STAT_UP, false)[0]
		else:
			arrow = recipeNode.addArrowAnim(self, [otherComponent], Preloader.COLOR_STAT_DOWN, false)[0]
		
		var confetti : FlavorConfetti = otherComponent.makeConfetti(flavorDict)
		confetti.velocity = Vector2.ZERO
		confetti.gravity = Vector2.ZERO
		confetti.playing = false
		arrow.connect("tree_exited", (func(confetti : FlavorConfetti): confetti.playing = true).bind(confetti))
		arrows.append(arrow)
		
	return arrows

func addFlavorOthers(others : Array[Component], flavor : IngredientData.FLAVORS, amount : int) -> void:
	var amountModified : int = int(amount * bonusMulOthers[flavor])
	var color : Color = Color.RED if amount < 0 else Color.GREEN
	recipeNode.addArrowAnim(self, others, color, true, self._int_addFlavorOther.bind(others, flavor, amountModified))

####################################################################################################

func _int_addFlavorOther(others : Array[Component], flavor : IngredientData.FLAVORS, amount : int) -> void:
	for other : Component in others:
		other._int_addFlavor(self, flavor, amount)



func _int_setFlavor(source : Component, flavor : IngredientData.FLAVORS, amount : int) -> void:
	var diff : int = amount - flavorsModified[flavor]
	makeConfetti({flavor : diff})
	
	if not source in affectedBy:
		affectedBy[source] = {flavor : diff}
	elif not flavor in affectedBy[source]:
		affectedBy[source][flavor] = amount
	else:
		affectedBy[source][flavor] += diff
	
	flavorsModified[flavor] = amount
	recipeNode.getComponentToNode(self).onPop()

func _int_addFlavor(source : Component, flavor : IngredientData.FLAVORS, amount : int) -> void:
	var amountModified : int = int(amount * bonusMulSelf[flavor])
	_int_setFlavor(source, flavor, flavorsModified[flavor] + amountModified)

func _int_mulFlavor(source : Component, flavor : IngredientData.FLAVORS, amount : float) -> void:
	_int_setFlavor(source, flavor, int(flavorsModified[flavor] * amount))
	recipeNode.getComponentToNode(self).onPop()

func makeConfetti(flavorDict : Dictionary) -> FlavorConfetti:
	var confetti : FlavorConfetti = Preloader.flavorConfetti.instantiate()
	recipeNode.add_child(confetti)
	var pos : Vector2 = recipeNode.getComponentToNode(self).global_position + Vector2.RIGHT * 150.0
	confetti.global_position = pos
	confetti.setFlavors(flavorDict)
	return confetti

####################################################################################################

func getTotal() -> int:
	var total : int = 0
	for flavor in flavorsModified.keys():
		total += flavorsModified[flavor]
	return total
