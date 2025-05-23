extends Window
signal quiz_completed(success: bool)

@export var questions: Array[Dictionary] = []  
# Cada elemento: { "image_path": "res://...", "answer": "42" }

var _current := 0

func _ready() -> void:
	$SubmitButton.pressed.connect(_on_submit)

func show_quiz(qs: Array[Dictionary]) -> void:
	questions = qs
	_current = 0
	_load_question()

func _load_question() -> void:
	var q = questions[_current]
	$QuestionImage.texture = load(q.image_path)
	$AnswerInput.text = ""
	popup_centered()  # muestra el diálogo

func _on_submit() -> void:
	var q = questions[_current]
	if $AnswerInput.text.strip_edges() == q.answer:
		_current += 1
		if _current < questions.size():
			_load_question()
		else:
			hide()
			emit_signal("quiz_completed", true)
	else:
		hide()
		emit_signal("quiz_completed", false)
