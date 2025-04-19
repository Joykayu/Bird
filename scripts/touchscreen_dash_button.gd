extends TouchScreenButton

var base_size := Vector2.ZERO
var scaled_size := Vector2.ZERO
var parent


func _on_center_container_resized():
	base_size = texture_normal.get_size()
	scaled_size = get_parent().size
	scaled_size.x /= 2
	position.x = scaled_size.x/2
	self.scale = scaled_size/base_size
