extends Node
class_name SceneTransitions

@onready var color_rect: ColorRect = $ColorRect
@onready var shader_mat: ShaderMaterial = color_rect.material

func _ready() -> void:
	color_rect.visible = false
#	await start_transition(TransitionType.FADE_IN,2.0)
#	await start_transition(TransitionType.FADE_OUT,2.0)

enum TransitionType {
	FADE_IN,
	FADE_OUT,
	CRICLE_IN,
	CIRCLE_OUT
}
func add_to_gaplay_state():
	GameplayState.push(self)

func remove_from_gaplay_state():
	GameplayState.pop()
	
func play_start_transition(type: TransitionType, duration: float = 0.5) -> void:
	match type:
		TransitionType.FADE_IN:
			await _fade_in(duration)
		TransitionType.CRICLE_IN:
			_circle_transition(duration)
			
		
func play_end_transition(type: TransitionType, duration: float = 0.5) -> void:
	match type:
		TransitionType.FADE_OUT:
			await _fade_out(duration)
		TransitionType.CRICLE_IN:
			_circle_transition(duration)
	
	
func _fade_in(duration: float):
	#shader_mat.set_shader_parameter("Progress",1)
	color_rect.visible = true
	color_rect.color.a = 0
	# Fade in
	var t = get_tree().create_tween()
	t.tween_property(color_rect, "color:a",1, duration)
	await t.finished

func _fade_out(duration:float):
	# Fade out
	color_rect.color.a = 1
	var t = get_tree().create_tween()
	t.tween_property(color_rect, "color:a", 0, duration)
	await t.finished
	color_rect.visible = false

func _circle_transition(duration: float = 0.5) -> void:
	color_rect.visible = true
	shader_mat.set_shader_parameter("radius", 0.0)

	# Expand circle
	var t = get_tree().create_tween()
	t.tween_property(shader_mat, "shader_parameter/radius", 1.0, duration)
	await t.finished

	# Shrink circle
	t = get_tree().create_tween()
	t.tween_property(shader_mat, "shader_parameter/radius", 0.0, duration)
	await t.finished

	color_rect.visible = false
