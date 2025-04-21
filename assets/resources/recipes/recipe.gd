class_name Recipe

extends Resource

@export var icon :Texture2D
@export var name: String 
@export var ing_input : Array[Ingredient]

@export var recipe_score := 100.0

var quality : Array [bool] = [false, false, false]
