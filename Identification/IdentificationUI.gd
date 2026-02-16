extends CanvasLayer

@onready var plantDetailTexture = $PlantDetail
@onready var plantSelectionInventory = $Inventory
@onready var plantNameLabel:Label = $LineName/PlantName
@onready var observationsLabel:Label = $CrowObservations/Label

var plantaSelecionada: PlantClass

func _ready() -> void:
	GameplayState.push(self)
	plantSelectionInventory.slot_selected.connect(_on_slot_selected)
	
func _on_exit_pressed() -> void:
	GameplayState.pop()
	plantSelectionInventory.slot_selected.disconnect(_on_slot_selected)
	self.queue_free()

func _on_slot_selected(slot):
	if GameplayState.current() != self:
		return
		
	if slot.item:
		plantaSelecionada = slot.item
		plantDetailTexture.texture = plantaSelecionada.detailView
		#Preguntar al GameState si se conoce la planta
		plantNameLabel.text = plantaSelecionada.name
		observationsLabel.text = plantaSelecionada.observations
		
	else:
		plantDetailTexture.texture = null
