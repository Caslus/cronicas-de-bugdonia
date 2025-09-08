extends Control

@onready var healthBar: PanelContainer = $Bar/CurrentHealth
var maxHealth: float
var health: float

func textFormat(text: String) -> String:
	return "%s : %.0f / %.0f" % [text, health, maxHealth]

func setup(newMaxHealth: float, text: String) -> void:
	self.maxHealth = newMaxHealth
	self.health = newMaxHealth
	$Label.text = textFormat(text)

func setHealth(newHealth: float) -> void:
		health = newHealth
		healthBar.custom_minimum_size.x = (health / maxHealth) * self.size.x
		$Label.text = textFormat($Label.text.split(" : ")[0])
