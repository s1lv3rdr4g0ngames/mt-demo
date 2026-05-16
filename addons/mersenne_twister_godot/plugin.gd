@icon("icon.svg")
@tool
extends EditorPlugin
const AUTOLOAD_NAME = "MTRand"

func _enable_plugin() -> void:
	add_autoload_singleton(AUTOLOAD_NAME, "res://addons/mersenne_twister_godot/mersenne_twister_godot.gd")

func _disable_plugin() -> void:
	remove_autoload_singleton(AUTOLOAD_NAME)
