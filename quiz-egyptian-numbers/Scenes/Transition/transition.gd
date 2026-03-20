extends CanvasLayer
class_name TransitionScene

signal transition_finished

@export var anim_player : AnimationPlayer

func play_anim(anim_name : String) -> void:
	anim_player.play(anim_name)

func _on_animation_player_animation_finished(_anim_name: StringName) -> void:
	transition_finished.emit()
