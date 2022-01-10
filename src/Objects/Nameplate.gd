extends StaticBody2D

export(NodePath) var buildable = null

func _on_Interactable_interacted_dialog(_area, output):
	if output.size() and output[0] == "yes":
		var buildable_node = get_node_or_null(buildable)

		if buildable_node and buildable_node.has_method("build"):
			if buildable_node.has_method("is_buildable"):
				if buildable_node.is_buildable() and buildable_node.build():
					queue_free()
			elif buildable_node.build():
				queue_free()
