extends "res://src/State/StateMachine.gd"

const DEFAULT = "default"
const TURN = "turn"
const HIT = "hit"
const DEATH = "death"

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
