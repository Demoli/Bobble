extends Sprite

export var rotate_speed := 1

onready var bubble_scene : PackedScene = preload("res://scenes/Bubble.tscn")

var loaded_bubble : RigidBody2D
var color = 'blue'
var next_color = 'red'

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

func _ready():
	load_bubble()

func _process(delta):
	if Input.is_action_pressed("rotate_left"):
		rotation -= rotate_speed * delta
	if Input.is_action_pressed("rotate_right"):
		rotation += rotate_speed * delta
	if Input.is_action_pressed("fire"):
		fire()

	rotation_degrees = clamp(rotation_degrees, -90, 90)
	
func load_bubble():
	$ReloadTimer.stop()
	var bubble =bubble_scene.instance()
	bubble.color = color
	bubble.mode = RigidBody2D.MODE_RIGID
	add_child(bubble)
	loaded_bubble = bubble

func fire():
	var bubble_vector = Vector2(0,-200).rotated(rotation) * 5
	loaded_bubble.set_linear_velocity(bubble_vector)
	$ReloadTimer.start()