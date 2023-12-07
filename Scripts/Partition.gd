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

func init(game_m,audio_m,vhud):
	gm = game_m
	am = audio_m
	hud = vhud

func charger_partition(level:int=0):
	
	var lignedim = gm.get_node("CanvasLayer/Line").get_position()
	var liste_note = []
	var file = FileAccess.open("res://part"+str(level)+".txt",FileAccess.READ)
	var nb_notes = 0
	var content = file.get_as_text()
	content = content.strip_escapes()
	content = content.split(";",true)
	var tl = []
	
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
			tl.append(float(t_ns[0]))
	tmax = tl[-1]
	print("tmax : "+str(tmax))
	print("nbnotes : "+str(nb_notes))
	gm.timing_notes = tl
	return liste_note

func start_musique_from_part(level:int=0):
	gm.pause_legal = false
	gm.set_liste_note(charger_partition(level))
	am.activer_musique(level)
	gm.pause_legal = true
	get_tree().call_group("note","activer")
	await get_tree().create_timer(tmax).timeout
	gm.pause_legal = false
	save_score()

	
func save_score():
	# Sauvegarder le score
	await get_tree().create_timer(1).timeout
	gm.pause_legal = false
	print("fin musique")
	var name:String = await hud.ask_for_name()
	var tab_score = gm.save_score(name,gm.tot_point)
	hud.print_liste_score(tab_score)
