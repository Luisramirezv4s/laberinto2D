extends CharacterBody2D

@export var speed: float = 600.0
@export var knockback_force: float = 600.0
@export var knockback_duration: float = 0.5

@onready var animationPlayer: AnimationPlayer = $AnimationPlayer
@onready var sprite2D: Sprite2D = $Sprite2D
@onready var knockback_timer: Timer = $KnockbackTimer

#var lives: int = 3
var is_knocked: bool = false

func _ready() -> void:
	knockback_timer.one_shot = true
	knockback_timer.wait_time = knockback_duration

func _physics_process(_delta: float) -> void:
	if is_knocked:
		move_and_slide()
		return

	var input_vec := Vector2(
		Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"),
		Input.get_action_strength("ui_down")  - Input.get_action_strength("ui_up")
	)

	if input_vec != Vector2.ZERO:
		velocity = input_vec.normalized() * speed
	else:
		velocity = Vector2.ZERO

	move_and_slide()

	# Animación
	_update_animation(input_vec)

func _update_animation(dir: Vector2) -> void:
	if dir == Vector2.ZERO:
		animationPlayer.play("idle")
	else:
		animationPlayer.play("run")
		sprite2D.flip_h = dir.x < 0

func _on_knockback_timer_timeout() -> void:
	is_knocked = false

func _apply_knockback(col: KinematicCollision2D) -> void:
	is_knocked = true
	var dir := (position - col.get_position()).normalized()
	velocity = dir * knockback_force
	knockback_timer.start()
	
	GameManager.lose_life()

func _on_HitEnemy(enemy_pos_x: float) -> void:
	# 1) Knockback local igual que antes
	is_knocked = true
	var dir := (position - Vector2(enemy_pos_x, position.y)).normalized()
	velocity = dir * knockback_force
	knockback_timer.start()

	# 2) Y aquí descontamos vida en el GameManager
	GameManager.lose_life()
