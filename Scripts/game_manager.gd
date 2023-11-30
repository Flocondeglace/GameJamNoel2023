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

var nums_touches = {"capturera": 0, "capturerb": 1, "capturec": 2}
var nums_touches_creation = {"creationa": 0,"creationb": 1,"creationc": 2}
var noms_touches = {"Q": 0, "G": 1, "M": 2}

# Dimension
var lignedim

# Pour créer des pistes !
var creation_mod:bool
var liste_note_creer
var temps_prec
#var timers_touche

# Tester les créations !
var test_creation_mod:bool
var t1
var t2
var t3

# Partition en cours 
var partition


# Called when the node enters the scene tree for the first time.
func _ready():
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
		var textetouche = touche_template.instantiate();
		textetouche.text = noms_touches.find_key(i)
		textetouche.set_position(Vector2(500 + i * 300 - colonne.size.x/2 + note_size.x/2,0))
		$CanvasLayer.add_child(textetouche)
	
	# Debut partie
	#start_musique()
	
	## creation mod
#	creation_mod = false
	
	liste_note_creer = []
	temps_prec = []
	#timers_touche = []
	for touche in nums_touches_creation.size():
		liste_note_creer.append([])
		temps_prec.append(Time.get_ticks_msec())
		#var timer_creation = new Timer 
		#add_child(timer_creation)
		#timers_touche.append(Time.get_ticks_msec())
#	if (creation_mod):
#		audio_manager.activer_musique(0)
	## test mod
#	test_creation_mod = false
#	if (test_creation_mod):
#		start_musique_from_data("res://Test")
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	for touche in nums_touches.keys():
		tester_touche(touche)
	
	#if (Input.is_action_just_pressed("pop")):
	#	start_musique()
	
	if (Input.is_action_just_pressed("quitter")):
		get_tree().quit()
	
	if (Input.is_action_just_pressed("pause")):
		get_tree().paused = true
		hud.activate_pause_menu()
	
	if (creation_mod):
		creer()
	

func creer():
	if (Input.is_action_just_pressed("fin_creation")):
		creation_mod = false
		fin()
	
	for touche in nums_touches_creation.keys():
		if (Input.is_action_just_pressed(touche)):
			liste_note_creer[nums_touches_creation[touche]].append(Time.get_ticks_msec() - temps_prec[nums_touches_creation[touche]])
			temps_prec[nums_touches_creation[touche]]=Time.get_ticks_msec()
			#timers_touche[nums_touches_creation[touche]].start()

func fin():
	for i in range(0,3):
		var file = FileAccess.open("res://Test"+str(i), FileAccess.WRITE)
		var __text := """"""
		__text+=str(liste_note_creer[i])
		assert(file.is_open())
		file.store_string(__text)
		file.close()

# Retourne un tableau comptenant les noms et scores
func load_score():
	var tabScore = []
	var file = FileAccess.open("res://TabScore.txt",FileAccess.READ)
	var content = file.get_as_text()
	content.strip_escapes()
	content.split(",",true)
	tabScore = convert_string_to_tab(content)
	var loaded = []
	print(tabScore,"taille : ",tabScore.size())
	for i in range (0,tabScore.size()):
		var text = tabScore[i]
		text= text.split(" : ",true)
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

func tester_touche(nom_touche):
	if (Input.is_action_just_pressed(nom_touche)):
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
	# Récupérer dimension
	lignedim = get_node("CanvasLayer/Line").get_position()
	
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
	liste_note = []
	hud.update_score(tot_point,combo)

func convert_string_to_tab(ch:String):
	ch = ch.replace("[","")
	ch = ch.replace("]\n","")
	
	return ch.split(",", true)

#func start_musique_from_data(nom:String="res://Test"):
#	init_data()
#	audio_manager.activer_musique(0)
#	var tab = []
#
#	for i in range(0,3):
#		var file = FileAccess.open(nom+str(i), FileAccess.READ)
#		var content = file.get_as_text()
#		tab.append(convert_string_to_tab(content))
#		file.close()
#
#
#	t1 = Timer.new()
#	add_child(t1)
#	t1.start(tab[0][0])
#	t2 = Timer.new()
#	add_child(t2)
#	t2.start(tab[1][0])
#	t3 = Timer.new()
#	add_child(t3)
#	t3.start(tab[2][0])
#
#	tab[0].remove_at(0)
#	tab[1].remove_at(0)
#	tab[2].remove_at(0)
#	start_milieu(tab[1])
#	start_gauche(tab[0])
#	start_droite(tab[2])

#func start_gauche(t):
#	for tmp in t :
#		creer_note_temps(tmp/1000,[0],Color.WHITE,1,t1)
#		await t1.timeout
#
#func start_droite(t):
#	for tmp in t :
#		creer_note_temps(tmp/1000,[2],Color.WHITE,1,t3)
#		await t3.timeout
#
#func start_milieu(t):
#	for tmp in t :
#		creer_note_temps(tmp/1000,[1],Color.WHITE,1,t2)
#		await t2.timeout

#func restart_musique():
#
#	audio_manager.desactiver_musique(0)
#	for l in liste_note :
#		for note in l :
#			remove_child(note)
#	start_musique()

func debut_partition():
	for l in liste_note :
		for note in l :
			remove_child(note)
	if partition != null:
		remove_child(partition)
		partition.queue_free()
	#partition = Partition.new(self,audio_manager,hud)
	partition = partition_template.instantiate()
	partition.init(self,audio_manager,hud)
	add_child(partition)
	partition.start_musique()

	
# return true si l'action est valide, false sinon
func noter_action(t,point:int=1):
	var valide:bool = true
	$Timing.text = str(t)
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

func continue_game():
	get_tree().paused = false

# musique :
# we wish you a merry  : Music by <a href="https://pixabay.com/fr/users/white_records-32584949/?utm_source=link-attribution&utm_medium=referral&utm_campaign=music&utm_content=172818">Maksym Dudchyk</a> from <a href="https://pixabay.com//?utm_source=link-attribution&utm_medium=referral&utm_campaign=music&utm_content=172818">Pixabay</a>
# carrols of the bells : Music by <a href="https://pixabay.com/fr/users/white_records-32584949/?utm_source=link-attribution&utm_medium=referral&utm_campaign=music&utm_content=171731">Maksym Dudchyk</a> from <a href="https://pixabay.com//?utm_source=link-attribution&utm_medium=referral&utm_campaign=music&utm_content=171731">Pixabay</a>
