extends Control

# ——————————————
#   SEÑALES DE RESULTADO
# ——————————————
signal answered_correct
signal answered_wrong

# ——————————————
#   VARIABLES EDITABLES (Inspector)
# ——————————————
@export var title_text: String
@export var function_image: Texture
@export var prompt_text: String
@export var option_a_text: String
@export var option_b_text: String
@export var correct_answer: String

# ——————————————
#   REFERENCIAS A NODOS
# ——————————————
@onready var title_label:     Label       = $DialogPanel/MarginContainer/VBox/TitleLabel
@onready var function_texrect: TextureRect = $DialogPanel/MarginContainer/VBox/FunctionImage
@onready var prompt_label:    Label       = $DialogPanel/MarginContainer/VBox/PromptLabel
@onready var option_a_btn:    Button      = $DialogPanel/MarginContainer/VBox/Options/OptionA
@onready var option_b_btn:    Button      = $DialogPanel/MarginContainer/VBox/Options/OptionB

func _ready() -> void:
	# Arrancamos ocultos
	hide()

	option_a_btn.pressed.connect(Callable(self, "_on_optionA_pressed"))
	option_b_btn.pressed.connect(Callable(self, "_on_optionB_pressed"))

# Llamar desde otro script para desplegar
func show_dialog() -> void:
	# Inicializa texto/imágenes
	title_label.text         = title_text
	function_texrect.texture = function_image
	prompt_label.text        = prompt_text
	option_a_btn.text        = option_a_text
	option_b_btn.text        = option_b_text
	
	get_tree().paused = true
	show()
	option_a_btn.grab_focus()

# ============================
#   HANDLERS DE CADA BOTÓN
# ============================
func _on_optionA_pressed() -> void:
	_process_choice(option_a_text)

func _on_optionB_pressed() -> void:
	_process_choice(option_b_text)

# ============================
#   LÓGICA COMÚN DE RESPUESTA
# ============================
func _process_choice(chosen: String) -> void:
	get_tree().paused = false
	if chosen == correct_answer:
		print("InteractionDialog: correct answer")
		emit_signal("answered_correct")
	else:
		print("InteractionDialog: incorrect answer")
		emit_signal("answered_wrong")
	hide()
