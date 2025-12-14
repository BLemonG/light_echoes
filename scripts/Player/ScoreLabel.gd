extends Label
@onready var timer: Timer = $"../Timer"

var elapsed_time: int = 0

func _ready() -> void:
	timer.start()
	PlayerStats.reset_score()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var score = PlayerStats.score
	var min = elapsed_time / 60
	var sec = elapsed_time % 60
	text = "Score: " + str(score) + "\n" + "Time: " + "%02d:%02d" % [min, sec]


func _on_timer_timeout() -> void:
	elapsed_time += 1
	
