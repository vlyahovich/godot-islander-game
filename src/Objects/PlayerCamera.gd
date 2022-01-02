extends Camera2D

func _ready():
	limit_top = $ViewLimits/TopLeftLimit.position.y
	limit_left = $ViewLimits/TopLeftLimit.position.x
	limit_right = $ViewLimits/BottomRightLimit.position.x
	limit_bottom = $ViewLimits/BottomRightLimit.position.y
