extends Node2D

class_name SetupNode

var competitionNode : CompetitionNode = null

@onready var playerNode : PlayerNode = $PlayerNode
@onready var handNode : HandNode = $HandNode
@onready var trashNode : TrashNode = $TrashNode
@onready var stockpileNode : StockpileNode = $StockpileNode
@onready var recipeNode : RecipeNode = $RecipeNode

func _ready():
	handNode.setup = self
	recipeNode.setup = self
