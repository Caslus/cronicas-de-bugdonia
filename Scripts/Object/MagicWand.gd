extends Node2D

@onready var interactableNode = get_node("Interactable")
@onready var player: CharacterBody2D = get_node("../Player")
@onready var interactionManager: Node = player.get_node("InteractionManager")

func questUpdated():
  if QuestManager.getQuestVar("talked"):
    interactableNode.set("enableInteraction", true)

func onPickup(item):
  if item != self: return
  player.giveWand()
  QuestManager.toggleQuestVar("pickedWand")

func _ready():
  QuestManager.connect("questVariablesChanged", Callable(self, "questUpdated"))
  interactionManager.connect("pickup_item", Callable(self, "onPickup"))
