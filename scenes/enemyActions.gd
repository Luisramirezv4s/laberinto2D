extends CharacterBody2D

@export var speed: float = 300.0
@export var gravity: float = 500.0
@onready var wall_raycast: RayCast2D = $WallRaycast
@onready var edge_raycast: RayCast2D = $EdgeRaycast


# 1) El array de preguntas para este enemigo
const QUIZ_DATA := [
	{ "image_path":"res://assets/questions/preg1.png", "answer":"42" },
	{ "image_path":"res://assets/questions/preg2.png", "answer":"X=3" },
	{ "image_path":"res://assets/questions/preg3.png", "answer":"π/2" },
	{ "image_path":"res://assets/questions/preg4.png", "answer":"e^2" }
]
enum Direction { LEFT = -1, RIGHT = 1 }
var direction: int = Direction.LEFT

# Guardaremos aquí la referencia al Player para el knockback
var _pending_player : CharacterBody2D = null  

func _ready() -> void:
	wall_raycast.enabled = true
	edge_raycast.enabled = true


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

# Este método lo vinculas a la señal `body_entered` de tu Area2D
func _on_area_2d_body_entered(body: Node2D) -> void:
	if not body.is_in_group("Player"):
		return
		
	# 1) Guarda al player 
	_pending_player = body as CharacterBody2D

	# 2) Buscamos el diálogo en la escena actual
	var dialog = get_tree().get_current_scene().get_node("CanvasLayer/QuestionDialog")
	
	# Preparamos la Callable
	var cb = Callable(self, "_on_quiz_completed")
	var sig = dialog.quiz_completed
	
	# 3) Aseguramos que no haya conexiones previas
	if sig.is_connected(cb):
		sig.disconnect(cb)
	
	# 4) Conectamos en modo one-shot
	sig.connect(cb, CONNECT_ONE_SHOT)

	# 5) Mostramos el quiz
	dialog.show_quiz(QUIZ_DATA)

func _on_quiz_completed(success: bool) -> void:
	if success:
		# Jugador acertó: eliminamos al enemigo
		queue_free()
	else:
		# Jugador falló: aplicamos knockback + Perder vida
		if _pending_player and _pending_player.has_method("_on_HitEnemy"):
			_pending_player._on_HitEnemy(position.x)
	# limpiamos referencia
	_pending_player = null
