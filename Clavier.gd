extends CanvasLayer

var touche_template = preload("res://Scenes/touche_clavier.tscn")
var textedit

# Called when the node enters the scene tree for the first time.
func _ready():
	textedit = $CenterContainer/VBoxContainer/TextEdit
	var container = $CenterContainer/VBoxContainer/HFlowContainer
	for n in ["a","z","e","r","t","y","u","i","o","p"]:
		var touche = touche_template.instantiate()
		touche.text = n
		touche.textglob = textedit
		container.add_child(touche)
		
	var container2 = $CenterContainer/VBoxContainer/HFlowContainer2
	for n in ["q","s","d","f","g","h","j","k","l","m"]:
		var touche = touche_template.instantiate()
		touche.text = n
		touche.textglob = textedit
		container2.add_child(touche)
		
	var container3 = $CenterContainer/VBoxContainer/HFlowContainer3
	for n in ["w","x","c","v","b","n"]:
		var touche = touche_template.instantiate()
		touche.text = n
		touche.textglob = textedit
		container3.add_child(touche)	
	
	
