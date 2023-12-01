extends Button

class_name touche

var textglob


func _on_pressed():
	textglob.text += self.text
