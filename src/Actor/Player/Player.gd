extends KinematicBody2D

export var speed: int = 80
export var acceleration: int = 10
export var invincibility_duration: float = 1
var path: PoolVector2Array = PoolVector2Array()
var velocity: Vector2 = Vector2.ZERO
var dir: Vector2 = Vector2.RIGHT
var hit_dir: Vector2 = Vector2.ZERO
var crosshair = null
var weapon = null

onready var aPlayer: AnimationPlayer = $AnimationPlayer
onready var aTree: AnimationTree = $AnimationTree
onready var aTreeState: AnimationNodeStateMachinePlayback = aTree.get("parameters/playback")
onready var Crosshair = preload("res://src/UserInterface/Crosshair.tscn")
onready var Weapon = preload("res://src/Objects/Weapons/Sword.tscn")

func _ready():
	DebugOverlay.add_stat("Player position", self, "position", false)
	DebugOverlay.add_stat("Player velocity", self, "velocity", false)

	aTree.active = true
	$StateMachine.set_active(true)
	$PlayerStats.connect("health_depleted", self, "destroyed")

	weapon = Weapon.instance()
	add_child(weapon)
	
func follow_path(target_path):
	path = target_path
	
	if path.size() > 1:
		show_crosshair()

		if position.x - path[1].x > 0:
			turn(Vector2.LEFT)
		else:
			turn(Vector2.RIGHT)

func follow_path_pop():
	path.remove(0)
	
func show_crosshair():
	hide_crosshair()

	crosshair = Crosshair.instance()
	crosshair.global_position = path[path.size() - 1]

	owner.add_child(crosshair)
	
func hide_crosshair():
	if crosshair:
		crosshair.hide()
		crosshair = null

func turn(target_dir):
	if dir != target_dir:
		dir = target_dir

		$StateMachine.set_state($StateMachine/TurnState)

func destroyed():
	$Hurtbox.active = false
	$StateMachine.set_state($StateMachine/DeathState)
	
func turn_animation_finished():
	$StateMachine.set_state($StateMachine/DefaultState)
	
func _unhandled_input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_RIGHT and event.pressed:
			if weapon != null:
				weapon.hit(dir)

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
