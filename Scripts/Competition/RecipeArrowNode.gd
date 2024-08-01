extends Node2D

class_name RecipeArrowNode

var freeOnFinish : bool = true
var timer : float = 0.0
var endDelay : float = END_MAX_TIME
var endPos : Vector2 = Vector2.ZERO

const TRAVEL_MAX_TIME : float = 0.35
const END_MAX_TIME : float = 0.1
const CURVE_MIN : float = 30.0
const OUT_MIN : float = 40.0
const PATH_LENGTH_MIN : float = 5.0

var path : Array = []

@onready var line : Line2D = $Line2D
@onready var tipSprite : Sprite2D = $TipSprite

signal travel_finished(recipeArrowNode : RecipeArrowNode)

static func getCurvePoint(p0 : Vector2, p1 : Vector2, p2 : Vector2, dist : float) -> Vector2:
	var q0 : Vector2 = p1 + -(p1-p0).normalized() * (CURVE_MIN - (dist+CURVE_MIN)/2.0)
	var q1 : Vector2 = p1 + (p2-p1).normalized() * (dist+CURVE_MIN)/2.0
	var q2 : Vector2 = lerp(q0, q1, (dist)/CURVE_MIN * 0.5 + 0.5)
	return q2

func setColor(color : Color) -> void:
	modulate = color

func setEndPos(endPos) -> void:
	self.endPos = endPos
	
	var p0 : Vector2 = Vector2.ZERO
	var p1 : Vector2 = Vector2(max(endPos.x/2.0, OUT_MIN), 0.0)
	var p2 : Vector2 = Vector2(max(endPos.x/2.0, OUT_MIN), endPos.y)
	var p3 : Vector2 = Vector2(endPos.x, endPos.y)
	
	if endPos.y == 0.0:
		p1.y = -OUT_MIN
	
	var d0 : float = (p1-p0).length()
	var d1 : float = (p2-p1).length()
	var d2 : float = (p3-p2).length()
	var totalDist : float = d0 + d1 + d2
	
	var d : float = 0.0
	path.clear()
	path.append(p0)
	while d < totalDist:
		d += PATH_LENGTH_MIN
		if d < d0-CURVE_MIN:
			path.append(lerp(p0, p1, d/d0))
		elif d < d0 + CURVE_MIN:
			path.append(RecipeArrowNode.getCurvePoint(p0, p1, p2, d-d0))
		elif d < d0+d1-CURVE_MIN:
			path.append(lerp(p1, p2, (d-d0)/d1))
		elif d < d0+d1+CURVE_MIN:
			path.append(RecipeArrowNode.getCurvePoint(p1, p2, p3, d-d0-d1))
		elif d < d0+d1+d2:
			path.append(lerp(p2, p3, (d-d0-d1)/d2))
		else:
			path.append(p3)

func _process(delta):
	if timer < TRAVEL_MAX_TIME:
		timer += delta
		
		var points : Array = []
		points.append_array(path.slice(0, int(path.size() * timer/TRAVEL_MAX_TIME)))
		while points.size() < 2:
			points.append(Vector2.ZERO)
		
		var tip : Vector2 = points[points.size()-1]
		var angle : float = (tip - points[points.size()-2]).angle()
		tipSprite.position = tip
		tipSprite.rotation = angle
		line.points = PackedVector2Array(points)
		
		if timer >= TRAVEL_MAX_TIME:
			emit_signal("travel_finished", self)
	
	elif freeOnFinish:
		endDelay -= delta
		modulate.a = endDelay/END_MAX_TIME
		if endDelay <= 0.0:
			queue_free()
