extends Control

@export var tipLabel: Label
@export var tipText: RichTextLabel


func setTipLabel(tipLabelText: String):
		tipLabel.text = tipLabelText

func setTipText(newText: String):
	tipText.text = newText
