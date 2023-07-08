extends Node


export(NodePath) var camera_path
export(NodePath) var follow_node_path

var control_camera: Camera2D
var follow_node: Node2D

func _ready():
	control_camera = get_node(camera_path) as Camera2D
	assert(control_camera != null, "Add a camera to the CameraManager.")
	follow_node = get_node(follow_node_path) as Node2D
	assert(control_camera != null, "Add a follow node to the CameraManager.")


func _process(delta):
	control_camera.global_position = control_camera.global_position.linear_interpolate(
			Vector2(control_camera.global_position.x, follow_node.global_position.y + 50),
			1 - exp(-delta * 1.3))
