extends Node2D

# Manager
var audio_manager
var hud

# liste des tuiles des notes en cours de descente
var liste_note

# Nombre total de point : différent suivant la performance
var tot_point

var combo # nb de perfect d'affilée actuellement

# Template
var note_template = preload("res://Scenes/note.tscn")
var colonne_template = preload("res://Scenes/colonne.tscn")
var touche_template = preload("res://Scenes/touche_text.tscn")
var partition_template = preload("res://Scenes/partition.tscn")
var effet_replay_template = preload("res://Scenes/effet_replay.tscn")

var nums_touches = {"capturera": 0, "capturerb": 1, "capturerc": 2}
var noms_touches = {"R": 0, "T": 1, "Y": 2}

# Node
#onready var visibility_notifier := $VisibleOnScreenNotifier2D

# Dimension
var lignedim

# Partition en cours 
var partition
var timing_notes

var pause_legal



signal last_note


# Called when the node enters the scene tree for the first time.
func _ready():
	pause_legal = false
	#restart = false
	var note_size = Vector2(128,128)
	# Initialiser les listes
	liste_note = []
	# Initialiser variables
	tot_point = 0
	
	# Manager
	audio_manager = get_parent().get_node("./AudioManager")
	hud = get_parent().get_node("./HUD")
	
	
	
	# Récupérer dimension
	#lignedim = get_node("CanvasLayer/AspectRatioContainer/Line").get_position()
	
	# Design
	# Ajout Colonne 
	for i in nums_touches.size():
		var colonne = colonne_template.instantiate();
		colonne.set_position(Vector2(500 + i * 300 - colonne.size.x/2 + note_size.x/2,0))
		$CanvasLayer.add_child(colonne)
		var touchecolonne = touche_template.instantiate();
		var text = touchecolonne.get_node("texte")
		text.text = noms_touches.find_key(i)
		touchecolonne.set_position(Vector2(500 + i * 300 - colonne.size.x/2 + note_size.x/2,0))
		$CanvasLayer.add_child(touchecolonne)

	lignedim = get_node("CanvasLayer/Line").get_position()
	
	# Lancement au menu
	if !audio_manager.get_hasBeenInit():
		audio_manager.initialiser()
	audio_manager.activer_musique_menu()
	
func _process(_delta):
	if (pause_legal):
		if (Input.is_action_just_pressed("pause")):
			partition.lachement = false
			print("pause")
			pause_legal = false
			hud.activate_pause_menu()
			get_tree().paused = true
			
	var touches = []
	for touche in nums_touches.keys():
		if (Input.is_action_just_pressed(touche)):
			touches.append(touche)
	if touches!=[]:
		#print("touches : " + str(touches))
		tester_touche(touches)
	
	if (Input.is_action_just_pressed("quitter")):
		get_tree().quit()
	
	
	
func init_lancement_partie(lev):
	pause_legal = false
	init_data()
	continue_game()
	debut_partition(lev)
	

# Retourne un tableau comptenant les noms et scores
func load_score():
	var tabScore = []
	var file = FileAccess.open("res://TabScore.txt",FileAccess.READ)
	var content = file.get_as_text()
	content = content.strip_escapes()
	content.split(",",true)
	tabScore = convert_string_to_tab(content)
	var loaded = []
	print(tabScore,"taille : ",tabScore.size())
	for i in range (0,tabScore.size()):
		var text = tabScore[i]
		text= text.split(":",true)
		loaded.append([text[0],float(text[1])])
	loaded.sort()
	for i in range (0,tabScore.size()):
		print(i,loaded[i][0], loaded[i][1])
	return loaded

func tab_score_to_string(tab):
	var text ="["
	for i in range (0,tab.size()-1):
		text += tab[i][0] + " : " + str(tab[i][1]) + ""","""
	text += """""" + tab[tab.size()-1][0] + " : " + str(tab[tab.size()-1][1]) + "]"
	return text
	
func sort_perso(a, b):
	if b[1] < a[1]:
		return true
	return false

func save_score(nom:String, score:int):
	var tabScore = load_score()
	tabScore.append([nom,score])
	tabScore.sort_custom(sort_perso)
	tabScore.resize(3)
	print(tab_score_to_string(tabScore)," post tri")
	
	var file = FileAccess.open("res://TabScore.txt", FileAccess.WRITE)
	var text := """"""
	
	text = tab_score_to_string(tabScore)
	print("a ajouter : " + text)
	assert(file.is_open())
	file.store_string(text)
	return tabScore
	#file.close()

func tester_touche(nom_touches):
	for nom_touche in nom_touches:
		# On enlève les notes qui sont sorties de l'écran
		var non_vide = false
		while (liste_note!=[]) :
			for item in liste_note[0]:
				if (!is_instance_valid(item)||item==null):
					liste_note[0].erase(item)
				else :
					non_vide = true
			if liste_note[0] == []:
				liste_note.erase([])
			if (non_vide): break
		
		# On regarde s'il y a bien une note correspondante à la touche préssée
		var trouve = false # si toujours à false, mauvaise touche appuyée donc perte combo
		if (liste_note!=[]):
			for n in liste_note[0]:
				if n.get_num_touche() == nums_touches.get(nom_touche):
					var valide = noter_action(n.get_temps_ecart(),n.get_point())
					n.attrape(valide) # si la touche est pas déjà sortie de l'écran
					liste_note[0].erase(n)     
					
					trouve = true
					break
			if trouve == false:
				reset_combo()
				hud.update_score(tot_point,combo)


func ajouter_note(liste_num,couleur:Color=Color.WHITE,point:int=1):
	
	var l = []
	for num in liste_num:
		var note = note_template.instantiate()	
		note.apparition(num,lignedim.y,couleur,point)
		l.append(note)
		add_child(note)
	liste_note.append(l)
	
func init_data():
	combo = 0
	tot_point = 0
	get_tree().call_group("note","queue_free")
	liste_note = []
	hud.update_score(tot_point,combo)

func convert_string_to_tab(ch:String):
	ch = ch.replace("[","")
	ch = ch.replace("]\n","")
	
	return ch.split(",", true)


func debut_partition(level:int=0):
	init_data()
	
	if partition != null:
		remove_child(partition)
		partition.queue_free()
	partition = partition_template.instantiate()
	partition.init(self,audio_manager,hud)
	add_child(partition)
	EffetReplay.play()
	await audio_manager.activer_transition()
	partition.start_musique_from_part(level)
	

	
# return true si l'action est valide, false sinon
func noter_action(t,point:int=1):
	var valide:bool = true
	if t > 0.15 :
		hud.add_comment("bad")
		valide = false
		reset_combo()
	elif t < 0.07:
		hud.add_comment("perfect")
		combo += 1
		tot_point += point*combo 
	else :
		hud.add_comment("cool")
		reset_combo()
		tot_point += point
	hud.update_score(tot_point,combo)#.text = "points : " + str(tot_point) + "	x" +str(combo) 
	return valide
	
func reset_combo():
	combo = 0
	hud.update_score(tot_point,combo)

func continue_game():
	get_tree().paused = false

func set_liste_note(ln):
	liste_note = ln

# musique :
# we wish you a merry  : Music by <a href="https://pixabay.com/fr/users/white_records-32584949/?utm_source=link-attribution&utm_medium=referral&utm_campaign=music&utm_content=172818">Maksym Dudchyk</a> from <a href="https://pixabay.com//?utm_source=link-attribution&utm_medium=referral&utm_campaign=music&utm_content=172818">Pixabay</a>
# carrols of the bells : Music by <a href="https://pixabay.com/fr/users/white_records-32584949/?utm_source=link-attribution&utm_medium=referral&utm_campaign=music&utm_content=171731">Maksym Dudchyk</a> from <a href="https://pixabay.com//?utm_source=link-attribution&utm_medium=referral&utm_campaign=music&utm_content=171731">Pixabay</a>
