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
			pass
		if is_body_bubble(collision.collider):
			is_active_bubble = false
			var target = collision.collider
			var dir = stepify(rad2deg(target.global_position.angle_to_point(collision.position)), 45)
			
			var target_row = target.grid_row
			var target_col = target.grid_col
			var row = target_row
			var col = target_col
			
			if dir >= 45 and dir <= 90:
				# 45 to 90 top let
				row = target_row - 1
				col = target_col - 1
			if dir >= 90 and dir <= 135:
				# 90 to 135 - top right
				row = target_row - 1
				col = target_col + 1
			
			if dir == 145:
				# 145 right
				row = target_row
				col = target_col + 1
			
			if dir >= -135 and dir <= -90:
				# -135 to -90 = bottom right
				row = target_row + 1
				col = target_col + 1
			if dir >= -90 and dir <= -45:
				# -45 to -90 bottom left - TESTED
				row = target_row + 1
				col = target_col
			
			if dir == 0:
				# 0 left
				row = target_row
				col = target_col - 1
			
			get_node("/root/Level/BubbleGrid").add_bubble(
				row,
				col,
				color
			)
			queue_free()

func is_body_bubble(body):
	return get_tree().get_nodes_in_group("bubbles").has(body)
