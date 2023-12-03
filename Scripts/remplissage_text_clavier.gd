extends VBoxContainer

var clav
var textedit
# Called when the node enters the scene tree for the first time.
func _ready():
	textedit = get_node("HBoxContainer/question_nom")
	textedit.focus_mode=1
	clav = get_node("ContainerClavier/Clavier")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	textedit.text = clav.text
	
