extends Control

onready var light = get_node("Position2D/Light2D")
onready var pos2d = get_node("Position2D")
onready var menu = get_node("CanvasLayer/Menu")
onready var label = get_node("Label")
onready var menusound = get_node("MenuSound")
onready var clicksound = get_node("ClickSound")

enum {MENU,STARTH,STARTS,TRANSH,TRANSS,MAIN,MOVE}
var state setget set_state,get_state

var math = 1

func set_state(obj):
	state = obj

func get_state():
	return state

func _ready():
	set_state(MENU)
	menusound.play()
	$Scene_Change.hide()

func _physics_process(delta):
	menusound_check()
	match state:
		MENU:
			menu_state(delta)
			label_loop(delta)
			menusound_trigger()
		STARTH:
			start_state(1,delta)
		STARTS:
			start_state(2,delta)
		TRANSH:
			transition_state(1,delta)
		TRANSS:
			transition_state(2,delta)
		MAIN:
			main_state()
		MOVE:
			move_state(delta)

func menu_state(delta):
	light_animation(delta)

func start_state(obj,delta):
	match obj:
		1:
			#HIDELIGHT
			light.scale.x -= delta
			light.scale.y -= delta
			if light.scale.x <= 0:
				set_state(TRANSS)
		2:
			#SHOWLIGHT
			light.scale.x += delta
			light.scale.y += delta
			if light.scale.x >= 2:
				set_state(MENU)

func transition_state(obj,delta):
	match obj:
		1:
			#HIDEUI
			menu.modulate.a -= delta
			if menu.modulate.a <= 0:
				menu.hide()
				set_state(STARTS)
		2:
			#SHOWUI
			menu.show()
			menu.modulate.a += delta
			if menu.modulate.a >= 1:
				set_state(MAIN)

func main_state():
	pass

func move_state(delta):
	var t = $Scene_Change
	t.show()
	t.modulate.a += delta
	if t.modulate.a >= 1:
		get_tree().change_scene("res://object/World_Container/Super_World.tscn")

func menusound_check():
	if state != MENU and state != STARTH:
		menusound.stop()

func menusound_trigger():
	if menusound.playing != true:
		menusound.play()

func light_animation(delta):
	var scale = rand_range(light.scale.x-delta,light.scale.x+delta)
	light.scale.x = scale
	light.scale.y = scale

func label_loop(delta):
	label.modulate.a += math * delta
	if label.modulate.a <= 0:
		math = 1
	if label.modulate.a >= 1:
		math = -1

func _input(event):
	if event is InputEventScreenTouch and event.is_pressed() and state == MENU:
		set_state(STARTH)

func hide_UI():
	var UI = get_tree().get_nodes_in_group("UI")
	for n in UI:
		n.hide()


#SIGNAL CODE HERE
func _on_Back_Button_pressed():
	set_state(TRANSH)

func _on_Quit_pressed():
	get_tree().quit()

func _on_Start_pressed():
	clicksound.play()
	set_state(MOVE)

func _on_Load_pressed():
	clicksound.play()
	pass # Replace with function body.

func _on_Credits_pressed():
	clicksound.play()
	hide_UI()
	$CanvasLayer/Menu/Container.show()
	$CanvasLayer/Menu/Container/Credits.show()

func _on_Options_pressed():
	clicksound.play()
	hide_UI()
	$CanvasLayer/Menu/Container.show()
	$CanvasLayer/Menu/Container/Options.show()

#Container Signal Code
func _on_Container_back_button_pressed():
	$CanvasLayer/Menu/Container.hide()

func _on_Vsync_pressed():
	clicksound.play()
	if OS.vsync_enabled:
		OS.vsync_enabled = false
	else:
		OS.vsync_enabled = true
