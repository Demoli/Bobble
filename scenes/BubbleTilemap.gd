extends TileMap

class_name BubbleTilemap

var grid : Array
var connectable_points = []

func _ready():
	pass
#	calculate_deaths(Vector2(0,0))
#	calculate_deaths(Vector2(0,4))

func calculate_deaths(origin : Vector2):
	"""
		Calculate which bubbles are now destroyed starting from origin grid position
	"""
	connectable_points.clear()	
	var rect = get_used_rect()
	var height = rect.size.y + rect.position.y
	var width = rect.size.x + rect.position.x
	var tile_id = get_cellv(origin)	
	
	grid = []
	grid.resize(height)
	
	for row in range(height):
		var new_row = []
		new_row.resize(width)
		grid[row] = new_row
		
		for col in range(width):
			if get_cell(col,row) == tile_id:
				grid[row][col] = 1
	
	# Find islands of neighbour bubbles 
	createIslands(grid)

	# find the group containing the fired bubble nd kill them all
	var group_to_clear = []
	for group in connectable_points:
		if group.has(origin) and group.size() >= 3:
			group_to_clear = group
			break;
	
	for point in group_to_clear:
		set_cellv(point, -1)

func _input(event):
	if event is InputEventMouseButton:
		print(world_to_map(get_global_mouse_position()))


func get_id_by_position(nav : AStar, position : Vector3):

	for id in nav.get_points():
		if nav.get_point_position(id) == position:
			return id
	
func append_if(queue, x, y):
	"""Append to the queue only if in bounds of the grid and the cell value is 1."""
	if 0 <= grid.size() and x < grid.size() and 0 <= x and 0 <= y and 0 <= grid[x].size() and y < grid[x].size():
		if grid[x][y] == 1:
			queue.append(Vector2(x,y))


func mark_neighbors(row, col):
	"""Mark all the cells in the current island with value = 2. Breadth-first search."""
	
	var queue = []
	var connected = []
	
	queue.append(Vector2(row, col))
	while queue.size() > 0:
		var element = queue.pop_back()
		var x = element.x
		var y = element.y
		grid[x][y] = 2
		if not connected.has(Vector2(element.y,element.x)):
			connected.append(Vector2(element.y,element.x))
		
		append_if(queue, x - 1, y)
		append_if(queue, x, y - 1)
		append_if(queue, x + 1, y)
		append_if(queue, x, y + 1)
		append_if(queue, x + 1, y + 1)
		append_if(queue, x + 1, y - 1)
		append_if(queue, x - 1, y - 1)
		append_if(queue, x - 1, y + 1)
	
	connectable_points.append(connected)

func createIslands(new_grid):
	grid = new_grid
	
	if not grid or grid.size() == 0 or grid[0].size() == 0:
		return 0

	var row_length = grid.size()
	var col_length = grid[0].size()
	
	for row in range(row_length):
		for col in range(col_length):
			if grid[row][col] == 1:
				mark_neighbors(row, col)