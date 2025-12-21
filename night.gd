extends CanvasModulate

@export var day_length_seconds := 120.0 # full day length
@export var SignalBus: Node2D
var time_of_day := 0.0 # 0.0 - 1.0
var prev_time := 0.0

@onready var color_rect := self

func _process(delta):
	prev_time = time_of_day
	time_of_day += delta / day_length_seconds
	time_of_day = fposmod(time_of_day, 1.0)

	if prev_time > time_of_day:
		SignalBus.emit_signal("tick")

	update_lighting()

func update_lighting():
	var night_color := Color(0.2, 0.2, 0.2)
	var day_color := Color.WHITE

	var daylight := sin(time_of_day * TAU - PI / 2) * 0.5 + 0.5
	color_rect.color = night_color.lerp(day_color, daylight)
