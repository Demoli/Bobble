extends Sprite

export var rotate_speed := 1

onready var bubble_scene : PackedScene = preload("res://scenes/Bubble.tscn")

var loaded_bubble : KinematicBody2D
var color = 'blue'
var next_color = 'green'

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

func _ready():
#	$ReloadTimer.wait_time = .1
	$ReloadTimer.start()

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
	var bubble = bubble_scene.instance()
	bubble.color = color
	bubble.is_active_bubble = true
#	bubble.mode = RigidBody2D.MODE_RIGID
	bubble.global_position = global_position
	get_node("/root").add_child(bubble)
	loaded_bubble = bubble
	
	# TODO Cycle colours using some as yet undetermined method
	color = next_color

func fire():
	if not loaded_bubble:
		return
		
	loaded_bubble.fire(rotation)
	loaded_bubble = null
	$ReloadTimer.start()
	
