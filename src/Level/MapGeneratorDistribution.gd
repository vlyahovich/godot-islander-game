extends Node

enum TYPES {
	SHROOM,
	GRASS,
	TREE,
	STUMP,
	BLANK
}

var distribution = []
var variance = {
	TYPES.GRASS: 3,
	TYPES.SHROOM: 8,
	TYPES.TREE: 3,
	TYPES.STUMP: 4,
	TYPES.BLANK: 1
}

func _ready():
	add_distribution(TYPES.GRASS, 20)
	add_distribution(TYPES.SHROOM, 5)
	add_distribution(TYPES.TREE, 5)
	add_distribution(TYPES.STUMP, 5)
	add_distribution(TYPES.BLANK, 65)

func add_distribution(type, chance):
	for i in range(distribution.size(), distribution.size() + chance):
		distribution.push_back(type)

func roll():
	var index = randi() % distribution.size()

	return {
		"type": distribution[index],
		"variance": randi() % variance[distribution[index]]
	}
