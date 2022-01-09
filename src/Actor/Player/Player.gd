extends KinematicBody2D
class_name Player

export var speed: int = 80
export var acceleration: int = 10
export var invincibility_duration: float = 1

const RESOURCES_BIT = 8

var path: PoolVector2Array = PoolVector2Array()
var velocity: Vector2 = Vector2.ZERO
var dir: Vector2 = Vector2.RIGHT
var hit_dir: Vector2 = Vector2.ZERO
var weapon = null

onready var aPlayer: AnimationPlayer = $AnimationPlayer
onready var aTree: AnimationTree = $AnimationTree
onready var aTreeState: AnimationNodeStateMachinePlayback = aTree.get("parameters/playback")
onready var dustEmitter: Node = $DustEmitter
onready var stats: Stats = $PlayerStats
onready var Weapon = preload("res://src/Objects/Weapons/Sword.tscn")

func _ready():
	DebugOverlay.add_stat("Player position", self, "position", false)
	DebugOverlay.add_stat("Player velocity", self, "velocity", false)

	var resource_emitter = Finder.get_resource_emitter()

	if resource_emitter:
		resource_emitter.set_target(self)

	aTree.active = true
	$StateMachine.set_active(true)

	weapon = Weapon.instance()
	add_child(weapon)
	
func follow_path(target_path):
	path = target_path
	
	if path.size() > 1:
		var turn_dir = position.x - path[path.size() - 1].x

		if turn_dir > 0:
			turn(Vector2.LEFT)

		if turn_dir < 0:
			turn(Vector2.RIGHT)

func follow_path_pop():
	path.remove(0)

func turn(target_dir):
	if dir != target_dir:
		dir = target_dir

		$StateMachine.change_state($StateMachine.TURN)

func _get_resource_emitter():
	return get_tree().current_scene.get_node_or_null("ResourceEmitter")

func _input(_event):
	if Globals.dialogicActive:
		return

	if Input.is_action_just_pressed("ui_click_right"):
		if weapon != null:
			weapon.hit(dir)
			
			var turn_dir = position.x - get_global_mouse_position().x

			if turn_dir > 0:
				turn(Vector2.LEFT)

			if turn_dir < 0:
				turn(Vector2.RIGHT)

func _on_Hurtbox_area_entered(area):
	if $Hurtbox.invincible == false:
		$PlayerStats.health = $PlayerStats.health - 1

		hit_dir = (global_position - area.global_position).normalized()
		
		$HitSound.play()

	if $StateMachine.current_state is PlayerDeathState:
		return

	$Hurtbox.start_invincibility(invincibility_duration)
	$StateMachine.change_state($StateMachine.HIT)

func _on_Hurtbox_invincibility_started():
	$BlinkAnimationPlayer.play("start")

func _on_Hurtbox_invincibility_ended():
	$BlinkAnimationPlayer.play("RESET")

func _on_InteractionZone_interaction_finished(strength):
	stats.stamina -= float(strength)

func _on_PlayerStats_health_depleted():
	$Hurtbox.active = false
	$StateMachine.change_state($StateMachine.DEATH)

func _on_PlayerStats_stamina_depleted():
	$InteractionZone.set_collision_mask_bit(RESOURCES_BIT, false)

func _on_PlayerStats_stamina_changed(value):
	if value > 0 and !$InteractionZone.get_collision_mask_bit(RESOURCES_BIT):
		$InteractionZone.set_collision_mask_bit(RESOURCES_BIT, true)

func _on_InteractionZone_rested():
	stats.reset_health()
	stats.reset_stamina()
