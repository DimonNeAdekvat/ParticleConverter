extends ViewportContainer

func _ready():
	connect("mouse_entered",self,"onMouseEntered")
	connect("mouse_exited",self,"onMouseExited")

func onMouseEntered():
	$"%Preview".gui_disable_input = false

func onMouseExited():
	$"%Preview".gui_disable_input = true
