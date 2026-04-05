# SolarSystem.gd
extends Node2D
class_name SolarSystem

# Identifiers
var id : int
var star_name : String

# Properties
var connections : Array
var owned_by : int

# Contents
var worlds : Array

func add_connection(endpoint : SolarSystem) -> void:
	connections.append(endpoint)
