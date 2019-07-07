extends KinematicBody2D

class_name Bubble

var red = Image.new()
var green = Image.new()
var blue = Image.new()

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
	red.load('res://assets/bubbles/red.png')
	green.load('res://assets/bubbles/green.png')
	blue.load('res://assets/bubbles/blue.png')

func _ready():
	set_process(false)
	add_to_group("bubbles")

func set_color(new_color):
	color = new_color
	
	var itex = ImageTexture.new()
	var img = colors[color]
	itex.create_from_image(img)
	$Sprite.texture = itex
	
func fire(rotation):
	set_process(true)
	velocity = Vector2(0, -speed).rotated(rotation)
	
func _physics_process(delta):
	if not velocity or not is_active_bubble:
		return
	
	var collision = move_and_collide(velocity * delta)
	if collision:
		
		if collision.collider is Wall:
			velocity = velocity.bounce(collision.normal)
			return
			
		var target = collision.collider
		var grid : BubbleTilemap = get_node("/root/Level/BubbleTilemap")
		var tile_pos = grid.world_to_map(position)

		queue_free()
		
		grid.set_cellv(tile_pos,bubble_tileset.find_tile_by_name(color))
		
		grid.calculate_collision_deaths(tile_pos)
		