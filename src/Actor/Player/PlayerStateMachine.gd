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
