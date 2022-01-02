extends "res://src/State/StateMachine.gd"

const DEFAULT = "default"
const TURN = "turn"
const HIT = "hit"
const DEATH = "death"

onready var PlayerDefaultState = preload("res://src/Actor/PlayerDefaultState.gd")
onready var PlayerTurnState = preload("res://src/Actor/PlayerTurnState.gd")
onready var PlayerHitState = preload("res://src/Actor/PlayerHitState.gd")
onready var PlayerDeathState = preload("res://src/Actor/PlayerDeathState.gd")

func _ready():
	states_map = {
		DEFAULT: $DefaultState,
		TURN: $TurnState,
		HIT: $HitState,
		DEATH: $DeathState
	}

func set_state(state):
	if state is PlayerTurnState:
		._change_state(TURN)
	elif state is PlayerHitState:
		._change_state(HIT)
	elif state is PlayerDeathState:
		._change_state(DEATH)
	else:
		._change_state(DEFAULT)

func previous_state():
	._change_state("previous")
