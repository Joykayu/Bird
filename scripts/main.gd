extends Control

var api_key := "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImpzY3Zvc3ZtYnVpZnlzYW1ybmt0Iiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc0NTI0MDQwOSwiZXhwIjoyMDYwODE2NDA5fQ.zLCqbq5Slh5D_Um_EuTiFSCdRdHAHeDgxKn-vjwudrY"

# touchscreen_mode controls whether to activate touchscreen controls, or default to keyboard mode. Importantly, this makes the dash button show up or not.
#var touchscreen_mode := false

func _ready():
	
	
	## upon starting, detect if being played on smartphone or computer.
	#match OS.get_name():
		#"Android","iOS":
			## toggle touchscreen mode
			#touchscreen_mode = true
		#_:
			## default to keyboard mode
			#touchscreen_mode = false
	
	# connect stuff
	GlobalInventory.ing_list_updated.connect(on_ing_list_updated)
	GlobalInventory.recipe_crafted.connect(on_recipe_crafted)
	GlobalInventory.next_recipe.connect(on_next_recipe)
	$CookingTimer.timeout.connect(GlobalInventory.on_cooking_timer_timeout) 
	
	# show start screen, hide others
	show_startup_screen()
	
	# play music
	$Sounds/MusicMenu.play()
	
	# fetch scores from online scoreboard
	get_scores()
	
	
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
	
	# Reset score, combo, recipe history, inventory etc
	GlobalInventory.score = 0.0
	GlobalInventory.combo = 1.0
	GlobalInventory.reset_inventory()
	GlobalInventory.reset_history()
	# reset UI
	$UI/InGameUI.reset_recipe_sprites()
	
	
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
	
	
func submit_score(name: String) -> void:	
	$HTTPRequest.request_completed.connect(on_score_insert_completed)
	var url := "https://jscvosvmbuifysamrnkt.supabase.co/rest/v1/score"
	var score := GlobalInventory.score
	var json = JSON.stringify({
		"score": int(score),
		"name": name,
	})
	var headers = [
		"Content-Type: application/json", 
		"Prefer: return=minimal",
		"apikey: " + self.api_key,
	]
	$HTTPRequest.request(url, headers, HTTPClient.METHOD_POST, json)

func on_score_insert_completed(result, response_code, headers, body):
	show_startup_screen()
	
	
func get_scores() -> void:
	$HTTPRequest.request_completed.connect(on_score_read_completed)
	var url := "https://jscvosvmbuifysamrnkt.supabase.co/rest/v1/score?select=*"
	var headers := [
		"apikey: " + self.api_key
	]
	$HTTPRequest.request(url, headers)
	
func on_score_read_completed(result, response_code, headers, body):
	var score_array = JSON.parse_string(body.get_string_from_utf8())
	#print(response_code, JSON.stringify(score_array))

	var score_string := ""
	for i in range(score_array.size()):
		score_string += str(i+1) + ": " + str(score_array[i]["name"]) + "  -  " + str(score_array[i]["score"]) + "\n"
		
	$UI/StartupScreen/ColorRect/ScoreLabel.text = score_string
		
	
	
func _on_game_timer_timeout() -> void:
	print("game timeout!")
	end_game()
	

## Inventory display functions

func on_ing_list_updated() -> void:
	$UI/InGameUI.update_ingredients_sprite()

func on_recipe_crafted() -> void:
	$UI/InGameUI.update_recipe_sprite(false)
	$CookingTimer.start()

func on_next_recipe() -> void:
	$UI/InGameUI.update_recipe_sprite(true)
