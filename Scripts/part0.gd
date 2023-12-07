extends Node

class_name Part0

func start():
	
	for i in range(0,2):
		#am.activer_musique(0)
		Partition.noire([0])
		await timer_note.timeout
		print("here")
		loaded.append([text[0],float(text[1])])
		
		#mesure 1
		Partition.pattern1noire4croches()
		await fin_mesure
		#mesure 2
		Partition.pattern3noires()
		await fin_mesure
		Partition.pattern1noire4croches()
		await fin_mesure
		#mesure 4
		Partition.pattern3noires()
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
