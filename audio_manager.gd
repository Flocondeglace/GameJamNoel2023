extends Node2D

func activer_musique(num):
	get_child(num).play()
	pass
	
func desactiver_musique(num):
	get_child(num).stop()
	pass
