extends Control


func _on_submit_high_score_button_pressed() -> void:
	%Sounds/ButtonClick.play()
	get_tree().get_root().get_node("Main").submit_high_score()


func _on_restart_button_pressed() -> void:
	%Sounds/ButtonClick.play()
	get_tree().get_root().get_node("Main").start_game()


func _on_startup_button_pressed() -> void:
	%Sounds/ButtonClick.play()
	get_tree().get_root().get_node("Main").show_startup_screen()
