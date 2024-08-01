extends Node

class_name StatChart

var stats : Dictionary = {}
var total : int = 1
var points : Array[Vector2] = []
var colors : Array[Color] = []

@onready var polyBackground : Polygon2D = $PolyBackground
@onready var polyStats : Polygon2D = $PolyStats
@onready var lineHolder : Node2D = $LineHolder

const LENGTH : float = 150.0
const SMOOTHING : int = 2
const DEPTH : int = 3
const MOVE_SPEED : float = 128.0
const COLOR_SPEED : float = 2.0

const COLOR_GOOD : Color = Color.YELLOW #Color(0.125, 0.5, 0.0, 1.0)
const COLOR_NEUTRAL : Color = Color.WHITE #Color(1.0, 1.0, 1.0, 1.0)
const COLOR_BAD : Color = Color.BLACK #Color(0.5, 0.0, 0.0, 1.0)

func _ready():
	pass

func resetBackPoly() -> void:
	var backPoints : Array[Vector2] = []
	for j in range(DEPTH+1):
		var line : Line2D = Line2D.new()
		lineHolder.add_child(line)
		line.default_color = Color.DARK_SLATE_GRAY
		line.default_color.a = 0.25
		line.width = 3.0
		var linePoints : Array[Vector2] = []
		var d : float = float(j+1)/(DEPTH+1)
		for i in range(stats.size()+1):
			if i == stats.size():
				i = 0
			var point : Vector2 = Vector2.UP.rotated(float(i)/stats.size() * PI * 2.0) * LENGTH * d
			linePoints.append(point)
		line.points = PackedVector2Array(linePoints)
	
	for i in range(stats.size()):
		var point : Vector2 = Vector2.UP.rotated(float(i)/stats.size() * PI * 2.0) * LENGTH
		backPoints.append(point)
		var line : Line2D = Line2D.new()
		lineHolder.add_child(line)
		line.points = PackedVector2Array([Vector2.ZERO, point])
		line.default_color = Color.BLACK
		line.width = 3.0
	polyBackground.polygon = PackedVector2Array(backPoints)

func resetStatsPoly() -> void:
	points.clear()
	colors.clear()
	var vals : Array = stats.values()
	for index : int in range(stats.size()):
		for j in range(SMOOTHING+1):
			var d : float = float(j)/(SMOOTHING+1)
			var v0 : float = max(-1.0, min(1.0, float(vals[index]) / abs(total)))
			var v1 : float = max(-1.0, min(1.0, float(vals[(index+1) % vals.size()]) / abs(total)))
			var v : float = lerp(v0, v1, d)
			var f : float = float(index + d)/stats.size()
			var r : float = f * PI * 2.0
			var s : float = LENGTH * sqrt(abs(v))
			points.append(Vector2.UP.rotated(r) * s)
			if v < 0.0:
				colors.append(COLOR_NEUTRAL.lerp(COLOR_BAD, abs(v)))
			else:
				colors.append(COLOR_NEUTRAL.lerp(COLOR_GOOD, abs(v)))
	
	if polyStats.polygon.size() != points.size():
		polyStats.polygon = PackedVector2Array(points)
		polyStats.vertex_colors = PackedColorArray(colors)

func setStats(stats : Dictionary) -> void:
	var resize : int = self.stats.size() != stats.size()
	self.stats = stats
	if resize:
		resetBackPoly()
	
	total = 0
	for val in stats.values():
		total += val
	if total == 0:
		total = 1
	
	resetStatsPoly()

func _process(delta):
	for i in range(points.size()):
		var moveDiff : Vector2 = points[i] - polyStats.polygon[i]
		if moveDiff.length() < MOVE_SPEED * delta:
			polyStats.polygon[i].x = points[i].x
			polyStats.polygon[i].y = points[i].y
		else:
			var dir : Vector2 = moveDiff.normalized()
			polyStats.polygon[i].x += dir.x * MOVE_SPEED * delta
			polyStats.polygon[i].y += dir.y * MOVE_SPEED * delta
		
		var colorDiff : Vector4 = Vector4(\
			colors[i].r - polyStats.vertex_colors[i].r, 
			colors[i].g - polyStats.vertex_colors[i].g, 
			colors[i].b - polyStats.vertex_colors[i].b, 
			colors[i].a - polyStats.vertex_colors[i].a)
		if colorDiff.length() < COLOR_SPEED * delta:
			polyStats.vertex_colors[i].r = colors[i].r
			polyStats.vertex_colors[i].g = colors[i].g
			polyStats.vertex_colors[i].b = colors[i].b
			polyStats.vertex_colors[i].a = colors[i].a
		else:
			var dif : Vector4 = colorDiff.normalized()
			polyStats.vertex_colors[i].r += colorDiff.x * COLOR_SPEED * delta
			polyStats.vertex_colors[i].g += colorDiff.y * COLOR_SPEED * delta
			polyStats.vertex_colors[i].b += colorDiff.z * COLOR_SPEED * delta
			polyStats.vertex_colors[i].a += colorDiff.w * COLOR_SPEED * delta
