extends KinematicBody2D

export var speed: int = 80
export var acceleration: int = 10
export var invincibility_duration: float = 1
var path: PoolVector2Array = PoolVector2Array()
var velocity: Vector2 = Vector2.ZERO
var dir: Vector2 = Vector2.RIGHT
var hit_dir: Vector2 = Vector2.ZERO
var weapon = null

onready var aPlayer: AnimationPlayer = $AnimationPlayer
onready var aTree: AnimationTree = $AnimationTree
onready var aTreeState: AnimationNodeStateMachinePlayback = aTree.get("parameters/playback")
onready var dustEmitter: Node = $DustEmitter
onready var Weapon = preload("res://src/Objects/Weapons/Sword.tscn")

func _ready():
	DebugOverlay.add_stat("Player position", self, "position", false)
	DebugOverlay.add_stat("Player velocity", self, "velocity", false)

	var resource_emitter = Finder.get_resource_emitter()

	if resource_emitter:
		resource_emitter.set_target(self)

	aTree.active = true
	$StateMachine.set_active(true)
	# warning-ignore:return_value_discarded
	$PlayerStats.connect("health_depleted", self, "destroyed")

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

		$StateMachine.set_state($StateMachine/TurnState)

func destroyed():
	$Hurtbox.active = false
	$StateMachine.set_state($StateMachine/DeathState)

func _get_resource_emitter():
	return get_tree().current_scene.get_node_or_null("ResourceEmitter")

func _input(_event):
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
	$StateMachine.set_state($StateMachine/HitState)

func _on_Hurtbox_invincibility_started():
	$BlinkAnimationPlayer.play("start")

func _on_Hurtbox_invincibility_ended():
	$BlinkAnimationPlayer.play("RESET")
