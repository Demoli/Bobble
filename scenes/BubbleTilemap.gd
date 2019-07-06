extends TileMap

class_name BubbleTilemap

var matching_bubbles = []

func calculate_deaths(origin : Vector2):
	"""
		Calculate which bubbles are now destroyed starting from origin grid position
	"""
	var nav = AStar.new()
	var tile_id = get_cellv(origin)	
	
	var used_cells = get_used_cells()
	
	for index in range(used_cells.size()):
		var tile = used_cells[index]
		var point = Vector3(tile.x,tile.y, 0)
		
		nav.add_point(index, point, 1)

	for cell in get_used_cells_by_id(tile_id):
		var targets = [
#			Vector2(cell.x,cell.y) # 0,0
			Vector2(cell.x, cell.y -1), # 0,-1,
			Vector2(cell.x -1, cell.y), # -1,0
			Vector2(cell.x, cell.y + 1), # 0,1
			Vector2(cell.x + 1 , cell.y), # 1,0
#			Vector2(cell.x + 1 , cell.y + 1), # 1,1
#			Vector2(cell.x + 1 , cell.y -1), # 1,-1
		]

		for target in targets:
			if get_cellv(target) == tile_id:
				var cell_id = get_id_by_position(nav, Vector3(cell.x, cell.y, 0))
				var target_id = get_id_by_position(nav, Vector3(target.x, target.y, 0))
	
				nav.connect_points(cell_id, target_id)
				
	for cell in get_used_cells_by_id(tile_id):
		var origin_id = get_id_by_position(nav, Vector3(origin.x, origin.y, 0))
		var id = get_id_by_position(nav, Vector3(cell.x, cell.y, 0))
		var path = nav.get_point_path(origin_id, id)
		
		if path.size() < 3:
			continue
		
		for point in path:
			set_cell(point.x, point.y, -1)
	

func get_id_by_position(nav : AStar, position : Vector3):

	for id in nav.get_points():
		if nav.get_point_position(id) == position:
			return id