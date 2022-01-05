extends Navigation2D

var pressed = false
var queued_path = null
var queued_path_read = 0

export(NodePath) var player_path = null

func _ready():
	assert(player_path != null, "you must provide player_path")
	
func _physics_process(delta):
	if queued_path:
		if queued_path_read >= 1:
			var player = get_node(player_path)

			$Line2D.points = queued_path

			player.follow_path(queued_path)

			queued_path = null
			queued_path_read = 0
		queued_path_read += 1

func _navigate_to_mouse():
	if $InputTimer.is_stopped():
		$InputTimer.start()

		var player = get_node(player_path)
	
		if player:
			$InteractableChecker/CollisionShape2D.disabled = true
			$InteractableChecker/CollisionShape2D.disabled = false
			$InteractableChecker.position = get_local_mouse_position()
			
			# queue path for next tick so we can check collisions first
			queued_path_read = 0
			queued_path = get_simple_path(player.position, get_local_mouse_position())
			
func _input(event):
	if Input.is_action_just_pressed("ui_click_left"):
		_navigate_to_mouse()

func _on_InteractableChecker_area_entered(area):
	var radius = area.owner.get("radius")
	var interactable_distance = radius if radius else 10

	queued_path = null
	queued_path_read = 0

	var player = get_node(player_path)
	var direction = player.position.direction_to(area.global_position) * -interactable_distance
	var path = get_simple_path(player.position, area.global_position + direction)

	$Line2D.points = path

	player.follow_path(path)
