extends Node2D

class_name EnergyNode

var used : bool = false

@onready var spriteEnergy : Sprite2D = $EnergySprite
@onready var spriteSocket : Sprite2D = $EnergySocket

func setUsed(used : bool) -> void:
	self.used = used
	spriteEnergy.visible = not used
