extends TileMap

class_name BubbleTilemap

var matching_bubbles = []

func calculate_deaths(origin : Vector2):
	"""
		Calculate which bubbles are now destroyed starting from origin grid position
	"""
	
	
	var rect = get_used_rect()
	var tile_id = get_cellv(origin)	
	var count = 0
	var grid = []
	for row_index in range(rect.size.x + rect.position.x):
		var row = []
		for col_index in range(rect.size.y):
			if get_cell(row_index, col_index) == tile_id:
				row.append(1)
				count += 1
			else:
				row.append(0)
#			row.append(Vector2(row_index, col_index))
		grid.append(row)
			
	numIslands(grid, tile_id)
	
	for row in range(grid.size()):
		for col in range(grid[row].size()):
			if grid[row][col] == 2:
				set_cell(row,col,-1)
	
	pass
#
#	for index in range(used_cells.size()):
#		var tile = used_cells[index]
#		var point = Vector3(tile.x,tile.y, 0)
#
#		nav.add_point(index, point, 1)
#
#	for cell in get_used_cells_by_id(tile_id):
#		var targets = [
##			Vector2(cell.x,cell.y) # 0,0
#			Vector2(cell.x, cell.y -1), # 0,-1,
#			Vector2(cell.x -1, cell.y), # -1,0
#			Vector2(cell.x, cell.y + 1), # 0,1
#			Vector2(cell.x + 1 , cell.y), # 1,0
##			Vector2(cell.x + 1 , cell.y + 1), # 1,1
##			Vector2(cell.x + 1 , cell.y -1), # 1,-1
#		]
#
#		for target in targets:
#			if get_cellv(target) == tile_id:
#				var cell_id = get_id_by_position(nav, Vector3(cell.x, cell.y, 0))
#				var target_id = get_id_by_position(nav, Vector3(target.x, target.y, 0))
#
#				nav.connect_points(cell_id, target_id)
#
#	for cell in get_used_cells_by_id(tile_id):
#		var origin_id = get_id_by_position(nav, Vector3(origin.x, origin.y, 0))
#		var id = get_id_by_position(nav, Vector3(cell.x, cell.y, 0))
#		var path = nav.get_point_path(origin_id, id)
#
#		if path.size() < 3:
#			continue
#
#		for point in path:
#			set_cell(point.x, point.y, -1)
	

func get_id_by_position(nav : AStar, position : Vector3):

	for id in nav.get_points():
		if nav.get_point_position(id) == position:
			return id
			
####################################
	
var grid

func append_if(queue, x, y, search):
	"""Append to the queue only if in bounds of the grid and the cell value is 1."""
	if 0 <= grid.size() and x < grid.size() and 0 <= grid[x].size() and y < grid[x].size():
		if grid[x][y] == 1:
			queue.append(Vector2(x,y))

func mark_neighbors(row, col, search):
	"""Mark all the cells in the current island with value = 2. Breadth-first search."""
	
	var queue = []
	
	queue.append(Vector2(row, col))
	while queue.size() > 0:
		var element = queue.pop_back()
		var x = element.x
		var y = element.y
		grid[x][y] = 2
		
		append_if(queue, x - 1, y, search)
		append_if(queue, x, y - 1, search)
		append_if(queue, x + 1, y, search)
		append_if(queue, x, y + 1, search)

func numIslands(new_grid, tile_id):
	grid = new_grid
	
	if not grid or grid.size() == 0 or grid[0].size() == 0:
		return 0

	var row_length = grid.size()
	var col_length = grid[0].size()
	
	for row in range(row_length):
		for col in range(col_length):
			if grid[row][col] == 1:
				mark_neighbors(row, col, tile_id)