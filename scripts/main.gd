extends Control





func _ready():
	GlobalInventory.ing_list_updated.connect(on_ing_list_updated)
	GlobalInventory.recipe_crafted.connect(on_recipe_crafted)
	GlobalInventory.recipe_failed.connect(on_recipe_failed)
	
	# show start screen, hide others
	show_startup_screen()
	$Sounds/MusicMenu.play()
	
## UI display functions
func show_startup_screen() -> void:
	# show start screen, hide others
	$UI/GameOverScreen.hide()
	$UI/TutorialScreen.hide()
	$UI/InGameUI.hide()
	$UI/StartupScreen.show()

func start_game() -> void:
	print("start")
	# show start screen, hide others
	$Sounds/MusicMenu.stop()
	$Sounds/MusicGame.play()
	$Sounds/GameGong.play()
	$Sounds/GameHajime.play()
	
	$UI/GameOverScreen.hide()
	$UI/TutorialScreen.hide()
	$UI/InGameUI.show()
	$UI/StartupScreen.hide()
	
	$World/Bird.activate()
	$World/Bird.set_position(Vector2(0,0))
	# Start game timer
	$GameTimer.start()
	
	# Reset score, combo, recipe history, etc
	GlobalInventory.score = 0.0
	GlobalInventory.combo = 1.0
	GlobalInventory.recipe_history = []
	
func show_tutorial() -> void:
	print("show tutorial")
	$UI/StartupScreen.hide()
	$UI/TutorialScreen.show()
	
func hide_tutorial() -> void:
	print("hide tutorial")
	$UI/TutorialScreen.hide()
	$UI/StartupScreen.show()
	
func end_game() -> void:
	print("end_game")
	
	$Sounds/MusicMenu.play()
	$Sounds/MusicGame.stop()
	$Sounds/GameGong.play()
	$Sounds/GameMate.play()
	
	$UI/InGameUI.hide()
	$UI/GameOverScreen.show()
	
	$World/Bird.deactivate()
	
func submit_high_score() -> void:
	print("high score submitted")
	
func _on_game_timer_timeout() -> void:
	print("game timeout!")
	end_game()
	

## Inventory display functions

func on_ing_list_updated() -> void:
	$UI/InGameUI.update_ingredients_sprite()

func on_recipe_crafted(_is_new_recipe) -> void:
	$UI/InGameUI.update_recipe_sprite(true)

func on_recipe_failed() -> void:
	$UI/InGameUI.update_recipe_sprite(false)
