extends KinematicBody2D
class_name Enemy

export var speed: int = 20
export var knockback_speed: int = 200
export var knockback_strength: int = 100
export var invincibility_duration: float = 0.5

var knockback: Vector2 = Vector2.ZERO
var velocity: Vector2 = Vector2.ZERO
var dir: Vector2 = Vector2.RIGHT

onready var animatedSprite: AnimatedSprite = $AnimatedSprite
onready var playerDetectionZone: Area2D = $PlayerDetectionZone
onready var stats: Stats = $Stats
onready var wanderController: EnemyWanderController = $WanderController

func _ready():
	$EnemyStateMachine.set_active(true)

	next_state()
	
func seek_player():
	if $PlayerDetectionZone.can_see_player():
		$EnemyStateMachine.change_state($EnemyStateMachine.CHASE)

func next_state():
	var list = [$EnemyStateMachine.DEFAULT, $EnemyStateMachine.WANDER]

	list.shuffle()

	$EnemyStateMachine.change_state(list.pop_front())

	wanderController.start_wandering(rand_range(1, 3))

func _on_Hurtbox_area_entered(area):
	if $Hurtbox.invincible == false:
		$Stats.set_health($Stats.health - area.damage)

		knockback = (global_position - area.global_position).normalized() * knockback_strength
		
		$HitSound.play()

	$Hurtbox.start_invincibility(invincibility_duration)

func _on_AnimatedSprite_animation_finished():
	if stats.health == 0:
		queue_free()
