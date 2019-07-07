extends Node

enum TileColors {
	BLUE,
	GREEN,
	RED
}

var TileColorMap = {
	TileColors.BLUE:'blue',
	TileColors.GREEN:'green',
	TileColors.RED:'red',
}

func _ready():
	print(TileColorMap)