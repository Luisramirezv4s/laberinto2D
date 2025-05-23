extends Control

# Paths a tus nodos TextureRect
@onready var hearts := [
	$Heart1,
	$Heart2,
	$Heart3
]

# Texturas
@export var tex_full: Texture
@export var tex_empty: Texture

func set_lives(life_count: int) -> void:
	# life_count va de 0 a hearts.size()
	for i in hearts.size():
		if i < life_count:
			hearts[i].texture = tex_full
		else:
			hearts[i].texture = tex_empty
