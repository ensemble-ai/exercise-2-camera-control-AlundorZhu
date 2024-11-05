class_name FourWaySpeedUp
extends CameraControllerBase

@export var push_ratio:float = 0.8
@export var pushbox_top_left:Vector2 = Vector2(-5, -5)
@export var pushbox_bottom_right:Vector2 = Vector2(5, 5)
@export var speedup_zone_top_left:Vector2 = Vector2(-10, -10)
@export var speedup_zone_bottom_right:Vector2 = Vector2(10, 10)


@export var box_width:float = 10.0
@export var box_height:float = 10.0


func _ready() -> void:
	super()
	position = target.position
	

func _process(delta: float) -> void:
	if !current:
		return
	
	if draw_camera_logic:
		draw_logic()
	
	var tpos = target.global_position
	var cpos = global_position
	
	#boundary checks
	#left
	var diff_between_left_edges = (tpos.x - target.WIDTH / 2.0) - (cpos.x - box_width / 2.0)
	if diff_between_left_edges < 0:
		global_position.x += diff_between_left_edges
	#right
	var diff_between_right_edges = (tpos.x + target.WIDTH / 2.0) - (cpos.x + box_width / 2.0)
	if diff_between_right_edges > 0:
		global_position.x += diff_between_right_edges
	#top
	var diff_between_top_edges = (tpos.z - target.HEIGHT / 2.0) - (cpos.z - box_height / 2.0)
	if diff_between_top_edges < 0:
		global_position.z += diff_between_top_edges
	#bottom
	var diff_between_bottom_edges = (tpos.z + target.HEIGHT / 2.0) - (cpos.z + box_height / 2.0)
	if diff_between_bottom_edges > 0:
		global_position.z += diff_between_bottom_edges
		
	super(delta)


func create_box(top_left: Vector2, bottom_right: Vector2) -> MeshInstance3D:
		var mesh_instance := MeshInstance3D.new()
		var immediate_mesh := ImmediateMesh.new()
		var material := ORMMaterial3D.new()
		
		mesh_instance.mesh = immediate_mesh
		mesh_instance.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
		
		var left:float = top_left.x
		var right:float = bottom_right.x
		var top:float = top_left.y
		var bottom:float = bottom_right.y
		
		immediate_mesh.surface_begin(Mesh.PRIMITIVE_LINES, material)
		immediate_mesh.surface_add_vertex(Vector3(right, 0, top))
		immediate_mesh.surface_add_vertex(Vector3(right, 0, bottom))
		
		immediate_mesh.surface_add_vertex(Vector3(right, 0, bottom))
		immediate_mesh.surface_add_vertex(Vector3(left, 0, bottom))
		
		immediate_mesh.surface_add_vertex(Vector3(left, 0, bottom))
		immediate_mesh.surface_add_vertex(Vector3(left, 0, top))
		
		immediate_mesh.surface_add_vertex(Vector3(left, 0, top))
		immediate_mesh.surface_add_vertex(Vector3(right, 0, top))
		immediate_mesh.surface_end()

		material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
		material.albedo_color = Color.BLACK
		
		add_child(mesh_instance)
		mesh_instance.global_transform = Transform3D.IDENTITY
		mesh_instance.global_position = Vector3(global_position.x, target.global_position.y, global_position.z)
		
		return mesh_instance

func draw_logic() -> void:
	var push_box := create_box(pushbox_top_left, pushbox_bottom_right)
	var speedup_box := create_box(speedup_zone_top_left, speedup_zone_bottom_right)

	#mesh is freed after one update of _process
	await get_tree().process_frame
	push_box.queue_free()
	speedup_box.queue_free()
