extends CharacterBody2D

@export var speed: float = 300.0
@export var gravity: float = 500.0

# Datos únicos de este enemigo para el diálogo
@export var dialog_image: Texture
@export var question_text: String
@export var option1_text: String
@export var option2_text: String
@export var correct_option: int = 1   # 1 ó 2 según cuál sea la respuesta correcta

@onready var wall_raycast: RayCast2D = $WallRaycast
@onready var edge_raycast: RayCast2D = $EdgeRaycast

enum Direction { LEFT = -1, RIGHT = 1 }
var direction: int = Direction.LEFT

# Preload de tu escena genérica de diálogo
@onready var _dialog_scene := preload("res://scenes/UI/ProblemDialog.tscn")
var _dialog    # instancia que crearemos
var _player_ref      # referencia al jugador que choca


func _ready() -> void:
	wall_raycast.enabled = true
	edge_raycast.enabled = true
	
	# 1) Instancio y oculto el diálogo
	_dialog = _dialog_scene.instantiate()
	get_tree().get_root().add_child(_dialog)   # lo añado al root, así aparece sobre todo
	_dialog.hide()

	# 2) Conecto su señal 'answer_selected(correct: bool)'
	_dialog.connect("answer_selected", self, "_on_Dialog_answer_selected")

func _physics_process(_delta: float) -> void:
	velocity.y += gravity * _delta
	velocity.x = direction * speed

	if wall_raycast.is_colliding() or not edge_raycast.is_colliding():
		_flip_direction()

	move_and_slide()

func _flip_direction() -> void:
	direction = -direction
	wall_raycast.position.x = abs(wall_raycast.position.x) * direction
	edge_raycast.position.x = abs(edge_raycast.position.x) * direction
	wall_raycast.target_position.x = abs(wall_raycast.target_position.x) * direction
	edge_raycast.target_position.x = abs(edge_raycast.target_position.x) * direction
	if has_node("Sprite2D"):
		$Sprite2D.flip_h = direction < 0


func _on_area_2d_body_entered(body: Node2D) -> void:
	if not body.has_method("_on_HitEnemy"):
		return
		
 # Guardamos al jugador para usarlo luego
	_player_ref = body

	# Mostramos el diálogo con los datos de este enemigo
	_dialog.show_dialog(
		dialog_image,
		question_text,
		option1_text,
		option2_text,
		correct_option
	)
		
func _on_Dialog_answer_selected(correct: bool) -> void:
	_dialog.hide()

	if correct:
		# Si responde bien, el enemigo muere
		queue_free()
	else:
		# Si responde mal, knockback + perder vida
		if _player_ref.has_method("_on_HitEnemy"):
			_player_ref._on_HitEnemy(position.x)
