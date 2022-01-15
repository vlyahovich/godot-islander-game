extends Node2D

export(int) var width = 100
export(int) var height = 100
export(int) var cell_size = 16
export(int) var spawn_area_size = 8
export(float) var water_clamp = 0.1
export(float) var objects_clamp = 0.16
export(NodePath) var container_path = null

var TreeObj = preload("res://src/Objects/Tree.tscn")
var GrassObj = preload("res://src/Objects/Grass.tscn")
var ShroomObj = preload("res://src/Objects/Shroom.tscn")

var spawn_area = Rect2(Vector2.ZERO, Vector2.ZERO)
var open_simplex_noise = null
var container = null

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
	var water_tile = $ForestWaterTileMap.tile_set.find_tile_by_name("water_auto")

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

			if env_object:
				_place_object(env_object, noise_sample, cell_xy)

	$ForestWaterTileMap.update_bitmask_region()

func _has_water(noise_sample, cell_xy):
	if spawn_area.has_point(cell_xy):
		return false

	if noise_sample < water_clamp:
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

	if obj:
		obj.position = obj_position
		obj.variant = env_object.variance

		container.add_child(obj)

#func _place_objects(noise_sample, cell_xy):
#	if noise_sample > objects_clamp:
#		var obj_position = (cell_xy * cell_size) + Vector2(
#			cell_size / 2,
#			cell_size / 2
#		)
#		var grass = _get_grass()
#		var shroom = _get_shroom()
#		var tree = _get_tree()
#
#		if grass != -1:
#			var obj = GrassObj.instance()
#
#			obj.position = obj_position
#			obj.variant = grass
#
#			container.add_child(obj)
#		elif shroom != -1:
#			var obj = ShroomObj.instance()
#
#			obj.position = obj_position
#			obj.variant = shroom
#
#			container.add_child(obj)
#		elif tree != -1:
#			var obj = TreeObj.instance()
#
#			obj.position = obj_position
#			obj.variant = tree
#
#			container.add_child(obj)

#func _get_grass():
#	var chance = randi() % 100
#
#	if chance < 20:
#		var num = randi() % 4
#
#		return num
#
#	return -1
#
#func _get_stump():
#	var chance = randi() % 100
#
#	if chance < 20:
#		var num = randi() % 4
#
#		return 4 + num
#
#	return -1
#
#func _get_shroom():
#	var chance = randi() % 100
#
#	if chance < 10:
#		var num = randi() % 8
#
#		return num
#
#	return -1
#
#func _get_tree():
#	var chance = randi() % 100
#
#	if chance < 10:
#		var num = randi() % 3
#
#		return num
#
#	return -1
