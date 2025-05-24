extends CharacterBody2D

@export var speed: float = 300.0
@export var gravity: float = 500.0
@onready var wall_raycast: RayCast2D = $WallRaycast
@onready var edge_raycast: RayCast2D = $EdgeRaycast
@onready var dialog: Control = get_tree().get_current_scene().get_node("CanvasLayer/InteractionDialog")

enum Direction { LEFT = -1, RIGHT = 1 }
var direction: int = Direction.LEFT

# Guardaremos aquí la referencia al Player para el knockback
var last_player: Node = null

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
	if not body.has_method("_on_HitEnemy"):
		return
		
		# Guardamos referencia al player que colisionó
	last_player = body
	# Mostramos el diálogo
	dialog.show_dialog()
	# Conecta el signal al Callable de GDScript
	dialog.answered_correct.connect( Callable(self, "_on_dialog_correct"), CONNECT_ONE_SHOT )
	dialog.answered_wrong.connect(   Callable(self, "_on_dialog_wrong"),   CONNECT_ONE_SHOT )
