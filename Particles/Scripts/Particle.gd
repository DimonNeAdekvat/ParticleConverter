extends MeshInstance

var color : Color
var size : float

func _ready():
	pass

func setSize(n_size : float):
	var t = n_size/6
	size = n_size
	scale = Vector3(t,t,t)

func setPos(pos : Vector3):
	translation = pos

func setColor(col : Color):
	color = col
	var m = SpatialMaterial.new()
	m.flags_unshaded = true
	m.flags_transparent = true
	m.params_billboard_mode = SpatialMaterial.BILLBOARD_PARTICLES
	m.albedo_color = color
	m.albedo_texture = load("res://images/sircle.svg")
	set_surface_material(0,m)
