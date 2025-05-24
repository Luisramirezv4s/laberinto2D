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
@export var correct_answer: String

# ——————————————
#   REFERENCIAS A NODOS
# ——————————————
@onready var title_label:     Label       = $DialogPanel/MarginContainer/VBox/TitleLabel
@onready var function_texrect: TextureRect = $DialogPanel/MarginContainer/VBox/FunctionImage
@onready var prompt_label:    Label       = $DialogPanel/MarginContainer/VBox/PromptLabel
@onready var timer_label: Label = $DialogPanel/MarginContainer/VBox/TimeLabel
@onready var answer_input:    LineEdit      = $DialogPanel/MarginContainer/VBox/AnswerInput
@onready var submit_button:    Button      = $DialogPanel/MarginContainer/VBox/SubmitButton
@onready var countdown: Timer = $CountdownTimer

const TOTAL_TIME := 600
var remaining_time: int = TOTAL_TIME

func _ready() -> void:
	# Arrancamos ocultos
	hide()
	submit_button.pressed.connect(Callable(self, "_on_submit_pressed"))
	countdown.timeout.connect(Callable(self, "_on_countdown_timeout"))

# Llamar desde otro script para desplegar
func show_dialog() -> void:
	# Inicializa texto/imágenes
	title_label.text         = title_text
	function_texrect.texture = function_image
	prompt_label.text        = prompt_text
	#Reset del contador
	remaining_time = TOTAL_TIME
	_update_timer_label()
	answer_input.text = ""
	countdown.start()
	#Pausa el juego
	get_tree().paused = true
	show()
	answer_input.grab_focus()
	
func _on_countdown_timeout() -> void:
	remaining_time -= 1
	if remaining_time <= 0:
		countdown.stop()
		hide()
		get_tree().paused = false
		emit_signal("answered_wrong")   # tiempo agotado cuenta como fallo
		return
			
	_update_timer_label()
		
func _update_timer_label() -> void:
	# Formatea MM:SS
	var mins_f = remaining_time / 60
	var mins = int(mins_f)
	var secs = remaining_time % 60
	timer_label.text = "%02d:%02d" % [mins, secs]

# ============================
#   HANDLERS DE CADA BOTÓN
# ============================
func _on_submit_pressed() -> void:
	countdown.stop()
	hide()
	get_tree().paused = false
	
	var input_text = answer_input.text.strip_edges().to_lower()
	var expected = correct_answer.strip_edges().to_lower()
	if input_text == expected:
		emit_signal("answered_correct")
	else:
		emit_signal("answered_wrong")
