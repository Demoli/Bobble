extends RigidBody2D

var red = Image.new()
var green = Image.new()
var blue = Image.new()

var colors = {
	'red':red,
	'green':green,
	'blue':blue	
}

export var color = 'blue' setget set_color

func _init():
	red.load('res://assets/bubbles/red.png')
	green.load('res://assets/bubbles/green.png')
	blue.load('res://assets/bubbles/blue.png')

func set_color(new_color):
	color = new_color
	
	var itex = ImageTexture.new()
	var img = colors[color]
	itex.create_from_image(img)
	$Sprite.texture = itex