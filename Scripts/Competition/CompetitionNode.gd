extends Node2D

#TODO:
# Recipe:
#  --Animation for card node entering
#  Animation showing affect on score and other ingredients
#  Show affection connections between ingredients on hover
#  Show recipe ingredient with base & modified values, and total score on hover
#
# Ingredients:
#  Affect of ingredients on eachother in a recipe
#  Example ingredient effects: garlic, etc.
#
# Art:
#  Player
#  More Cards
#  Bad background
#  "Improved" art for older stuff
#
# Turn cycle:
#  Energy setting and resetting
#  Passing
#  Turn clock (e.g. 10 to end)
#  Turn indicator
#  Drawing, discarding (choice)
#  Judging
#
# Actions:
#  Energy checking and spending
#  Example actions: smoke break, etc.
#
# Deck Editor:
#  Show scrollable list of all available cards
#  Click cards to add to deck
#  Click cards in deck to remove
#  Saving, exporting, and importing decks
#
# Judges:
#  Examples w/ personality
#  Likes/Dislikes, w/ thresholds
#  Comments on specific turns
#  Text bubbles
#
# Future:
#  Selecting cards/ingredients from stockpiles, trash, hands, recipes, etc. (tutors)
#  


class_name CompetitionNode

const ENERGY_AT_START : int = 4
const ENERGY_MAX_AT_START : int = 6

const CARDS_DRAWN_TO_AT_BEGIN : int = 5
const CARDS_AT_START : int = 5
const CARDS_DISCARDED_AT_END : int = 1
const CARDS_DRAWN_MIN : int = 1

const RECIPES_REVEALED : bool = false
const HANDS_REVEALED : bool = false

const SETUP_OFFSET : Vector2 = Vector2(-550, 0)

var setup0 : SetupNode = null
var setup1 : SetupNode = null

@onready var camera : Camera2D = $Camera2D

func _ready():
	setup0 = Preloader.setupNode.instantiate()
	add_child(setup0)
	setup0.position = SETUP_OFFSET
	camera.position.x = setup0.position.x
	
#	setup1 = Preloader.setupNode.instantiate()
#	add_child(setup1)
#	setup1.position = Vector2(-SETUP_OFFSET.x, SETUP_OFFSET.y)
#	for c in setup1.get_children():
#		c.position.x = -c.position.x
	
	await get_tree().create_timer(1.0).timeout
	setup0.handNode.addCard(CardBakingSoda.new())
	await get_tree().create_timer(0.15).timeout
	setup0.handNode.addCard(CardGarlic.new())
	await get_tree().create_timer(0.15).timeout
	setup0.handNode.addCard(CardChickpeas.new())
	await get_tree().create_timer(0.15).timeout
	setup0.handNode.addCard(CardGreenOnionTops.new())
	await get_tree().create_timer(0.15).timeout
	setup0.handNode.addCard(CardPotato.new())
	await get_tree().create_timer(0.15).timeout
	setup0.handNode.addCard(CardSalt.new())
	await get_tree().create_timer(0.15).timeout
	setup0.handNode.addCard(CardSalt.new())
	await get_tree().create_timer(0.15).timeout
	setup0.handNode.addCard(CardSalt.new())
	await get_tree().create_timer(0.15).timeout
	setup0.handNode.addCard(CardSalt.new())
	await get_tree().create_timer(0.15).timeout
	setup0.handNode.addCard(CardSichuanPeppercorn.new())
	await get_tree().create_timer(0.15).timeout
	setup0.handNode.addCard(CardChileCrisp.new())
	
	await get_tree().create_timer(0.15).timeout
	setup0.handNode.addCard(CardSeparator.new())
