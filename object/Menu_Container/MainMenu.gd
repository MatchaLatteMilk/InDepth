extends Control

onready var light = get_node("Position2D/Light2D")
onready var pos2d = get_node("Position2D")
onready var menu = get_node("CanvasLayer/Menu")
onready var label = get_node("Label")

enum {MENU,STARTH,STARTS,TRANSH,TRANSS,MAIN}
var state setget set_state,get_state

var math = 1

func set_state(obj):
	state = obj

func get_state():
	return state

func _ready():
	set_state(MENU)

func _physics_process(delta):
	match state:
		MENU:
			menu_state(delta)
			label_loop(delta)
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

#SIGNAL CODE HERE
func _on_Back_Button_pressed():
	set_state(TRANSH)

func _on_Quit_pressed():
	get_tree().quit()

func _on_Start_pressed():
	pass # Replace with function body.

func _on_Load_pressed():
	pass # Replace with function body.

func _on_Credits_pressed():
	$CanvasLayer/Menu/Container.show()
	$CanvasLayer/Menu/Container/Credits.show()

func _on_Options_pressed():
	pass # Replace with function body.

#Container Signal Code
func _on_Container_back_button_pressed():
	$CanvasLayer/Menu/Container.hide()
