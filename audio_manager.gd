extends Node2D

var musique_playing: String = "Menu"


func desactiver_reste():
	for m in get_children():
		m.stop()

func activer_musique_menu():
	desactiver_reste()
	get_node("Menu").play()

func activer_transition():
	desactiver_reste()
	var trans = get_node("TransitionSfx")
	trans.play()
	await trans.finished

func activer_musique(num):
	push_warning("num musique : "+str(num))
	#activer_transition()
	desactiver_reste()
	musique_playing = "Musique"+str(num)
	push_warning("nom : Musique"+str(num))
	get_node("Musique"+str(num)).play()
	
func desactiver_musique(num):
	get_child(num).stop()

func effacer(t:float):
	var musique = get_node(musique_playing)

	var db = musique.get_volume_db()
	musique.set_volume_db(-80)
	
	await get_tree().create_timer(t).timeout
	print("censer redemarer")
	musique.set_volume_db(db)
	
