extends Spatial

var mouse_sens = 0.3
var dist = 5
var dir_d = 0

func _ready():
	Reset()

func Reset():
	dist = 5
	translation = Vector3(0,0,0)
	rotation = Vector3(0,deg2rad(45),0)
	$Gimbal.rotation = Vector3(-deg2rad(45),0,0)
	$Gimbal/Camera.translation = Vector3(0,0,dist)

func _input(event):
	if event is InputEventMouseMotion:
		if event.button_mask == BUTTON_MASK_LEFT:
			rotate_y(deg2rad(-event.relative.x*mouse_sens))
			$Gimbal.rotate_x(deg2rad(-event.relative.y*mouse_sens))
		if event.button_mask == BUTTON_MASK_RIGHT:
			var dir_u = Vector3(0,1,0).rotated(Vector3(1,0,0),$Gimbal.rotation.x)
			translate(Vector3(-1,0,0)*event.relative.x*mouse_sens*0.01)
			translate(dir_u*event.relative.y*mouse_sens*0.01)
	if event is InputEventMouseButton:
		if event.is_pressed():
			if event.button_index == BUTTON_WHEEL_DOWN:
				dir_d = 1
			if event.button_index == BUTTON_WHEEL_UP:
				dir_d = -1

func _process(delta):
	dist += 10*dir_d*max(1,dist)*delta
	if dist < 0 : dist = 0
	$Gimbal/Camera.translation.z = dist
	dir_d = 0
