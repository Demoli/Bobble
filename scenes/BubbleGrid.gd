extends Node2D

onready var bubble : PackedScene = load("res://scenes/Bubble.tscn")

var bubble_size = 50

var grid = [
	['blue', 'blue','blue'],
	['blue','red','green',],
	['blue','red','green'],
]

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	draw_grid()

func draw_grid():
	for row_index in range(grid.size()):
		var row = grid[row_index]
		var row_odd = row_index % 2
		for col_index in range(row.size()):
			var col = grid[row_index][col_index]
			var new_bubble = bubble.instance()
			var row_y = bubble_size * (row_index + 1)
			var col_x = bubble_size * (col_index + 1)
			
			new_bubble.position = Vector2(col_x, row_y)
			if row_odd:
				 new_bubble.position.x += 25
			add_child(new_bubble)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
