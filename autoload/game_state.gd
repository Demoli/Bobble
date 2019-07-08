extends Node

var roof_timer = Timer.new()
onready var roof = get_node("/root/Level/TopWall")
onready var bubble_tiles : BubbleTilemap = get_node("/root/Level/BubbleTilemap")

func _ready():
	randomize()
	
	roof_timer.wait_time = 1
	roof_timer.connect("timeout", self, "lower_roof")
	add_child(roof_timer)
	roof_timer.start()
	
#func _process(delta):
#	print(roof_timer.time_left)
	
func lower_roof():
	roof.position.y += 16
	bubble_tiles.move_down()
	
func game_over():
	roof_timer.stop()
	get_tree().change_scene("res://scenes/GameOver.tscn")