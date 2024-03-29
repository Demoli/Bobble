extends TileMap

class_name BubbleTilemap

const BUBBLE_FALL_DELAY = .02

var grid : Array
var connectable_points = []
onready var level_width = world_to_map(get_node("/root/Level/RightWall").position).x
onready var bubble = load("res://scenes/Bubble.tscn")

var vertical_offset = 0

func _ready():
	pass
#	calculate_collision_deaths(Vector2(0,0))
#	calculate_collision_deaths(Vector2(0,4))

func _process(delta):
#	calculate_unsupported_deaths()
	pass

func add_bubble_collision(global_pos, color):
	var tile_pos = world_to_map(global_pos)
	tile_pos.y -= vertical_offset
	set_cellv(tile_pos,tile_set.find_tile_by_name(color))
	calculate_collision_deaths(tile_pos)

func calculate_unsupported_deaths():
	connectable_points.clear()	
	var rect = get_used_rect()
	var height = rect.size.y + rect.position.y
	var width = rect.size.x + rect.position.x
	
	grid = []
	grid.resize(height)
	
	for row in range(height):
		var new_row = []
		new_row.resize(width)
		grid[row] = new_row
		
		for col in range(width):
			if get_cell(col,row) != -1:
				grid[row][col] = 1
	
	# Find islands of neighbour bubbles 
	createIslands(grid)
	
	for group in connectable_points:
		var has_neighbours = false
		var group_is_safe = false
		for point in group:
			
			# If the points is on an edge it's safe
			var grid_top = point - Vector2(0,1)
			var wall_top = world_to_map(get_node("/root/Level/TopWall").position)
			var is_top_edge = grid_top.y <= wall_top.y
			var is_left_edge = (point - Vector2(1,0)).x == -1
			var is_right_edge = (point + Vector2(1,0)).x == level_width
			
			if is_top_edge or is_left_edge or is_right_edge:
				group_is_safe = true
			else:
				pass

			for child_group in connectable_points:
				if child_group == group:
					continue
					
				for child_point in child_group:
					if point.distance_to(child_point) <= 1:
						has_neighbours = true
		
		if group_is_safe:
			continue
		
		if not has_neighbours:
			for point in group:
				kill_bubble(point)
				yield(get_tree().create_timer(BUBBLE_FALL_DELAY), "timeout")
				set_cellv(point, -1)

func calculate_collision_deaths(origin : Vector2):
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
		kill_bubble(point)
		yield(get_tree().create_timer(BUBBLE_FALL_DELAY), "timeout")
		set_cellv(point, -1)
		
	calculate_unsupported_deaths()

func _input(event):
	if event is InputEventMouseButton:
		print(world_to_map(get_global_mouse_position()) - world_to_map(position))
	
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
		
		connected.sort_custom(self, "sort_anticlockwise")
		
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

func kill_bubble(point: Vector2):
	var new_bubble = bubble.instance()
	get_node("/root/Level").add_child(new_bubble)
	var tile_color = get_cellv(point)
	tile_color = enums.TileColorMap[tile_color]
	new_bubble.spwan_and_die(map_to_world(point), tile_color)
	
func sort_anticlockwise(a, b):
	return (a).angle() > (b).angle()
	
func move_down():
	""" Move all tiles down 1 position """
	position.y += 16
	vertical_offset += 1