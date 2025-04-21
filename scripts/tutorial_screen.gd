extends Control


func _on_return_to_startup_screen_pressed() -> void:
	get_tree().get_root().get_node("Main").hide_tutorial()
