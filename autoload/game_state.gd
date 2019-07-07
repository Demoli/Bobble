extends Node

var roof_timer = Timer.new()
onready var roof = get_node("/root/Level/TopWall")
onready var bubble_tiles = get_node("/root/Level/BubbleTilemap")

func _ready():
	randomize()
	
	roof_timer.wait_time = 5
	roof_timer.connect("timeout", self, "lower_roof")
	add_child(roof_timer)
#	roof_timer.start()
	
#func _process(delta):
#	print(roof_timer.time_left)
	
func lower_roof():
	roof.position.y += 16
	bubble_tiles.position.y += 16