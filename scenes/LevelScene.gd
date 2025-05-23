extends Node2D   # Asegúrate de que este sea el tipo correcto de tu nodo raíz

func _ready() -> void:
	# 1) Localiza el LifeHUD en tu escena
	var hud = $CanvasLayer/LifeHUD
	#GameManager.connect("lives_changed", hud, "set_lives")
	GameManager.lives_changed.connect(hud.set_lives)

	hud.set_lives(GameManager.lives)
	GameManager.start_level()
