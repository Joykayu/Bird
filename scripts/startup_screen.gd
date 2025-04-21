extends Control



func _on_start_button_pressed() -> void:
	%Sounds/ButtonClick.play()
	get_tree().get_root().get_node("Main").start_game()


func _on_tutorial_button_pressed() -> void:
	%Sounds/ButtonClick.play()
	get_tree().get_root().get_node("Main").show_tutorial()
