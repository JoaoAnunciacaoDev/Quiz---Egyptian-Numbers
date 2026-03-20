extends Control
class_name QuizManager

const FINISH_GAME : String = "res://Scenes/FinishGame/finish_game.tscn"

@export var quizzes : Array[QuizResource] 

@export var title : Label
@export var texture : TextureRect
@export var buttons : Array[Button]

var current_quiz_index : int = 0
var hit_counter : int = 0

func _ready() -> void:
	if quizzes.size() > 0:
		load_quiz(current_quiz_index)

func load_quiz(index : int) -> void:
	var current_quiz : QuizResource = quizzes[index]
	
	title.text = "Questão " + str(current_quiz_index + 1)
	texture.texture = current_quiz.number_image
	
	var letters = ["A", "B", "C", "D"]
	
	for i in range(buttons.size()):
		var btn : Button = buttons[i]
		btn.text = letters[i] + ". " + str(current_quiz.numbers_answers[i])
		
		if btn.pressed.is_connected(_on_answer_selected):
			btn.focus_mode = Control.FOCUS_NONE
			btn.release_focus()
			
			var callable = Callable(self, "_on_answer_selected")
			for connection in btn.pressed.get_connections():
				btn.pressed.disconnect(connection.callable)
		
		btn.pressed.connect(_on_answer_selected.bind(current_quiz.numbers_answers[i], btn))
	
	for button in buttons:
		button.disabled = false
	
	Transition.play_anim("fade_out")

func _on_answer_selected(selected_number: int, clicked_button : Button) -> void:
	for button in buttons:
		button.disabled = true
	
	var correct_answer = quizzes[current_quiz_index].correct_answer
	
	if selected_number == correct_answer:
		print("Você acertou!")
		hit_counter += 1
	else:
		print("Você errou!")
	
	var tween = create_tween()
	tween.tween_property(clicked_button, "scale", Vector2(0.9, 0.9), 0.1)
	tween.tween_property(clicked_button, "scale", Vector2(1.0, 1.0), 0.1)
	await tween.finished
	
	Transition.play_anim("fade_in")
	await Transition.transition_finished
	
	next_question()

func next_question() -> void:
	current_quiz_index += 1
	
	if current_quiz_index < quizzes.size():
		load_quiz(current_quiz_index)
	else:
		finish_game()

func finish_game() -> void:
	var next_scene = load(FINISH_GAME).instantiate()
	next_scene.correct_answers = hit_counter
	next_scene.questions_amount = quizzes.size()

	get_tree().root.add_child(next_scene)
	queue_free()
