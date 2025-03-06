extends Area2D
signal card_selected 
@export var card_sprites:Array[Texture2D] = []

@onready var sprite_2d = $Sprite2D
@onready var animation_player = $AnimationPlayer
var card_id:int=-1
var card_sprite_number:int=0
var is_clickable = true

func set_card(id:int, sprite_number:int):
	card_id=id
	card_sprite_number=sprite_number

func fold():
	sprite_2d.texture=card_sprites[0]
	
func unfold():
	sprite_2d.texture = card_sprites[card_sprite_number]

func disappear():
	is_clickable=false
	animation_player.play("disappear")

	
# Called when the node enters the scene tree for the first time.
func _ready():
	sprite_2d.texture=card_sprites[1]


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if not is_clickable:
		return
	if event is InputEventMouseButton:
		if event.pressed and event.button_index ==MOUSE_BUTTON_LEFT:
			card_selected.emit(card_id)
