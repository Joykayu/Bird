extends Control

var fail_icon = preload("res://assets/graphics/food/makis/cross.png")




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
	$UI/Inventory.hide()
	$UI/StartupScreen.show()

func start_game() -> void:
	print("start")
	# show start screen, hide others
	$UI/GameOverScreen.hide()
	$UI/TutorialScreen.hide()
	$UI/Inventory.show()
	$UI/StartupScreen.hide()
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
	$UI/Inventory.hide()
	$UI/GameOverScreen.show()
	
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
		$UI/Inventory/Slot0/IngredientSprite.texture = GlobalInventory.slot_0.icon
	else:
		$UI/Inventory/Slot0/IngredientSprite.texture = null
		
	if GlobalInventory.slot_1 != null:
		$UI/Inventory/Slot1/IngredientSprite.texture = GlobalInventory.slot_1.icon
	else:
		$UI/Inventory/Slot1/IngredientSprite.texture = null
		
	if GlobalInventory.slot_2 != null:
		$UI/Inventory/Slot2/IngredientSprite.texture = GlobalInventory.slot_2.icon
	else:
		$UI/Inventory/Slot2/IngredientSprite.texture = null

func update_recipe_sprite(is_successful: bool) -> void:
	if is_successful == null:
		$UI/Inventory/FinalSlot/RecipeSprite.texture = null
	elif is_successful :
		$UI/Inventory/FinalSlot/RecipeSprite.texture = GlobalInventory.recipe_history[-1].icon
	else:
		$UI/Inventory/FinalSlot/RecipeSprite.texture = fail_icon
