extends Resource

class_name Recipe

var ingredientList : Array[IngredientData] = []
"""
func insert(position : int, ingredient : IngredientData) -> void:
	for ing in ingredientList:
		ing.beforeOtherAddToRecipe(self, ingredient)
	ingredient.beforeAddToRecipe(self)
	
	ingredientList.insert(position, ingredient)
	
	for ing in ingredientList:
		ing.afterOtherAddToRecipe(self, ingredient)
	ingredient.afterAddToRecipe(self)

func append(ingredient : IngredientData) -> void:
	insert(ingredientList.size(), ingredient)

func remove(index : int) -> void:
	var ingredient : IngredientData = ingredientList[index]
	for ing in ingredientList:
		ing.beforeOtherRemoveFromRecipe(self, ingredient)
	ingredient.beforeRemoveFromRecipe(self)
	
	ingredientList.remove_at(index)
	
	for ing in ingredientList:
		ing.afterOtherRemoveFromRecipe(self, ingredient)
	ingredient.afterRemoveFromRecipe(self)

func erase(ingredient : IngredientData) -> void:
	var index : int = ingredientList.find(ingredient)
	remove(index)

func move(newIndex : int, ingredient : IngredientData) -> void:
	if not ingredientList.has(ingredient):
		return
	var oldIndex : int = ingredientList.find(ingredient)
	if oldIndex == newIndex:
		return
	
	for ing in ingredientList:
		if ing != ingredient:
			ing.beforeOtherMoveInRecipe(self, ingredient, newIndex)
		else:
			ingredient.beforeMoveInRecipe(self, newIndex)
		
	if oldIndex < newIndex:
		newIndex -= 1
	ingredientList.remove_at(oldIndex)
	ingredientList.insert(newIndex, ingredient)
	
	for ing in ingredientList:
		if ing != ingredient:
			ing.afterOtherMoveInRecipe(self, ingredient, oldIndex)
		else:
			ingredient.afterMoveInRecipe(self, oldIndex)
"""
