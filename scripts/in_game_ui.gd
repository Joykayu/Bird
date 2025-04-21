extends Control

var fail_icon = preload("res://assets/graphics/food/makis/cross.png")

@onready var recipe_stars = [%Inventory/FinalSlot/StarsSprite, %Inventory/FinalSlot/StarsSprite2, %Inventory/FinalSlot/StarsSprite3]

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

func update_recipe_sprite(is_successful: bool) -> void:
	if is_successful == null:
		%Inventory/FinalSlot/RecipeSprite.texture = null
	elif is_successful :
		%Inventory/FinalSlot/RecipeSprite.texture = GlobalInventory.recipe_history[-1].icon
		for star_idx in range(3):
			recipe_stars[star_idx].visible = GlobalInventory.recipe_history[-1].quality[star_idx]
	else:
		%Inventory/FinalSlot/RecipeSprite.texture = fail_icon
