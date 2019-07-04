extends KinematicBody2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

#func _input(event):
#	if not event is InputEventMouseButton:
#		return
#
#	var angle_to = (global_position.angle_to_point(get_global_mouse_position()))
#
#	print(rad2deg(angle_to))
	
func _process(delta):
	var angle_to = (global_position.angle_to_point(get_global_mouse_position()))
	
	print(stepify(rad2deg(angle_to),45))
	
	# -180 to -90 = bottom right
	# 90 to 180 - top right
	# 0 to -90 bottom left
	# 0 to 90 top let