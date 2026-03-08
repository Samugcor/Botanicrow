extends Control

@onready var animationplayer = $AnimationPlayer

func start_correct_animation():
	animationplayer.play("solve_correct")
	await animationplayer.animation_finished
	
func start_incorrect_animation():
	print("start incorrect animation")
	animationplayer.play("solve_incorrect")
	await animationplayer.animation_finished
