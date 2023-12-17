extends Node2D

class_name Partition

# Templates
var note_template = preload("res://Scenes/note.tscn")

var gm
var am
var hud
var scene_partition
var tempo :int = 60
var tmax
var tl
var notes

# lachement des notes
var tmp_origin_m
var tl0
var notes0
var lachement:bool = false

func init(game_m,audio_m,vhud):
	gm = game_m
	am = audio_m
	hud = vhud

func _process(delta):
	if lachement && tl0 != null:
		var tmp = float(Time.get_ticks_msec() - tmp_origin_m)/1000 
		if tl0 <= tmp:
			for note in notes0:
				note.activer()
			tl0 = tl.pop_back()
			notes0 = notes.pop_back()
	else :
		lachement = false

func charger_partition(level:int=0):
	
	var tempomod = level * (float(60)/46) + (1 - level) * (float(60)/60)
	
	var lignedim = gm.get_node("CanvasLayer/Line").get_position()
	var liste_note = []
	var file = FileAccess.open("res://part"+str(level)+".txt",FileAccess.READ)
	var nb_notes = 0
	var content = file.get_as_text()
	content = content.strip_escapes()
	content = content.split(";",true)
	tl = []
	
	for i in range (0,content.size()):
		var t_ns = (content[i]).split(":",false)
		
		if (t_ns.size() == 2):
			var nl = (t_ns[1]).split(" ",true)
			var l = []
			for j in range(0,nl.size()):
				if float(nl[j]) != 0:
					var note = note_template.instantiate()
					var coul = Color.ANTIQUE_WHITE
					var point = 1
					var effect = false
					if (randf_range(0,100) > 95):
						coul = Color.CRIMSON
						point = 50
						effect = true
					note.creation(float(t_ns[0]),j-1,lignedim.y,coul,point,effect)
					#print(float(t_ns[0]))
					gm.add_child(note)
					l.append(note)
					nb_notes +=1
			liste_note.append(l)
			tl.append(float(t_ns[0])*tempomod)
	tmax = tl[-1]
	#print("tmax : "+str(tmax))
	#print("nbnotes : "+str(nb_notes))
	gm.timing_notes = tl
	notes = liste_note.duplicate() 
	return liste_note

func start_musique_from_part(level:int=0):
	gm.pause_legal = false
	gm.set_liste_note(charger_partition(level))
	notes.reverse()
	tl.reverse()
	gm.pause_legal = true
	tl0 = tl.pop_back()
	notes0 = notes.pop_back()
	
	am.activer_musique(level)
	
	#await get_tree().create_timer(1.2).timeout ## a enlever
	tmp_origin_m = float(Time.get_ticks_msec())
	lachement = true
	await get_tree().create_timer(tmax + 3).timeout
	gm.pause_legal = false
	save_score()

	
func save_score():
	# Sauvegarder le score
	await get_tree().create_timer(1).timeout
	gm.pause_legal = false
	var nomjoueur:String = await hud.ask_for_name()
	var tab_score = gm.save_score(nomjoueur,gm.tot_point)
	hud.print_liste_score(tab_score)
