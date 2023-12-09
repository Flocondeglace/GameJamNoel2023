extends VBoxContainer

var clav
var textedit

func _ready():
	textedit = get_node("HBoxContainer/question_nom")
	textedit.focus_mode=1
	clav = %Clavier


func _process(_delta):
	textedit.text = clav.text
	
