extends TouchScreenButton

var base_size := Vector2.ZERO
var scaled_size := Vector2.ZERO
var parent

func _on_right_button_control_resized():
	base_size = texture_normal.get_size()
	scaled_size = get_parent().size
	self.scale = scaled_size/base_size
