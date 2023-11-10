extends Node2D
#signal envoyé quand une mesure a fini de spawn
signal fin_mesure

# liste des tuiles des notes en cours de descente
var liste_note
#label -> à bouger dans hub
var label_point
var label_ecart
# Nombre total de point : différent suivant la performance
var tot_point

# Template
var note_template = preload("res://Scenes/note.tscn")

var nums_touches = {"capturera": 0, "capturerb": 1}

# Called when the node enters the scene tree for the first time.
func _ready():
	# Initialiser les listes
	liste_note = []
	# Initialiser variables
	tot_point = 0
	# Label
	label_ecart = $Ecart
	label_point = $Point
	label_point.text = "points : " + str(tot_point)
	
	# Debut partie
	debut_lacher_note()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	for touche in nums_touches.keys():
		tester_touche(touche)
	
	if (Input.is_action_just_pressed("pop")):
		debut_lacher_note()
	
	if (Input.is_action_just_pressed("quitter")):
		get_tree().quit()

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
		if (liste_note!=[]):
			for n in liste_note[0]:
				if n.get_num_touche() == nums_touches.get(nom_touche):
					n.attrape() # si la touche est pas déjà sortie de l'écran
					liste_note[0].erase(n)     
					noter_action(n.get_temps_ecart())
					break


func ajouter_note(liste_num):
	var l = []
	for num in liste_num:
		var note = note_template.instantiate()
		note.apparition(num)
		l.append(note)
		add_child(note)
	liste_note.append(l)
	
 
func debut_lacher_note():
	$Musique.play()
	for i in range(0,2):
		noire([0])
		await $Timer.timeout
		#mesure 1
		pattern1noire4croches()
		await fin_mesure
		#mesure 2
		pattern3noires()
		await fin_mesure
		#mesure 3
		pattern1noire4croches()
		await fin_mesure
		#mesure 4
		pattern3noires()
		await fin_mesure
		#mesure 5
		pattern1noire4croches()
		await fin_mesure
		#mesure 6
		pattern2noirescroches()
		await fin_mesure
		#mesure 7 
		pattern3noires()
		await fin_mesure
		#mesure 8
		blanche([0,1])
		await $Timer.timeout
	# Reprise
	#mesure 9
	noire([0])
	await $Timer.timeout
	#mesure 10
	pattern3noires()
	await fin_mesure
	#mesure 11
	pattern1blanche2noires()
	await fin_mesure
#	#mesure 12
#	pattern3noires()
#	await fin_mesure
#	#mesure 13
#	pattern1blanche2noires()
#	await fin_mesure
#	#mesure 14
#	pattern1noire4croches()
#	await fin_mesure
#	#mesure 15
#	pattern2noirescroches()
#	await fin_mesure
#	#mesure 16
#	pattern3noires()
#	await fin_mesure
#	#mesure 17
#	blanche([0,1])
#	await $Timer.timeout
	

func pattern1blanche2noires():
	blanche([0,1])
	await $Timer.timeout
	noire([0])
	await $Timer.timeout
	noire([0])
	await $Timer.timeout
	fin_mesure.emit()

func pattern3noires():
	noire([0,1])
	await $Timer.timeout
	noire([0])
	await $Timer.timeout
	noire([0])
	await $Timer.timeout
	fin_mesure.emit()
	

func pattern1noire4croches():
	noire([0,1])
	await $Timer.timeout
	croche([1])
	await $Timer.timeout
	croche([0])
	await $Timer.timeout
	croche([1])
	await $Timer.timeout
	croche([0])
	await $Timer.timeout
	fin_mesure.emit()

func pattern2noirescroches():
	noire([0,1])
	await $Timer.timeout
	noire([0])
	await $Timer.timeout
	croche([1])
	await $Timer.timeout
	croche([0])
	await $Timer.timeout
	fin_mesure.emit()

func creer_note_temps(t,l):
	ajouter_note(l)
	$Timer.start(t)

func croche(l):
	creer_note_temps(0.25,l)
	
func noire(l):
	creer_note_temps(1,l)
	
func blanche(l):
	creer_note_temps(2,l)

func noter_action(t):
	$Timing.text = str(t)
	if t > 0.4 :
		label_ecart.text = "bad"
	elif t < 0.1:
		label_ecart.text = "perfect"
		tot_point += 2
	else :
		label_ecart.text = "cool"
		tot_point += 1
	label_point.text = "points : " + str(tot_point)


# musique :
# we wish you a merry  : Music by <a href="https://pixabay.com/fr/users/white_records-32584949/?utm_source=link-attribution&utm_medium=referral&utm_campaign=music&utm_content=172818">Maksym Dudchyk</a> from <a href="https://pixabay.com//?utm_source=link-attribution&utm_medium=referral&utm_campaign=music&utm_content=172818">Pixabay</a>
# carrols of the bells : Music by <a href="https://pixabay.com/fr/users/white_records-32584949/?utm_source=link-attribution&utm_medium=referral&utm_campaign=music&utm_content=171731">Maksym Dudchyk</a> from <a href="https://pixabay.com//?utm_source=link-attribution&utm_medium=referral&utm_campaign=music&utm_content=171731">Pixabay</a>
