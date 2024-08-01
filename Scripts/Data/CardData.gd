extends Resource

class_name CardData

enum CARD_TYPE \
{
	INGREDIENT,
	ACTION
}

enum RARITY \
{
	COMMON,
	UNCOMMON,
	RARE
}

var name : String = "_no_name"
var cardType : CARD_TYPE
var rarity : RARITY = RARITY.COMMON
var image : Texture2D

func _init(name : String, cardType : CARD_TYPE, rarity : RARITY, image : Texture2D):
	self.name = name
	self.cardType = cardType
	self.rarity = rarity
	self.image = image

func getDesc() -> String:
	return "_no_desc"
