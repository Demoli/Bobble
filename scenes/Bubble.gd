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

var matching_bubbles = []

var is_active_bubble = false

func _init():
	red.load('res://assets/bubbles/red.png')
	green.load('res://assets/bubbles/green.png')
	blue.load('res://assets/bubbles/blue.png')

func _ready():
	add_to_group("bubbles")

func set_color(new_color):
	color = new_color
	
	var itex = ImageTexture.new()
	var img = colors[color]
	itex.create_from_image(img)
	$Sprite.texture = itex
	
func _process(delta):
	handle_bubble_collision()
	
func handle_bubble_collision():
	
	if not is_active_bubble:
		return
	
	matching_bubbles.clear()
	
	var bodies = get_colliding_bodies()
	if bodies.size() == 0:
		return
	
	for body in bodies:
		if not is_body_bubble(body):
			return
	
	# Once it's in place max it immovable
	linear_velocity = Vector2(0,0)
	mass = 65535
	is_active_bubble = false
	
	matching_bubbles.append(self)
	handle_deaths(bodies)
	
	if matching_bubbles.size() >= 3:
		for bubble in matching_bubbles:
			bubble.queue_free()
	
func handle_deaths(bodies):
	for body in bodies:
		if body.color == color and not matching_bubbles.has(body):
			matching_bubbles.append(body)
			handle_deaths(body.get_colliding_bodies())
			
func is_body_bubble(body):
	return get_tree().get_nodes_in_group("bubbles").has(body)