extends Node

class_name TagNode

@onready var label : RichTextLabel = $RichTextLabel
@onready var textureRect : TextureRect = $TextureRect
@onready var atlas : AtlasTexture = textureRect.texture as AtlasTexture

func setTag(tag : IngredientData.TAGS) -> void:
	var tagName : String = IngredientData.TAGS.keys()[tag].capitalize()
	var tagOffset : float = tag * 128.0
	label.text = "[center]" + tagName + "[/center]"
	atlas.region.position.y = tagOffset
