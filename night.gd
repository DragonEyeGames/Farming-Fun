extends CanvasModulate

@export var day_length_seconds := 120.0 # full day length
@export var SignalBus: Node2D
@export var time := 0.0 # 0.0 - 1.0
var prev_time := 0.0

@onready var color_rect := self

func _process(delta):
	prev_time = time
	time += delta / day_length_seconds
	time = fposmod(time, 1.0)

	if prev_time > time:
		SignalBus.emit_signal("tick")

	update_lighting()
	GameManager.time=time

func update_lighting():
	var night_color := Color(0.2, 0.2, 0.2)
	var day_color := Color.WHITE

	var daylight := sin(time * TAU - PI / 2) * 0.5 + 0.5
	color_rect.color = night_color.lerp(day_color, daylight)
