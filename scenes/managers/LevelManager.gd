extends Node


export(NodePath) var world_node_path: NodePath

onready var world_node = get_node(world_node_path)


func load_level(level_path: String):
	world_node.pause_mode = Node.PAUSE_MODE_STOP
	if $AnimationPlayer.is_playing():
		return
	var level: Node = null
	if ResourceLoader.exists(level_path):
		level = ResourceLoader.load(level_path).instance()
		assert(level != null, "Add a valid path to load the scene.")
	$AnimationPlayer.connect("animation_finished", self, "_on_animation_finished", [level])
	$AnimationPlayer.play("dissolve")


func _on_animation_finished(anim_name: String, level: Node):
	world_node.pause_mode = Node.PAUSE_MODE_STOP
	if anim_name == "dissolve":
		if world_node == null:
			level.queue_free()
			assert(world_node != null, "Add a world node to " + name)

		for child in world_node.get_children():
			world_node.remove_child(child)
			child.queue_free()
		world_node.add_child(level)

	$AnimationPlayer.disconnect("animation_finished", self, "_on_animation_finished")
	$AnimationPlayer.play_backwards("dissolve")
	yield($AnimationPlayer, 'animation_finished')
	world_node.pause_mode = Node.PAUSE_MODE_STOP
