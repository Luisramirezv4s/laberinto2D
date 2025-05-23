extends Node

# --------------------
#   SEÑALES PÚBLICAS
# --------------------
signal lives_changed(new_lives: int)
signal level_started(level: int)

# --------------------------------
#   ESTADO INTERNO (vidas y nivel)
# --------------------------------
var lives: int = 3
var level: int = 1

# -----------------------
#   MÉTODOS PÚBLICOS
# -----------------------

func start_level() -> void:
	# Si empezamos desde nivel 1 aseguramos 3 vidas
	if level == 1:
		lives = 3
		emit_signal("lives_changed", lives)
	emit_signal("level_started", level)

func lose_life() -> void:
	# Restamos una vida, la clamp entre 0 y 3,
	# emitimos la señal y comprobamos game over.
	lives = clamp(lives - 1, 0, 3)
	emit_signal("lives_changed", lives)
	if lives == 0:
		_game_over()

func next_level() -> void:
	level += 1
	start_level()

# -----------------------
#   LÓGICA PRIVADA
# -----------------------

func _game_over() -> void:
	# 1) Recarga la escena actual
	get_tree().reload_current_scene()
	
	# 2) Reset interno (autoloader persiste tras reload)
	level = 1
	lives = 3
	emit_signal("lives_changed", lives)
	# No es necesario llamar start_level() aquí,
	# porque en el ready() de LevelScene vuelves a invocarlo.
