extends Sprite

export var rotate_speed := 1

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

func _ready():
	pass # Replace with function body.

func _process(delta):
	if Input.is_action_pressed("rotate_left"):
		rotation -= rotate_speed * delta
	if Input.is_action_pressed("rotate_right"):
		rotation += rotate_speed * delta

	rotation_degrees = clamp(rotation_degrees, -90, 90)