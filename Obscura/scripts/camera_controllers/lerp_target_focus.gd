class_name LinearInterpolationTargetFocus
extends CameraControllerBase

@export var cross_hair_width:float = 5.0
@export var cross_hair_height:float = 5.0
@export var lead_speed:float = 1.5
@export var catchup_delay_duration:float = 0.05
@export var catchup_speed:float = 0.5
@export var leash_distance:float = 5

var timer: Timer

func _ready() -> void:
	super()
	position = target.position
	

func is_same_pos() -> bool:
	return Vector2(global_position.x, global_position.z).is_equal_approx(Vector2(target.global_position.x, target.global_position.z))

func delete_timer() -> void:
	if timer == null:
		return
	timer.queue_free()
	timer = null
	
func _process(delta: float) -> void:
	if !current:
		return
		
	if draw_camera_logic:
		draw_logic()

	var distance_to_target := Vector2(global_position.x, global_position.z).distance_to(Vector2(target.global_position.x, target.global_position.z))
	
	
	if target.velocity.is_zero_approx():
		if timer == null:
			timer = Timer.new()
			add_child(timer)
			timer.start(catchup_delay_duration)
			timer.one_shot = true
		
		if timer.is_stopped():
			global_position = global_position.move_toward(target.global_position, catchup_speed * target.BASE_SPEED * delta)
			if is_same_pos():
				delete_timer()
	elif distance_to_target > leash_distance:
		global_position = global_position.move_toward(target.global_position, distance_to_target - leash_distance)
		delete_timer()
	else:
		global_position += target.velocity * delta * lead_speed
		delete_timer()
		
	super(delta)
	
	
func draw_logic() -> void:
	var mesh_instance := MeshInstance3D.new()
	var immediate_mesh := ImmediateMesh.new()
	var material := ORMMaterial3D.new()
	
	mesh_instance.mesh = immediate_mesh
	mesh_instance.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	
	var left:float = -cross_hair_width / 2
	var right:float = cross_hair_width / 2
	var top:float = -cross_hair_height / 2
	var bottom:float = cross_hair_height / 2
	
	immediate_mesh.surface_begin(Mesh.PRIMITIVE_LINES, material)
	immediate_mesh.surface_add_vertex(Vector3(right, 0, 0))
	immediate_mesh.surface_add_vertex(Vector3(left, 0, 0))
	
	immediate_mesh.surface_add_vertex(Vector3(0, 0, bottom))
	immediate_mesh.surface_add_vertex(Vector3(0, 0, top))
	immediate_mesh.surface_end()

	material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	material.albedo_color = Color.BLACK
	
	add_child(mesh_instance)
	mesh_instance.global_transform = Transform3D.IDENTITY
	mesh_instance.global_position = Vector3(global_position.x, target.global_position.y, global_position.z)
	
	#mesh is freed after one update of _process
	await get_tree().process_frame
	mesh_instance.queue_free()
