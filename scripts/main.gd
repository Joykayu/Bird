extends Control

var fail_icon = preload("res://assets/graphics/food/makis/cross.png")

var bird_start_position := Vector2(982,584)



func _ready():
	GlobalInventory.ing_list_updated.connect(on_ing_list_updated)
	GlobalInventory.recipe_crafted.connect(on_recipe_crafted)
	GlobalInventory.recipe_failed.connect(on_recipe_failed)
	
	# show start screen, hide others
	show_startup_screen()
	
	
func show_startup_screen() -> void:
	# show start screen, hide others
	$UI/GameOverScreen.hide()
	$UI/TutorialScreen.hide()
	%GameUI.hide()
	$UI/StartupScreen.show()

func start_game() -> void:
	print("start")
	
	# Reset score, combo, recipe history, etc
	GlobalInventory.score = 0.0
	GlobalInventory.combo = 1.0
	GlobalInventory.recipe_history = []
	
	# show start screen, hide others
	$UI/GameOverScreen.hide()
	$UI/TutorialScreen.hide()
	%GameUI.show()
	$UI/StartupScreen.hide()
	
	# activate deactivate bird
	$World/Bird.activate()
	# reset position
	$World/Bird.set_position(bird_start_position)
	
	# Start game timer
	$GameTimer.start()


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
	%GameUI.hide()
	$UI/GameOverScreen.show()
	# deactivate bird
	$World/Bird.deactivate()
	
func submit_high_score() -> void:
	print("high score submitted")
	
func _on_game_timer_timeout() -> void:
	print("game timeout!")
	end_game()
	
func on_ing_list_updated() -> void:
	update_ingredients_sprite()

func on_recipe_crafted(is_new_recipe) -> void:
	update_recipe_sprite(true)

func on_recipe_failed() -> void:
	update_recipe_sprite(false)

func update_ingredients_sprite()-> void:
	if GlobalInventory.slot_0 != null:
		%Inventory/Slot0/IngredientSprite.texture = GlobalInventory.slot_0.icon
	else:
		%Inventory/Slot0/IngredientSprite.texture = null
		
	if GlobalInventory.slot_1 != null:
		%Inventory/Slot1/IngredientSprite.texture = GlobalInventory.slot_1.icon
	else:
		%Inventory/Slot1/IngredientSprite.texture = null
		
	if GlobalInventory.slot_2 != null:
		%Inventory/Slot2/IngredientSprite.texture = GlobalInventory.slot_2.icon
	else:
		%Inventory/Slot2/IngredientSprite.texture = null

func update_recipe_sprite(is_successful: bool) -> void:
	if is_successful == null:
		%Inventory/FinalSlot/RecipeSprite.texture = null
	elif is_successful :
		%Inventory/FinalSlot/RecipeSprite.texture = GlobalInventory.recipe_history[-1].icon
	else:
		%Inventory/FinalSlot/RecipeSprite.texture = fail_icon
