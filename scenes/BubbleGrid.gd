extends Node2D

onready var bubble : PackedScene = load("res://scenes/Bubble.tscn")

var bubble_size = 50

var grid = [
	['blue', 'blue', 'blue', 'blue', 'blue', 'blue', 'blue'],
	[null, null, null, null, null, null, null],
	[null, null, null, null, null, null, null],
	[null, null, null, null, null, null, null],
	[null, null, null, null, null, null, null],
]

func _ready():
	draw_grid()

func add_bubble(row, col, color):
	grid[row][col] = color
	draw_grid()

func draw_grid():
	for row_index in range(grid.size()):
		var row = grid[row_index]
		var row_odd = row_index % 2 
		for col_index in range(row.size()):
			var col = grid[row_index][col_index]
			
			if col == null or col is Bubble:
				continue
				
			var new_bubble = bubble.instance()
			
			new_bubble.color = col
			var row_y = bubble_size * (row_index + 1)
			var col_x = bubble_size * (col_index + 1)
			
			new_bubble.position = Vector2(col_x, row_y)

			if row_odd:
				 new_bubble.position.x += 25

			new_bubble.position = new_bubble.position.snapped(Vector2(25,50))

			new_bubble.grid_row = row_index
			new_bubble.grid_col = col_index
			grid[row_index][col_index] = new_bubble
			
			add_child(new_bubble)

func _process(delta):
	pass