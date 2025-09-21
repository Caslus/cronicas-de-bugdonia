extends Node

@export var toBeClosed: Node

func onCloseButtonPressed():
    toBeClosed.queue_free()