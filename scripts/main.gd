extends Control

var empty_slot = preload("res://icon.svg")
func _ready():
	GlobalInventory.connect("ing_list_updated",on_ing_list_updated)
	
	
	
func on_ing_list_updated():
	update_inventory_slots()

func update_inventory_slots():
	if GlobalInventory.slot_0 != null:
		$UI/Inventory/Slot0/Sprite2D.texture = GlobalInventory.slot_0.icon
	else:
		$UI/Inventory/Slot0/Sprite2D.texture = empty_slot
		
	if GlobalInventory.slot_1 != null:
		$UI/Inventory/Slot1/Sprite2D.texture = GlobalInventory.slot_1.icon
	else:
		$UI/Inventory/Slot1/Sprite2D.texture = empty_slot
		
	if GlobalInventory.slot_2 != null:
		$UI/Inventory/Slot2/Sprite2D.texture = GlobalInventory.slot_2.icon
	else:
		$UI/Inventory/Slot2/Sprite2D.texture = empty_slot
