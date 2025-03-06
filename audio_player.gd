extends AudioStreamPlayer2D

@export var touch_sound:AudioStream=preload("res://audio/touch_card.wav")
@export var correct_sound:AudioStream=preload("res://audio/correct_card.wav")
@export var wrong_sound:AudioStream = preload("res://audio/wrong_card.wav")

enum SoundType{
	TOUCH,
	CORRECT,
	WRONG
}
func play_sound(sound_type:SoundType):
	match sound_type:
		SoundType.TOUCH:
			stream= touch_sound
		SoundType.CORRECT:
			stream = correct_sound
		SoundType.WRONG:
			stream = wrong_sound
	play()
