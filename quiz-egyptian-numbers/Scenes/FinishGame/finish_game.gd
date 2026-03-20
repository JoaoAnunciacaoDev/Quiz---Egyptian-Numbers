extends Control
class_name FinishGame

const MAIN_MENU_PATH : String = "res://Scenes/MainMenu/main_menu.tscn"

@export var subtitle : Label

var correct_answers : int = 0
var questions_amount : int = 0

func _ready() -> void:
	Transition.play_anim("fade_out")
	subtitle.text = "Você acertou %d de %d questões!!!" % [correct_answers, questions_amount]

func _on_back_pressed() -> void:
	Transition.play_anim("fade_in")
	await Transition.transition_finished
	queue_free()
	get_tree().change_scene_to_file(MAIN_MENU_PATH)
