class_name Character
extends Resource

## Character's name (type String)
@export var name: String

## The book they are seeking (type Book)
@export var favourite_book: Book

## Any recommendations the player has previously given them (type Array[Book])
@export var previous_recommendations: Array[Book]

## A list of hints towards the book they are after (type Array[Hint])
@export var hints: Array[Hint]

## The character's sprite frames for animation (type SpriteFrames)
@export var sprite_frames: SpriteFrames

## The character's first line of dialog when they introduce themselves (type String)
@export var intro_line: String

## The character's line of dialogue when providing feedback on previously recommended book. Use {book} to dynamically replace the book (type String)
@export var previous_book_line: String

## Out of hints line
@export var no_more_hints_line: String

func get_dialogic_start():
	return name.to_lower() + "(Neutral): "

func generate_dialogic_timeline() -> DialogicTimeline:
	var events : Array[String]
	if previous_recommendations.size() == 0:
		events.append(get_dialogic_start() + intro_line)
	else:
		events.append(get_dialogic_start() + previous_book_line.format({"book": previous_recommendations[-1]}))
	
	if previous_recommendations.size() < hints.size():
		events.append(get_dialogic_start() + hints[previous_recommendations.size()].hint)
	else:
		events.append(get_dialogic_start() + no_more_hints_line)

	var timeline : DialogicTimeline = DialogicTimeline.new()
	timeline.events = events
	
	return timeline
