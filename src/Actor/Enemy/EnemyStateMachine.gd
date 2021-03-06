extends "res://src/State/StateMachine.gd"
class_name EnemyStateMachine

const DEFAULT = "default"
const WANDER = "wander"
const CHASE = "chase"

func _ready():
	states_map = {
		DEFAULT: $DefaultState,
		WANDER: $WanderState,
		CHASE: $ChaseState
	}
	
func change_state(state):
	.change_state(state)
