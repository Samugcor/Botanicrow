extends Resource
class_name ItemClass  

#Datos generales
@export_category("General information")
@export var id : String
@export var name : String
var ui_interaction_hint : String 
@export_multiline var description : String
@export_category("Sprites")
@export var sprite : Texture2D 
@export var selectedSprite: Texture2D
