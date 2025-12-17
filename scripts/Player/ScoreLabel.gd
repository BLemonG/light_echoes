extends Label
@onready var timer: Timer = $"../Timer"

func _ready() -> void:
	timer.start()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var score = PlayerStats.score
	var min = PlayerStats.elapsed_time / 60
	var sec = PlayerStats.elapsed_time % 60
	text = "Score: " + str(score) + "\n" + "Time: " + "%02d:%02d" % [min, sec]+ "\n" + "Current level: " + str(PlayerStats.current_level)


func _on_timer_timeout() -> void:
	PlayerStats.elapsed_time += 1
	
