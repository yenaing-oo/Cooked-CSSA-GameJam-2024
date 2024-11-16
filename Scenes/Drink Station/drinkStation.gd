extends Node3D

@onready var in_range: bool = false
@onready var soda_one
@onready var soda_two

var fill_time = 5.0
var overflow_time = 5.0

class Soda:
    var node
    var fill_timer_node
    var overflow_timer_node

func _ready() -> void:
    soda_one = Soda.new()
    soda_one.node = $sodaCup1
    soda_one.fill_timer_node = $sodaCup1/fillTimer
    soda_one.overflow_timer_node = $sodaCup1/overflowTimer

    soda_two = Soda.new()
    soda_two.node = $sodaCup2
    soda_two.fill_timer_node = $sodaCup2/fillTimer
    soda_two.overflow_timer_node = $sodaCup2/overflowTimer

func _physics_process(_delta: float) -> void:
    if (in_range):
        if Input.is_action_just_pressed("interact"):
            create_soda()
        elif Input.is_action_just_pressed("pick_up"):
            pick_up_soda()

func create_soda() -> void:
    if (soda_one.node.is_visible_in_tree()):
        if (soda_two.node.is_visible_in_tree()):
            pass
        elif (!soda_two.node.is_visible_in_tree()):
            soda_two.node.visible = true
            soda_two.fill_timer_node.wait_time = fill_time
            soda_one.overflow_timer_node.wait_time = overflow_time
            soda_two.fill_timer_node.start()

    elif (!soda_one.node.is_visible_in_tree()):
        soda_one.node.visible = true
        soda_one.fill_timer_node.wait_time = fill_time
        soda_two.overflow_timer_node.wait_time = overflow_time
        soda_one.fill_timer_node.start()


func _soda_timeout(extra_arg_0: String) -> void:
    if (extra_arg_0 == "soda_one"):
        #soda_one.overflow_timer_node.wait_time = overflow_time
        soda_one.overflow_timer_node.start()

    elif (extra_arg_0 == "soda_two"):
        #soda_two.overflow_timer_node.wait_time = overflow_time
        soda_two.overflow_timer_node.start()

func pick_up_soda() -> void:
    var cup_picked_up = oldest_cup()
    cup_picked_up.visible = false

func oldest_cup() -> Node3D:
    var oldest_soda_cup = null
    var cup_one_time = null
    var cup_two_time = null

    if (soda_one.node.is_visible_in_tree()):
        if (soda_one.overflow_timer_node.is_stopped()):
            cup_one_time = soda_one.fill_timer_node.time_left + overflow_time
        else: 
            cup_one_time = soda_one.overflow_timer_node.time_left
    if (soda_two.node.is_visible_in_tree()):
        if (soda_two.overflow_timer_node.is_stopped()):
            cup_two_time = soda_two.fill_timer_node.time_left + overflow_time
        else: 
            cup_two_time = soda_two.overflow_timer_node.time_left

    if cup_one_time ==  null:
        if cup_two_time == null:
            return null
        oldest_soda_cup = soda_two.node
        return oldest_soda_cup
    elif cup_two_time == null:
        if cup_one_time == null:
            return
        oldest_soda_cup = soda_one.node
        return oldest_soda_cup

    if cup_one_time < cup_two_time:
        oldest_soda_cup = soda_one.node
    if cup_two_time < cup_one_time:
        oldest_soda_cup = soda_two.node
    
    return oldest_soda_cup

func _soda_overflow_timeout(extra_arg_0: String) -> void:
    if extra_arg_0 == "soda_one":
        soda_one.node.visible = false
    elif extra_arg_0 == "soda_two":
        soda_two.node.visible = false

func _on_area_3d_body_entered(body: Node3D) -> void:
    if body.name == "CharacterBody3D":
        in_range = true
        set_physics_process(true)

func _on_area_3d_body_exited(body: Node3D) -> void:
    if body.name == "CharacterBody3D":
        in_range = false
        set_physics_process(false)
