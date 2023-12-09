extends Node2D

var musique_playing: String = "Menu"
var menu
var chooselevel
var transition
var level
var hasBeenInit = false

func initialiser():
	menu = $MenuBackground
	transition = get_node("TransitionSfx")
	level = []
	for node in get_children():
		if node.is_in_group("levelmusique"):
			level.append(node)
	hasBeenInit = true
	
func get_hasBeenInit():
	return hasBeenInit

func desactiver_reste():
	for m in get_children():
		m.stop()

func activer_musique_menu():
	desactiver_reste()
	if menu == null:
		initialiser()
	else :
		menu.play()

func activer_transition():
	desactiver_reste()
	transition.play()
	await transition.finished

func activer_musique(num):
	desactiver_reste()
	level[num-1].play()
	#push_warning("num musique : "+str(num))
	#activer_transition()
#	desactiver_reste()
#	musique_playing = "Musique"+str(num)
#	push_warning("nom : Musique"+str(num))
#	get_node("Musique"+str(num)).play()
	
func desactiver_musique(num):
	get_child(num).stop()

func activate_choose_level(b:bool=true):
	desactiver_reste()
	if b :
		menu.play()
	else :
		menu.stop()
	
