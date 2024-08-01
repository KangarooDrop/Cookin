extends CardNode

class_name IngredientCardNode

@onready var tagHolder : HBoxContainer = $ScaleBottomUp/ScaleCenter/Front/TextureRect/TagHolder

var tagShowDelay : float = 0.0
var tagShowTimer : float = 0.0

const TAG_SHOW_DELAY : float = 0.25
const TAG_SHOW_MAX_TIME : float = 0.5

func clearTags() -> void:
	for c in tagHolder.get_children():
		c.queue_free()

func addTag(tag : IngredientData.TAGS) -> void:
	var tagNode : TagNode = Preloader.tagNode.instantiate()
	tagHolder.add_child(tagNode)
	tagNode.setTag(tag)

func setTags(tags : Array[IngredientData.TAGS]) -> void:
	clearTags()
	if tags.size() == 0:
		addTag(IngredientData.TAGS.NONE)
	else:
		for tag in tags:
			addTag(tag)

func setCardData(cardData : CardData) -> void:
	assert(cardData is IngredientData, "ERROR: Non-ingredient data passed to ingredient card")
	super.setCardData(cardData)
	setTags(cardData.tags)

func onMouseEnter() -> void:
	super.onMouseEnter()
	tagShowDelay = 0.0

func onMouseExit() -> void:
	super.onMouseExit()

func _process(delta):
	if hasMouseFocus:
		if tagShowDelay < TAG_SHOW_DELAY:
			tagShowDelay += delta
		elif tagShowTimer < TAG_SHOW_MAX_TIME:
			tagShowTimer += delta
			tagHolder.modulate.a = lerp(0.0, 1.0, tagShowTimer/TAG_SHOW_MAX_TIME)
	elif tagShowTimer > 0.0:
		tagShowTimer -= delta
		tagHolder.modulate.a = lerp(0.0, 1.0, tagShowTimer/TAG_SHOW_MAX_TIME)
