# union.gd
extends Node
class_name Union

var parent : Array

func _init(size : int) -> void:
	parent = range(size)

func find(i : int = 0) -> int:
	if parent[i] == i:
		return i
	
	return find(parent[i])

func unite(i, j):
	var irep : int = find(i)
	var jrep : int = find(j)
	
	parent[irep] = jrep
