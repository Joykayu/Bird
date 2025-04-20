extends Node

var slot_0 :Ingredient
var slot_1 :Ingredient
var slot_2 :Ingredient

var recipe_list : Array[Recipe] 
var recipe_history : Array[Recipe]
var history_depth : int = 2
var current_slot_idx := 0 

signal ing_list_updated()
signal recipe_crafted(is_new_recipe)
signal recipe_failed()

func _ready():
	var recipe_ressource_list = get_all_resource_paths("res://assets/resources/recipes/",false,"Recipe")
	for recipe_ressource in recipe_ressource_list:
		recipe_list.append(load(recipe_ressource))


func add_ingredient(ingredient: Ingredient):
	match current_slot_idx:
		0:
			slot_0 = ingredient
		1:
			slot_1 = ingredient
		2:
			slot_2 = ingredient
	
	ing_list_updated.emit()
	current_slot_idx += 1
	
	if current_slot_idx == 3:
		check_recipe()
		current_slot_idx = 0

func check_recipe():
	var current_ingredients : Array[Ingredient] = [slot_0, slot_1, slot_2]
	var correct_ingredients = false
	for recipe in recipe_list:
		if recipe.ing_input == current_ingredients:
			if is_in_history(recipe):
				recipe_history.append(recipe)
				recipe_crafted.emit(false)
			else:
				recipe_history.append(recipe)
				recipe_crafted.emit(true)
			correct_ingredients = true
			
	
	if !correct_ingredients:
		recipe_failed.emit()
	
	slot_0 = null
	slot_1 = null
	slot_2 = null
	ing_list_updated.emit()

func is_in_history(recipe) -> bool:
	var l = recipe_history.size()
	if recipe_history.slice(max(0,l-history_depth),max(0,l)).has(recipe):
		return true
	return false


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
		var full_name = directory_path + "/" + file
		if full_name.ends_with(".tres") or full_name.ends_with(".res") and ResourceLoader.exists(full_name,resource_type):
			file_path_list.append(full_name)
	if include_subdirectories:
		for subdirectory_name in directory.get_directories():
			var subdirectory_path = directory_path + "/" + subdirectory_name
			var subdirectory_file_path_list = get_all_resource_paths(subdirectory_path)
			file_path_list.append_array(subdirectory_file_path_list)
	return file_path_list
