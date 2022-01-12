extends StaticBody2D

export var broken = true setget set_broken

const WORLD_BIT = 0
const BRIDGES_BIT = 7

func _ready():
	_update_state()

func set_broken(value):
	broken = value

	_update_state()

func is_buildable():
	return broken == true

func build():
	if PlayerInventory.use_resources([ResourceMap.WOOD, ResourceMap.STONE], [300, 300]):
		set_broken(false)

		$Area2D/CollisionShape2D.disabled = true
		$Area2D/CollisionShape2D.disabled = false

		return true

	return false

func _update_state():
	if !is_inside_tree():
		return

	if broken:
		$TileMapBroken.visible = true
		$TileMap.visible = false
	else:
		$TileMapBroken.visible = false
		$TileMap.visible = true

func _on_Area2D_body_entered(body):
	if broken:
		return

	if "Player" in body.get_groups() or "Enemy" in body.get_groups():
		body.set_collision_mask_bit(BRIDGES_BIT, true)
		body.set_collision_mask_bit(WORLD_BIT, false)


func _on_Area2D_body_exited(body):
	if broken:
		return

	if "Player" in body.get_groups() or "Enemy" in body.get_groups():
		body.set_collision_mask_bit(BRIDGES_BIT, false)
		body.set_collision_mask_bit(WORLD_BIT, true)
