extends VBoxContainer

signal Coords
signal Move
signal reGenerate
signal ParticleSize

var confCoordinateMode : int = 0
var confPositionShift = Vector3(0,0,0)

var confPlaneAxis : int = 0
var confPlaneFlip : bool = false
var confPlaneRota : float = 0

var confAlignH : int = 1
var confAlignV : int = 1
var confParticleSize : float = 0.75
var confImgAutoSize : bool = true
var confParticleDensity : int = 8

var confSizeBlock = Vector2(1,1)
var confSizePixel = Vector2(8,8)
var confSizeIntrp : int = 0

func _ready():
	$NotAutoSize.visible = false

func _on_CoordinateMode(index):
	confCoordinateMode = index
	emit_signal("Coords")

func _on_X_value(value):
	confPositionShift.x = value
	emit_signal("Coords")

func _on_Y_value(value):
	confPositionShift.y = value
	emit_signal("Coords")

func _on_Z_value(value):
	confPositionShift.z = value
	emit_signal("Coords")

#move stuff
func _on_PlaneAxis(index):
	confPlaneAxis = index
	emit_signal("Move")

func _on_Flip(button_pressed):
	confPlaneFlip = button_pressed
	emit_signal("Move")

func _on_RotationP(value):
	confPlaneRota = value
	emit_signal("Move")

func _on_AlignH(index):
	confAlignH = index
	emit_signal("Move")

func _on_AlignV(index):
	confAlignV = index
	emit_signal("Move")

#regenerate stuff
func onAutoSizeToggle(button_pressed):
	confImgAutoSize = button_pressed
	$Particle/Density.editable = button_pressed
	$NotAutoSize.visible = !button_pressed
	emit_signal("reGenerate")

func _on_WidthB(value):
	confSizeBlock.x = value
	emit_signal("reGenerate")

func _on_HeightB(value):
	confSizeBlock.y = value
	emit_signal("reGenerate")

func _on_WidthP(value):
	confSizePixel.x = value
	emit_signal("reGenerate")

func _on_HeightP(value):
	confSizePixel.y = value
	emit_signal("reGenerate")

func _on_Interpolation(index):
	confSizeIntrp = index
	emit_signal("reGenerate")

func _on_ParticleDensity(value):
	confParticleDensity = int(value)
	emit_signal("reGenerate")

func _on_ParticleSize(value):
	confParticleSize = value
	emit_signal("ParticleSize")
