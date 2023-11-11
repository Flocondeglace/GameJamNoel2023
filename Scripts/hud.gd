extends CanvasLayer

func update_score(score,combo):
	$Point.text = "score : " + str(score) + "x" + str(combo) 

func add_comment(texte):
	$Comment.text = texte
