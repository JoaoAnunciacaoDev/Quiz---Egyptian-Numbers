extends Control

const GAME_PATH : String = "res://Scenes/Game/quiz_scene.tscn"

@export var play_button : Button

func _ready() -> void:
	Transition.play_anim("fade_out")

func _on_play_pressed() -> void:
	play_button.disabled = true
	
	Transition.play_anim("fade_in")
	await Transition.transition_finished
	get_tree().change_scene_to_file(GAME_PATH)
