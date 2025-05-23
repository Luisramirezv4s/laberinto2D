extends WindowDialog

signal answer_selected(correct: bool)

@onready var dialog_image: TextureRect     = $VBoxContainer/DialogImage
@onready var question_label: Label         = $VBoxContainer/QuestionLabel
@onready var btn1: Button                  = $VBoxContainer/HBoxContainer/OptionButton1
@onready var btn2: Button                  = $VBoxContainer/HBoxContainer/OptionButton2

var _correct_option: int = 1

func _ready() -> void:
	# Conecta los botones a sus callbacks
	btn1.pressed.connect(_on_OptionButton1_pressed)
	btn2.pressed.connect(_on_OptionButton2_pressed)

func show_dialog(image: Texture, question: String, option1: String, option2: String, correct_option: int) -> void:
	dialog_image.texture    = image
	question_label.text     = question
	btn1.text               = option1
	btn2.text               = option2
	_correct_option         = correct_option
	popup_centered()        # Muestra el diálogo

func _on_OptionButton1_pressed() -> void:
	_emit_and_close(1)

func _on_OptionButton2_pressed() -> void:
	_emit_and_close(2)

func _emit_and_close(selected: int) -> void:
	hide()
	emit_signal("answer_selected", selected == _correct_option)
