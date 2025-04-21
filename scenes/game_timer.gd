extends Timer

var half_time_flag := false

func _process(delta: float) -> void:
	if time_left == 0:
		return
	if self.time_left < 30 and half_time_flag == false:
		print("half")
		%Sounds/GameHalfTime.play()
		half_time_flag = true
