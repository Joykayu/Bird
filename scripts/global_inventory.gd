extends Node

# init score and combo multiplier
var score := 0.0
var combo := 1.0
# how much combo increases
var combo_step := 0.5

var slot_0 :Ingredient
var slot_1 :Ingredient
var slot_2 :Ingredient
var shiny_ingredients : Array[bool] = [false, false, false]

var recipe_list : Array[Recipe] 
var recipe_history : Array[Recipe]
var history_depth : int = 2
var current_slot_idx := 0 

var is_cooking : bool = false

var failed_recipe = preload("res://assets/resources/recipes/failed_recipe.tres")

signal ing_list_updated()
signal recipe_crafted(is_succesful)
signal next_recipe()

func _ready():
	var recipe_ressource_list = get_all_resource_paths("res://assets/resources/recipes/",false,"Recipe")
	for recipe_ressource in recipe_ressource_list:
		recipe_list.append(load(recipe_ressource))


func add_ingredient(ingredient: Ingredient, is_shiny : bool = false):
	if !is_cooking:
		match current_slot_idx:
			0:
				slot_0 = ingredient
			1:
				slot_1 = ingredient
			2:
				slot_2 = ingredient
		shiny_ingredients[current_slot_idx] = is_shiny
		
		ing_list_updated.emit()
		current_slot_idx += 1
		
		if current_slot_idx == 3:
			check_recipe()


func check_recipe():
	var current_ingredients : Array[Ingredient] = [slot_0, slot_1, slot_2]
	var correct_ingredients := false
	
	is_cooking = true
	
	for recipe in recipe_list:
		# if recipe exists
		if recipe.ing_input == current_ingredients:
			recipe.quality = shiny_ingredients
			recipe_history.append(recipe)
			recipe_crafted.emit()
			if is_in_history(recipe):
				update_score_and_combo(recipe,false)
			else:
				update_score_and_combo(recipe,true)
			
			correct_ingredients = true
	
	
	if !correct_ingredients:
		recipe_history.append(failed_recipe)
		recipe_crafted.emit()
		update_score_and_combo(failed_recipe,false)


func on_cooking_timer_timeout():
	slot_0 = null
	slot_1 = null
	slot_2 = null
	shiny_ingredients = [false, false, false]
	current_slot_idx = 0
	ing_list_updated.emit()
	is_cooking = false
	next_recipe.emit()

func is_in_history(recipe) -> bool:
	var l = recipe_history.size()
	if recipe_history.slice(max(0,l-history_depth),max(0,l)).has(recipe):
		return true
	return false

func update_score_and_combo(recipe,new_recipe) -> void:
	var recipe_score = recipe.recipe_score
	# modify combo according to if we kept it alive or not.
	if new_recipe: # add combo step to combo
		# add score according to recipe score
		score += recipe_score * combo
		combo += combo_step * (recipe.quality.count(true) + 1)
	else: # reset combo
		combo = 1.0
		# add score according to recipe score
		score += recipe_score * combo
	


## Returns an array of full file paths to all resources in the directory at the specified path.
## These file paths can be used to load the resources with load().

static func get_all_resource_paths(directory_path: String, include_subdirectories := true, resource_type := "Resource") -> Array[String]:
	if directory_path == "":
		return []
	var directory = DirAccess.open(directory_path)
	if directory == null:
		if not Engine.is_editor_hint():
			push_error("CRITICAL: The directory %s does not exist. Returning an empty array." % directory_path)
		return []
	var file_path_list: Array[String] = []
	for file in directory.get_files():
		if file.ends_with(".remap"):
			file = file.trim_suffix(".remap")
		elif file.ends_with(".import"):
			file = file.trim_suffix(".import")
		var full_name = directory_path  + file
		if full_name.ends_with(".tres") or full_name.ends_with(".res") and ResourceLoader.exists(full_name,resource_type):
			file_path_list.append(full_name)
	if include_subdirectories:
		for subdirectory_name in directory.get_directories():
			var subdirectory_path = directory_path + "/" + subdirectory_name
			var subdirectory_file_path_list = get_all_resource_paths(subdirectory_path)
			file_path_list.append_array(subdirectory_file_path_list)
	return file_path_list
