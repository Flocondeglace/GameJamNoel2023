extends Button

class_name touche

var textglob

func activate_maj():
	self.text = self.text.to_upper()

func desactivate_maj():
	self.text = self.text.to_lower()

func _on_pressed():
	textglob.text += self.text
