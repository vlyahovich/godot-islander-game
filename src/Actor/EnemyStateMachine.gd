extends "res://src/State/StateMachine.gd"

const DEFAULT = "default"
const WANDER = "turn"
const CHASE = "chase"

onready var EnemyDefaultState = preload("res://src/Actor/EnemyDefaultState.gd")
onready var EnemyWanderState = preload("res://src/Actor/EnemyWanderState.gd")
onready var EnemyChaseState = preload("res://src/Actor/EnemyChaseState.gd")

func _ready():
	states_map = {
		DEFAULT: $DefaultState,
		WANDER: $WanderState,
		CHASE: $ChaseState
	}

func set_state(state):
	if state is EnemyWanderState:
		._change_state(WANDER)
	if state is EnemyChaseState:
		._change_state(CHASE)
	else:
		._change_state(DEFAULT)

func previous_state():
	._change_state("previous")
