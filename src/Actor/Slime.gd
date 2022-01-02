extends KinematicBody2D

export var speed: int = 20
export var knockback_speed: int = 200
export var knockback_strength: int = 100
export var invincibility_duration: float = 0.5

var knockback: Vector2 = Vector2.ZERO
var velocity: Vector2 = Vector2.ZERO
var dir: Vector2 = Vector2.RIGHT

onready var animatedSprite = $AnimatedSprite
onready var playerDetectionZone = $PlayerDetectionZone
onready var stats = $Stats

func _ready():
	$EnemyStateMachine.set_active(true)
	
func seek_player():
	if $PlayerDetectionZone.can_see_player():
		$EnemyStateMachine.set_state($EnemyStateMachine/ChaseState)

func _on_Hurtbox_area_entered(area):
	if $Hurtbox.invincible == false:
		$Stats.set_health($Stats.health - area.damage)

		knockback = (global_position - area.global_position).normalized() * knockback_strength
		
		$HitSound.play()

	$Hurtbox.start_invincibility(invincibility_duration)

func _on_AnimatedSprite_animation_finished():
	if $AnimatedSprite.animation.begins_with("death"):
		queue_free()
