extends ImmediateGeometry


func _ready():
	var m = SpatialMaterial.new()
	m.flags_use_point_size = true
#	m.params_point_size = 8
	m.flags_unshaded = true
	m.vertex_color_use_as_albedo = true
	set_material_override(m)
	clear()
	begin(Mesh.PRIMITIVE_LINES)
	set_color(Color(1,1,1))
	for i in range(-5,0):
		add_vertex(Vector3(i,0,-5))
		add_vertex(Vector3(i,0,5))
		add_vertex(Vector3(-5,0,i))
		add_vertex(Vector3(5,0,i))
	for i in range(1,6):
		add_vertex(Vector3(i,0,-5))
		add_vertex(Vector3(i,0,5))
		add_vertex(Vector3(-5,0,i))
		add_vertex(Vector3(5,0,i))
	add_vertex(Vector3(-5,0,0))
	add_vertex(Vector3(0,0,0))
	add_vertex(Vector3(1,0,0))
	add_vertex(Vector3(5,0,0))
	add_vertex(Vector3(0,0,-5))
	add_vertex(Vector3(0,0,0))
	add_vertex(Vector3(0,0,1))
	add_vertex(Vector3(0,0,5))
	set_color(Color(0,0,1))
	add_vertex(Vector3(0,0,0))
	add_vertex(Vector3(0,0,1))
	set_color(Color(0,1,0))
	add_vertex(Vector3(0,0,0))
	add_vertex(Vector3(0,1,0))
	set_color(Color(1,0,0))
	add_vertex(Vector3(0,0,0))
	add_vertex(Vector3(1,0,0))
	end()
