extends Control

@export var invSlotScene : PackedScene

@onready var plantDetailTexture = $PlantDetail
@onready var plantNameLabel:Label = $LineName/PlantName
@onready var observationsLabel:Label = $CrowObservations/Label
@onready var addButton = $TextureButton
@onready var brewButton = $Brew

func set_brew_button_visibility(visibility:bool):
	brewButton.visible = visibility

func set_add_button_visibility(visibility:bool):
	addButton.visible = visibility
	
func set_plant_detail(plant_data:PlantClass):
	if !plant_data:
		plantDetailTexture.texture = null
		return
		
	plantDetailTexture.texture = plant_data.detailView

func set_observations(plant_data:PlantClass):
	if !plant_data:
		observationsLabel.text = ""
		return
	observationsLabel.text = plant_data.observations
