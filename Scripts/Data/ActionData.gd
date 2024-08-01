extends CardData

class_name ActionData

var cost : int = 0

func _init(name : String, rarity : RARITY, image : Texture2D, \
		cost : int):
	super._init(name, CARD_TYPE.ACTION, rarity, image)
	self.cost = cost

func getDesc() -> String:
	return ""

func canPlay(canPlay : CardNode) -> bool:
	return true

func onPlay(cardNode : CardNode) -> void:
	pass
