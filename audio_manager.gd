extends Node2D

var musique_playing

func activer_musique(num):
	musique_playing = num
	get_child(num).play()
	pass
	
func desactiver_musique(num):
	get_child(num).stop()
	pass

func effacer(t:float):
	var musique = get_child(musique_playing)
	var timer = Timer.new()
	
	add_child(timer)
	var db = musique.get_volume_db()
	musique.set_volume_db(-80)
	timer.start(t)
	await timer.timeout
	print("censer redemarer")
	musique.set_volume_db(db)
	timer.queue_free()
	
