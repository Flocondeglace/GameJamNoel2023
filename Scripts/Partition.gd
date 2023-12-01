extends Node2D

class_name Partition

# Templates
var partition_template = preload("res://Scenes/partition.tscn")

var gm
var am
var hud
var timer_note
var scene_partition

#signal envoyé quand une mesure a fini de spawn
signal fin_mesure

func init(game_m,audio_m,vhud):
	gm = game_m
	am = audio_m
	hud = vhud
	#scene_partition = partition_template.instantiate()
	timer_note = get_node("Timer")
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func start_musique():
	gm.init_data()
	am.activer_musique(0)
	#$Musique.play()
	for i in range(0,2):
		noire([0])
		await timer_note.timeout
		print("here")
		
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
	#Fin musique
	
	# Sauvegarder le score
	gm.pause_legal = false
	var name:String = await hud.ask_for_name()
	var tab_score = gm.save_score(name,gm.tot_point)
	hud.print_liste_score(tab_score)



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
	timer_note.start(t)

func croche(l):
	creer_note_temps(0.25,l,Color.DARK_ORCHID,100)
	
func noire(l):
	creer_note_temps(1,l)
	
func blanche(l):
	creer_note_temps(2,l)
