extends Node

const COLOR_STAT_UP : Color = Color.GREEN
const COLOR_STAT_DOWN : Color = Color.RED

const card_art_base : String = "res://Art Assets/card/card_art/"

const art_chickpeas : Texture2D = 				preload(card_art_base + "chickpeas.png")
const art_garlic : Texture2D = 					preload(card_art_base + "garlic.png")
const art_green_onion_tops : Texture2D = 		preload(card_art_base + "green_onion_tops.png")
const art_potato : Texture2D = 					preload(card_art_base + "potato.png")
const art_salt : Texture2D = 					preload(card_art_base + "salt.png")
const art_sichuan_peppercorns : Texture2D = 	preload(card_art_base + "sichuan_peppercorns.png")

const art_baking_soda : Texture2D = 			preload(card_art_base + "baking_soda.png")
const art_chile_crips : Texture2D = 			preload(card_art_base + "chile_crisp.png")
const art_separator : Texture2D = 				preload(card_art_base + "separator.png")

const energyNode : PackedScene = 				preload("res://Scenes/Competition/EnergyNode.tscn")
const tagNode : PackedScene = 					preload("res://Scenes/Competition/TagNode.tscn")
const setupNode : PackedScene = 				preload("res://Scenes/Competition/SetupNode.tscn")

const ingredientCardNode : PackedScene = 		preload("res://Scenes/Competition/IngredientCardNode.tscn")
const actionCardNode : PackedScene = 			preload("res://Scenes/Competition/ActionCardNode.tscn")
const componentNode : PackedScene = 			preload("res://Scenes/Competition/ComponentNode.tscn")
const recipeArrowNode : PackedScene = 			preload("res://Scenes/Competition/RecipeArrowNode.tscn")
const flavorConfetti : PackedScene = 			preload("res://Scenes/Competition/FlavorConfetti.tscn")
