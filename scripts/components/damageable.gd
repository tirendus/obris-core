class_name Damageable
extends Node

signal died
signal damaged

var max_hp: int
var current_hp: int

func apply_damage(amount: int) -> void:
	if current_hp <= 0: return
	current_hp = max(current_hp - amount, 0)
	emit_signal("damaged")

	if is_dead():
		emit_signal("died")

func is_dead() -> bool:
	return current_hp <= 0
