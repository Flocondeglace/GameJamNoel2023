extends CanvasLayer

func update_score(score,combo):
	$Container/Combo.text = "x" + "[b]" + str(combo) + "[/b]"
	$Container/Point.text = "score : " + str(score)

func add_comment(texte):
	$Comment.text = texte
