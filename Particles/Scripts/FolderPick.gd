extends HBoxContainer


func _ready():
	pass

func showDialog():
	var size = OS.get_real_window_size()
	$FolderButton/FolderDialog.popup_centered(size*3/4)

func setPath(path: String):
	$OutputPath.text = path
	
