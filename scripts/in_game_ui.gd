extends Control


@onready var recipe_stars = [%Inventory/FinalSlot/StarsSprite, %Inventory/FinalSlot/StarsSprite2, %Inventory/FinalSlot/StarsSprite3]
@onready var history_0_stars = [%Inventory/HistorySlot0/StarsSprite, %Inventory/HistorySlot0/StarsSprite2, %Inventory/HistorySlot0/StarsSprite3]
@onready var history_1_stars = [%Inventory/HistorySlot1/StarsSprite, %Inventory/HistorySlot1/StarsSprite2, %Inventory/HistorySlot1/StarsSprite3]

func update_ingredients_sprite()-> void:
	if GlobalInventory.slot_0 != null:
		%Inventory/Slot0/IngredientSprite.texture = GlobalInventory.slot_0.icon
		if GlobalInventory.shiny_ingredients[0] :
			%Inventory/Slot0/StarsSprite.show()
	else:
		%Inventory/Slot0/IngredientSprite.texture = null
		%Inventory/Slot0/StarsSprite.hide()
		
	if GlobalInventory.slot_1 != null:
		%Inventory/Slot1/IngredientSprite.texture = GlobalInventory.slot_1.icon
		if GlobalInventory.shiny_ingredients[1]:
			%Inventory/Slot1/StarsSprite.show()
	else:
		%Inventory/Slot1/IngredientSprite.texture = null
		%Inventory/Slot1/StarsSprite.hide()
		
	if GlobalInventory.slot_2 != null:
		%Inventory/Slot2/IngredientSprite.texture = GlobalInventory.slot_2.icon
		if GlobalInventory.shiny_ingredients[2]:
			%Inventory/Slot2/StarsSprite.show()
	else:
		%Inventory/Slot2/IngredientSprite.texture = null
		%Inventory/Slot2/StarsSprite.hide()

func update_recipe_sprite(go_next) -> void:
	if !go_next:
		%Inventory/FinalSlot/RecipeSprite.texture = GlobalInventory.recipe_history[-1].icon
		for star_idx in range(3):
			recipe_stars[star_idx].visible = GlobalInventory.recipe_history[-1].quality[star_idx]
	else:
		# reset recipe 
		%Inventory/FinalSlot/RecipeSprite.texture = null
		for star_idx in range(3):
			recipe_stars[star_idx].visible = false
			
		# set recipe history 0
		%Inventory/HistorySlot0/RecipeSprite.texture = GlobalInventory.recipe_history[-1].icon
		for star_idx in range(3):
			history_0_stars[star_idx].visible = GlobalInventory.recipe_history[-1].quality[star_idx]
		
		# set recipe history 1
		if GlobalInventory.recipe_history.size() > 1:
			%Inventory/HistorySlot1/RecipeSprite.texture = GlobalInventory.recipe_history[-2].icon
			for star_idx in range(3):
				history_1_stars[star_idx].visible = GlobalInventory.recipe_history[-2].quality[star_idx]
