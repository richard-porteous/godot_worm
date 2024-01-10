extends Area2D

@export var tile_size = 80
@export var speed = 4
@export var facing = "right"
@onready var ray = get_node("RayCast2D")

var key_queue = []
var last_key_pressed = facing
var end_move_pos = Vector2.ZERO
var game_started = false

var inputs = {"down": Vector2.DOWN,
            "right": Vector2.RIGHT,
            "up": Vector2.UP,
            "left": Vector2.LEFT}
            
func _ready():
    position = position.snapped(Vector2.ONE * tile_size)
    position += Vector2.ONE * tile_size/2
    end_move_pos = position
    
func _unhandled_input(event):
    for dir in inputs.keys():
        if event.is_action_pressed(dir):
            game_started = true
            key_queue.append(dir)
            last_key_pressed = dir
        if event.is_action_released(dir):
            key_queue.erase(dir)
            #if last_key_pressed == dir and key_queue.is_empty():
                #last_key_pressed = facing
                

func _process(delta):
    var dir = facing

    if key_queue.is_empty():
        facing = last_key_pressed
    else:
        facing = key_queue[0]
    var dt_distance = tile_size * delta * speed

    if !game_started:
        return
    
    if is_end_of_move(dt_distance):
        position = end_move_pos
        end_move_pos += inputs[dir]

    move(facing,dt_distance)
    

func is_end_of_move(dt_distance):
    return position.distance_to(end_move_pos) <= abs(dt_distance)
    

func move(dir, dt_distance):
    position += inputs[dir] * dt_distance

#func move(dir):
    #ray.target_position = inputs[dir] * tile_size
    #ray.force_raycast_update()
    #if !ray.is_colliding():
        ##position += inputs[dir] * tile_size
        #var tween = create_tween()
        #tween.tween_property(self, "position",
            #position + inputs[dir] *    tile_size, 1.0/animation_speed).set_trans(Tween.TRANS_LINEAR)
        #moving = true
        #await tween.finished
        #moving = false
