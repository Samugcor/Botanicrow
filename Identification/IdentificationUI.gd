extends CanvasLayer

@onready var plantDetailTexture = $PlantDetail
var currentPlant

func _ready() -> void:
	GameplayState.push(self)
	
func _on_exit_pressed() -> void:
	GameplayState.pop()
	self.queue_free()
