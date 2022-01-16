extends Node2D

export(int) var width = 100
export(int) var height = 100
export(int) var cell_size = 16
export(int) var spawn_area_size = 8
export(float) var water_clamp = 0.1
export(float) var fences_clamp = 0.1
export(float) var objects_clamp = 0.2
export(NodePath) var container_path = null

var TreeObj = preload("res://src/Objects/Tree.tscn")
var GrassObj = preload("res://src/Objects/Grass.tscn")
var ShroomObj = preload("res://src/Objects/Shroom.tscn")
var StoneObj = preload("res://src/Objects/SmallStone.tscn")
var BigStoneObj = preload("res://src/Objects/BigStone.tscn")
var FireplaceObj = preload("res://src/Objects/Fireplace.tscn")
var ChestObj = preload("res://src/Objects/Chest.tscn")

var spawn_area = Rect2(Vector2.ZERO, Vector2.ZERO)
var open_simplex_noise = null
var container = null

onready var water_tile = $ForestWaterTileMap.tile_set.find_tile_by_name("water_auto")
onready var fence_tile = $ForestLandTileMap.tile_set.find_tile_by_name("fences_auto")

func _ready():
	container = get_node(container_path)

	open_simplex_noise = OpenSimplexNoise.new()
	open_simplex_noise.seed = randi()
	
	open_simplex_noise.octaves = 4
	open_simplex_noise.period = 15
	open_simplex_noise.lacunarity = 1.5
	open_simplex_noise.persistence = 1

	spawn_area = Rect2(
		Vector2(-spawn_area_size / 2, -spawn_area_size / 2),
		Vector2(spawn_area_size, spawn_area_size)
	)

	_generate_world()

func _generate_world():
	for x in width:
		for y in height:
			var cell_xy = Vector2(x - width / 2, y - height / 2)
			var noise_sample = open_simplex_noise.get_noise_2d(float(x), float(y))
			var env_object = _get_object(noise_sample, cell_xy)

			if _has_water(noise_sample, cell_xy):
				$ForestWaterTileMap.set_cellv(
					cell_xy,
					water_tile
				)

			if _has_fence(noise_sample, cell_xy):
				$ForestLandTileMap.set_cellv(
					cell_xy,
					fence_tile
				)

			if env_object:
				_place_object(env_object, noise_sample, cell_xy)

	$ForestLandTileMap.update_bitmask_region()
	$ForestWaterTileMap.update_bitmask_region()

func _has_water(noise_sample, cell_xy):
	if spawn_area.has_point(cell_xy):
		return false

	if noise_sample < water_clamp:
		return true

func _has_fence(noise_sample, cell_xy):
	var tm = $ForestLandTileMap
	var tmw = $ForestWaterTileMap

	if noise_sample > water_clamp and noise_sample < 0.15:
		var diag1 = tm.get_cell(cell_xy.x - 1, cell_xy.y - 1) == fence_tile
		var diag2 = tm.get_cell(cell_xy.x + 1, cell_xy.y + 1) == fence_tile
		var diag3 = tm.get_cell(cell_xy.x - 1, cell_xy.y + 1) == fence_tile
		var diag4 = tm.get_cell(cell_xy.x + 1, cell_xy.y - 1) == fence_tile
		var diagonals = [diag1, diag2, diag3, diag4]
		
		var water1 = tmw.get_cell(cell_xy.x - 1, cell_xy.y - 1) == water_tile
		var water2 = tmw.get_cell(cell_xy.x - 1, cell_xy.y) == water_tile
		var water3 = tmw.get_cell(cell_xy.x - 1, cell_xy.y + 1) == water_tile
		var water4 = tmw.get_cell(cell_xy.x + 1, cell_xy.y - 1) == water_tile
		var water5 = tmw.get_cell(cell_xy.x + 1, cell_xy.y) == water_tile
		var water6 = tmw.get_cell(cell_xy.x + 1, cell_xy.y + 1) == water_tile
		var water7 = tmw.get_cell(cell_xy.x, cell_xy.y - 1) == water_tile
		var water8 = tmw.get_cell(cell_xy.x, cell_xy.y + 1) == water_tile
		var water = [water1, water2, water3, water4, water5, water6, water7, water8]

		if water.count(true) == 0:
			return false
		if diagonals.count(true) > 1:
			return false

		return true

func _get_object(noise_sample, cell_xy):
	if noise_sample > objects_clamp or spawn_area.has_point(cell_xy):
		return $Distribution.roll()

	return null
	
func _place_object(env_object, noise_sample, cell_xy):
	var type = env_object.type;
	var types = $Distribution.TYPES
	var obj_position = (cell_xy * cell_size) + Vector2(
		cell_size / 2,
		cell_size / 2
	)
	var obj = null

	match type:
		types.STUMP:
			$ForestObjectsTileMap.set_cellv(
				cell_xy,
				4 + env_object.variance
			)
		types.GRASS:
			obj = GrassObj.instance()
		types.SHROOM:
			obj = ShroomObj.instance()
		types.TREE:
			obj = TreeObj.instance()
		types.STONE:
			obj = StoneObj.instance()
		types.BIG_STONE:
			obj = BigStoneObj.instance()
		types.FIREPLACE:
			obj = FireplaceObj.instance()
		types.CHEST:
			obj = ChestObj.instance()

	if obj:
		obj.position = obj_position
		obj.set('variant', env_object.variance)

		container.add_child(obj)
