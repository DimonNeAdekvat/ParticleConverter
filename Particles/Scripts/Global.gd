extends Control

export(PackedScene) var particleScene

var FilePaths: PoolStringArray
var FolderPth: String

var ParticlePosArray : PoolVector3Array
var ParticleColArray : PoolColorArray
var IgnoreTransparent : bool = true

var sizeBlock = Vector2(0,0)
var sizePixel = Vector2(0,0)

func _ready():
	OS.min_window_size = Vector2(600,400)

#when to generate
func FilesSelected(paths: PoolStringArray):
	FilePaths.resize(0)
	FilePaths.append_array(paths)
	FilePaths.sort()
	if FilePaths.size() > 1:
		$SettingsPanel/Settings/ViewImage.visible = true
		for path in FilePaths:
			$SettingsPanel/Settings/ViewImage/Option.add_item(path)
			oprint("Selected " + path + '\n')
		oprint("End of selection\n")
		oprint("Sorted selected files\n")
	else:
		$SettingsPanel/Settings/ViewImage.visible = false
		oprint("Selected " + FilePaths[0] + '\n')
		oprint("End of selection\n")
	pFull(0)


func FileSelected(new_text: String):
	FilePaths.resize(0)
	var file2Check = File.new()
	$SettingsPanel/Settings/ViewImage.visible = false
	if file2Check.file_exists(new_text):
		FilePaths.append(new_text)
		oprint("Selected " + FilePaths[0] + '\n')
		oprint("End of selection\n")
		pFull(0)

func FileChanged(index : int):
	pFull(index)

#generate & draw
func pGen(index : int):
	var img = Image.new()
	var col : Color
	var pos = Vector3(0,0,0)
	img.unlock()
	img.load(FilePaths[index])
	oprint("Loaded " + FilePaths[index] + '\n')
	img.convert(Image.FORMAT_RGBA8)
	img.lock()
	if $"%Config".confImgAutoSize :
		sizeBlock = img.get_size()/$"%Config".confParticleDensity
		sizePixel = img.get_size()
	else:
		sizeBlock = $"%Config".confSizeBlock
		sizePixel = $"%Config".confSizePixel
		img.unlock()
		img.resize(int(sizePixel.x),int(sizePixel.y),$"%Config".confSizeIntrp)
		img.lock()

	for m_x in range(0,int(sizePixel.x)):
		pos = Vector3(0,0,0)
		pos.x = (m_x - (sizePixel.x - 1)/2)*sizeBlock.x/sizePixel.x
		for m_y in range(0,int(sizePixel.y)):
			col = img.get_pixel(m_x,m_y)
			pos.z = (m_y - (sizePixel.y - 1)/2)*sizeBlock.y/sizePixel.y
			if(IgnoreTransparent and col.a <= 0.01): continue
			col.a = 1
			ParticleColArray.append(col)
			ParticlePosArray.append(pos)

func pMove():
	_on_Config_Move()

func pClear():
	for del in get_tree().get_nodes_in_group("Particles"):
		del.remove_from_group("Particles")
		del.queue_free()
	ParticleColArray.resize(0)
	ParticlePosArray.resize(0)

func pApply():
	oprint("Drawn particles\n")
	for i in range(0,ParticlePosArray.size()):
		var particle = particleScene.instance()
		particle.setPos(ParticlePosArray[i])
		particle.setColor(ParticleColArray[i])
		particle.setSize($"%Config".confParticleSize)
		particle.add_to_group("Particles")
		$"%Preview/PlaneFlip/Rotation/Align".add_child(particle)

func pFull(index : int):
	pClear()
	pGen(index)
	pMove()
	pApply()


#one liners ahead
func _on_Reset():
	$"%Preview/GimbalCamera".Reset()

func Preview(button_pressed):
	$RightHalf/ViewportContainer.visible = button_pressed

func _on_Transparent(button_pressed):
	IgnoreTransparent = button_pressed
	if FilePaths.size() > 1:
		pFull($SettingsPanel/Settings/ViewImage/Option.selected)
	if FilePaths.size() == 1:
		pFull(0)

func _on_Config_Move():
	var axis = $"%Config".confPlaneAxis
	var flip = $"%Config".confPlaneFlip
	var rots = $"%Config".confPlaneRota
	var AlgH = $"%Config".confAlignH
	var AlgV = $"%Config".confAlignV
	if not flip :
		$"%Preview/PlaneFlip/Rotation".rotation_degrees = Vector3(0,rots,0)
		if axis == 0 :
			$"%Preview/PlaneFlip".rotation_degrees = Vector3(0,0,0)
		if axis == 1 :
			$"%Preview/PlaneFlip".rotation_degrees = Vector3(90,0,0)
		if axis == 2 :
			$"%Preview/PlaneFlip".rotation_degrees = Vector3(90,90,0)
		$"%Preview/PlaneFlip/Rotation/Align".translation.z = sizeBlock.y*(1-AlgV)/2
	else:
		$"%Preview/PlaneFlip/Rotation".rotation_degrees = Vector3(0,-rots,0)
		if axis == 0 :
			$"%Preview/PlaneFlip".rotation_degrees = Vector3(180,0,0)
		if axis == 1 :
			$"%Preview/PlaneFlip".rotation_degrees = Vector3(-90,0,0)
		if axis == 2 :
			$"%Preview/PlaneFlip".rotation_degrees = Vector3(-90,90,0)
		$"%Preview/PlaneFlip/Rotation/Align".translation.z = sizeBlock.y*(AlgV-1)/2
	$"%Preview/PlaneFlip/Rotation/Align".translation.x = sizeBlock.x*(1-AlgH)/2


func _on_Config_reGenerate():
	if FilePaths.size() > 1:
		pFull($SettingsPanel/Settings/ViewImage/Option.selected)
	if FilePaths.size() == 1:
		pFull(0)


func _on_Config_ParticleSize():
	for particle in get_tree().get_nodes_in_group("Particles"):
		particle.setSize($"%Config".confParticleSize)


func Generate():
	FolderPth = $SettingsPanel/Settings/Paths/Output/OutputPath.text
	var folder = Directory.new()
	var FileName : String
	if FolderPth.empty() :
		return ERR_CANT_OPEN
	if not folder.dir_exists(FolderPth):
		return ERR_DOES_NOT_EXIST
	if FilePaths.size() == 0:
		return ERR_FILE_NOT_FOUND
	for i in range(0,FilePaths.size()):
		var file = File.new()
		FileName = FolderPth + "/frame" + str(i) + ".mcfunction"
		file.open(FileName,File.WRITE)
		oprint("Readied " + FileName + " to write \n")
		var command = "particle minecraft:dust {0} {1} {2} {3} {p}{4} {p}{5} {p}{6} 0 0 0 0 1"
		if $"%Config".confCoordinateMode == 0:
			command = command.format({"p":"~"})
		if $"%Config".confCoordinateMode == 1:
			command = command.format({"p":"^"})
		if $"%Config".confCoordinateMode == 2:
			command = command.format({"p":""})
		var posShift : Vector3 = $"%Config".confPositionShift
		pFull(i)
		oprint("Writing to " + FileName + "\n")
		var k : int = 0
		for particle in get_tree().get_nodes_in_group("Particles"):
			var newl : String = command
			var pos : Vector3 = particle.global_transform.origin
			var size : float = particle.size
			var colr : Color = particle.color
			pos = pos + posShift
			newl = newl.format({"0":colr.r,"1":colr.g,"2":colr.b,"3":size,"4":pos.x,"5":pos.y,"6":pos.z})
			file.store_string(newl + '\n')
			k += 1
		oprint("Written " + str(k) + " lines\n")
		file.close()
		oprint(FileName + " closed")

func oprint(string : String):
	$"%Output".add_text(string)
