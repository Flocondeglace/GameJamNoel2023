extends PanelContainer

var touche_template = preload("res://Scenes/touche_clavier.tscn")
var textedit
var maj:bool

var text

# Called when the node enters the scene tree for the first time.
func _ready():
	text = ""
	maj = false
	var container = $CenterContainer/VBoxContainer/HFlowContainer
	for n in ["a","z","e","r","t","y","u","i","o","p"]:
		var touche = touche_template.instantiate()
		touche.text = n
		touche.textglob = self
		container.add_child(touche)
	var touche_r = touche_template.instantiate()
	touche_r.textglob = self
	touche_r.text = "<-"
	touche_r.size_flags_stretch_ratio = 2
	touche_r.disconnect("pressed",touche_r._on_pressed)
	touche_r.connect("pressed",touche_r_func)
	container.add_child(touche_r)
	
	var container2 = $CenterContainer/VBoxContainer/HFlowContainer2
	
	var touche_maj = touche_template.instantiate()
	touche_maj.textglob = self
	touche_maj.text = "maj"
	touche_maj.disconnect("pressed",touche_maj._on_pressed)
	touche_maj.connect("pressed",touche_maj_func)
	container2.add_child(touche_maj)
	
	for n in ["q","s","d","f","g","h","j","k","l","m"]:
		var touche = touche_template.instantiate()
		touche.text = n
		touche.textglob = self
		container2.add_child(touche)
	
	var toucheeff = touche_template.instantiate()
	toucheeff.textglob = self
	toucheeff.text = "clear"
	toucheeff.connect("pressed",clear)
	container2.add_child(toucheeff)
		
	var container3 = $CenterContainer/VBoxContainer/HFlowContainer3
	for n in ["-","w","x","c","v","b","n","_"]:
		var touche = touche_template.instantiate()
		touche.text = n
		touche.textglob = self
		container3.add_child(touche)
	(get_tree().get_nodes_in_group("clavierButton"))[0].grab_focus()
	touche_maj_func()
	
	
func touche_r_func():
	#var t = textedit.text.length()
	#textedit.text = textedit.del (textedit.text)[t-1]
	#textedit.select(0, t-1, 1, t)
	#textedit.delete_selection(0)
	
	#print(textedit.get_line(0))
	text = text.left(-1)

func touche_maj_func():
	maj = !maj
	for button in (get_tree().get_nodes_in_group("clavierButton")):
		if maj :
			button.activate_maj()
		else :
			button.desactivate_maj()

func clear():
	text = ""
