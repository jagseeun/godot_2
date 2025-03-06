extends Node2D

const ROW = 4
const COLUMN = 4
const SIZE_X = 128
const SIZE_Y = 128
const SPACE = 4
const MARGIN_TOP = 10

@onready var audio_player: AudioStreamPlayer2D = $audio_player
@onready var timer: Timer = $Timer
@onready var label_time: Label = $CanvasLayer/LabelTime
@export var game_timer=50
@onready var label_game_over: Label = $CanvasLayer/LabelGameOver
@onready var button_replay: Button = $CanvasLayer/ButtonReplay

var card_scene:PackedScene = preload("res://card.tscn")
var card_sprite_list:Array[int]=[]

var card_list:Array[Area2D]=[]

var first_card_id = -1
var second_card_id = -1
var matched_count=0

# 게임이 끝났는지 여부를 나타내는 변수
var is_game_over = false

# Called when the node enters the scene tree for the first time.
func _ready():
	create_cards()
	create_card_sprite_list()
	initialize_card()
	initialize_game()

func initialize_game():
	label_game_over.hide()
	button_replay.hide()
	label_time.text="Time : "+str(game_timer)
	timer.start()

# 게임 종료 처리
func end_game(end_message:String):
	is_game_over = true  # 게임 종료 설정
	label_game_over.text=end_message
	label_game_over.show()
	button_replay.show()
	timer.stop()

func check_game_over():
	matched_count+=2
	print("matched : %d"%matched_count)
	if matched_count == card_list.size():
		end_game("You win!")

func initialize_card():
	card_sprite_list.shuffle()
	for i in card_list.size():
		var card_sprite_number=card_sprite_list[i]
		var card= card_list[i]
		card.set_card(i, card_sprite_number)
		card.fold()
		card.connect("card_selected",_on_card_selected)

func have_same_image(first_id, second_id):
	var first_sprite= card_list[first_id].card_sprite_number
	var second_sprite=card_list[second_id].card_sprite_number
	return first_sprite==second_sprite

# 카드 선택 함수
func _on_card_selected(card_id):
	# 게임이 끝났다면 카드 선택을 막음
	if is_game_over:
		return

	if card_id == first_card_id or card_id==second_card_id:
		audio_player.play_sound(audio_player.SoundType.WRONG)
		return

	card_list[card_id].unfold()

	if first_card_id == -1:
		first_card_id=card_id
		audio_player.play_sound(audio_player.SoundType.TOUCH)
		return

	if second_card_id==-1:
		second_card_id=card_id
		if have_same_image(first_card_id, second_card_id):
			card_list[first_card_id].disappear()
			card_list[second_card_id].disappear()
			first_card_id=-1
			second_card_id=-1
			audio_player.play_sound(audio_player.SoundType.CORRECT)
			check_game_over()
		else:
			audio_player.play_sound(audio_player.SoundType.WRONG)
		return
	card_list[first_card_id].fold()
	card_list[second_card_id].fold()
	first_card_id = card_id
	second_card_id=-1
	audio_player.play_sound(audio_player.SoundType.TOUCH)

func create_card_sprite_list():
	for card_num in range(1,9):
		card_sprite_list.append(card_num)
		card_sprite_list.append(card_num)

func create_cards():
	var total_width= SIZE_X *COLUMN +SPACE*(COLUMN-1)
	var total_height=SIZE_Y*ROW+SPACE*(ROW-1)

	var start_x = get_viewport().size.x/2 - total_width/2 
	var start_y = get_viewport().size.y/2 - total_height/2 +MARGIN_TOP

	for x_pos in COLUMN:
		for y_pos in ROW:
			var new_card = card_scene.instantiate()
			new_card.global_position.x = start_x + x_pos * (SIZE_X + SPACE) + SIZE_X / 2
			new_card.global_position.y = start_y + y_pos * (SIZE_Y + SPACE) + SIZE_Y / 2 
			add_child(new_card)
			card_list.append(new_card)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

# 타이머가 끝날 때 호출되는 함수
func _on_timer_timeout():
	game_timer-=1
	label_time.text="Time : "+str(game_timer)
	if game_timer==0:
		end_game("You lose")

func _on_button_replay_pressed() -> void:
	get_tree().change_scene_to_file("res://game.tscn")
