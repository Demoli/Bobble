extends KinematicBody2D

class_name Bubble

var red = StreamTexture.new()
var green = StreamTexture.new()
var blue = StreamTexture.new()

var colors = {
	'red':red,
	'green':green,
	'blue':blue	
}

export var color = 'blue' setget set_color
export var grid_row := 0
export var grid_col := 0

var velocity
var speed = 1000

var matching_bubbles = []

var is_active_bubble = false

onready var bubble_tileset : TileSet = load("res://scenes/tilemap/BubblesTilemap.tres")

func _init():
	red.load('res://.import/red.png-77dd0501947f935ddd6759a4ff01d885.stex')
	green.load('res://.import/green.png-c3348bd2e26365f683bbb4a29fd46daa.stex')
	blue.load('res://.import/blue.png-7e9a8a78df35b67899c89ad943d12acd.stex')

func _ready():
	set_process(false)
	add_to_group("bubbles")

func set_color(new_color):
	color = new_color
	
#	var itex = ImageTexture.new()
	var stex = colors[color]
#	itex.create_from_image(img)
	$Sprite.texture = stex
	
func fire(rotation):
	set_process(true)
	velocity = Vector2(0, -speed).rotated(rotation)
	
func _physics_process(delta):
	if not velocity: #or not is_active_bubble:
		return
	
	var collision = move_and_collide(velocity * delta)
	if collision:
		
		if collision.collider is Wall:
			velocity = velocity.bounce(collision.normal)
			return
			
		var target = collision.collider
		var grid = get_node("/root/Level/BubbleTilemap")
		grid.add_bubble_collision(position, color)

		queue_free()

func spwan_and_die(new_position, new_color):
	position = new_position
	set_collision_layer_bit(0, false)
	set_collision_mask_bit(0, false)
	set_color(new_color)
	
	var wobble = randi() % 100
	var local_speed = speed - randi() % 150
	velocity = Vector2(wobble, local_speed)