extends Node2D

class_name Partition

# Templates
var partition_template = preload("res://Scenes/partition.tscn")
var note_template = preload("res://Scenes/note.tscn")

var gm
var am
var hud
var timer_note
var timer_silence
#var timer_between_note
var scene_partition
var tempo :int = 60
var tmax

#signal envoyé quand une mesure a fini de spawn
signal fin_mesure

func init(game_m,audio_m,vhud):
	gm = game_m
	am = audio_m
	hud = vhud
	#scene_partition = partition_template.instantiate()
	timer_note = get_node("Timer")
	timer_silence = Timer.new()
	add_child(timer_silence)

func charger_partition(level:int=0):
	var lignedim = gm.get_node("CanvasLayer/Line").get_position()
	var liste_note = []
	var file = FileAccess.open("res://part0.txt",FileAccess.READ)
	var nb_notes = 0
	var content = file.get_as_text()
	content = content.strip_escapes()
	content = content.split(";",true)
	var tl = []
	
	for i in range (0,content.size()):
		#print(content[i])
		#print((content[i]).split(":",false))
		var t_ns = (content[i]).split(":",false)
		#print("t_ns : ")
		#print(t_ns)
		if (t_ns.size() == 2):
			var nl = (t_ns[1]).split(" ",true)
			var l = []
			for j in range(0,nl.size()):
				if float(nl[j]) != 0:
					var note = note_template.instantiate()
					note.creation(float(t_ns[0]),j-1,lignedim.y)
					#print(float(t_ns[0]))
					gm.add_child(note)
					l.append(note)
					nb_notes +=1
			liste_note.append(l)
			tl.append(float(t_ns[0]))
	tmax = tl[-1]
	print("tmax : "+str(tmax))
	print("nbnotes : "+str(nb_notes))
	return liste_note

func start_musique_from_part(level:int=0):
	gm.set_liste_note(charger_partition(level))
	am.activer_musique(level)
	get_tree().call_group("note","activer")
	await get_tree().create_timer(tmax).timeout
	save_score()
	
#poubelle
func start_musique(level:int=0):
	push_warning("level :"+str(level))
	#gm.init_data()
	am.activer_musique(level)
	#Part0.start()
	#$Musique.play()
	if (level==0):
		tempo = 60
		for i in range(0,2):
			#am.activer_musique(0)
			noire([0])
			await timer_note.timeout
			
			#mesure 1
			pattern1noire4croches()
			await fin_mesure
			#mesure 2
			pattern3noires()
			await fin_mesure
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
			await timer_note.timeout
		
		
		# Reprise
		#mesure 9
		noire([0])
		await timer_note.timeout
		#mesure 10
		pattern3noires()
		await fin_mesure
		#mesure 11
		pattern1blanche2noires()
		await fin_mesure
		

	#mesure 12
		pattern3noires()
		await fin_mesure
		#mesure 13
		pattern1blanche2noires()
		await fin_mesure
		#mesure 14
		pattern1noire4croches()
		await fin_mesure
		#mesure 15
		pattern2noirescroches()
		await fin_mesure
		#mesure 16
		pattern3noires()
		await fin_mesure
		#mesure 17
		blanche([0,1])
		await $Timer.timeout
		#Fin musique
	elif (level==1):
		tempo = 91 #185
		#push_warning("before silence")
		sil_noire()
		await timer_silence.timeout
		sil_noire()
		await timer_silence.timeout
		#push_warning("sortie fonction")
		#await timer_note.timeout
		#await finsilence
		#push_warning("after silence")
		#croche([0])
		#await timer_note.timeout
		for i in range (0,30):
			pattern_background2()
			await fin_mesure
	save_score()
	
func save_score():
	# Sauvegarder le score
	await get_tree().create_timer(1).timeout
	gm.pause_legal = false
	print("fin musique")
	var name:String = await hud.ask_for_name()
	var tab_score = gm.save_score(name,gm.tot_point)
	hud.print_liste_score(tab_score)
	

func pattern_background2():
	noire([0])
	await timer_note.timeout
	croche([0])
	await timer_note.timeout
	croche([0])
	await timer_note.timeout
	noire([0])
	await timer_note.timeout
	fin_mesure.emit()

func pattern1blanche2noires():
	blanche([0,1])
	await timer_note.timeout
	noire([0])
	await timer_note.timeout
	noire([0,1,2])
	await timer_note.timeout
	fin_mesure.emit()

func pattern3noires():
	noire([0,1])
	await timer_note.timeout
	noire([0])
	await timer_note.timeout
	noire([0])
	await timer_note.timeout
	fin_mesure.emit()
	

func pattern1noire4croches():
	noire([0,1])
	await timer_note.timeout
	croche([1])
	await timer_note.timeout
	croche([2])
	await timer_note.timeout
	croche([1])
	await timer_note.timeout
	croche([2])
	await timer_note.timeout
	fin_mesure.emit()

func pattern2noirescroches():
	noire([0,1])
	await timer_note.timeout
	noire([0])
	await timer_note.timeout
	croche([1])
	await timer_note.timeout
	croche([0])
	await timer_note.timeout
	fin_mesure.emit()

# ajoute la note et lance le chrono
# l : liste des notes (les différentes touches)
# t : temps avant le prochain cadeau (durée de la note)
# couleur : filtre appliqué sur le cadeau
func creer_note_temps(t,l,couleur:Color=Color.WHITE,point:int=1):#,timer_note:Timer=$Timer):
	gm.ajouter_note(l,couleur,point)
	#print("tmp note " + str(float(t)*60/tempo) + ", t :" + str(t))
	timer_note.start(float(t)*60/tempo)

func creer_silence(tmp):
	timer_silence.start(float(tmp)*60/tempo)

	
func sil_double_croche():
	creer_silence(0.25)
	
func sil_croche():
	creer_silence(0.5)
	

func sil_noire():
	creer_silence(1)

func double_croche(l):
	creer_note_temps(0.25,l,Color.BLACK,100)

func croche(l):
	creer_note_temps(0.5,l,Color.DARK_ORCHID,100)
	
func noire(l):
	creer_note_temps(1,l)
	
func blanche(l):
	creer_note_temps(2,l)
