extends HBoxContainer


func _ready():
	pass

func showDialog():
	var size = OS.get_real_window_size()
	$FileButton/FileDialog.popup_centered(size*3/4)

func setPaths(paths: PoolStringArray):
	if paths.size() == 1:
		$InputPath.text = paths[0]
	else:
		$InputPath.text = "Multiple files selected"
