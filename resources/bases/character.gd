class_name Character
extends Resource

## Character's name (type String)
@export var name: String

## The book they are seeking (type Book)
@export var favourite_book: Book

## Any recommendations the player has previously given them (type Array[Book])
@export var previous_recommendations: Array[Book] = []

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

## The character's line if you have found them their favourite book
@export var success_line: String

func get_feedback(positivity: int) -> String:
	match positivity:
		0:
			return "not my favourite"
		1:
			return "okay"
		2:
			return "good"
		_:
			return "great"

func get_dialogic_start():
	return name.to_lower() + "(Neutral): "

func generate_dialogic_timeline() -> DialogicTimeline:
	intro_line = intro_line	
	var success = false
	var events : Array[String]
	
	# NPC Dialog Consruction
	if previous_recommendations.size() == 0:
		events.append(get_dialogic_start() + intro_line)
	elif previous_recommendations[-1] == favourite_book:
		success = true
		events.append(get_dialogic_start() + success_line)
		events.append_array("""
			[signal arg="perfect_book_given_{name}"]
			[signal arg="leave_{name}"]
		""".format({"name": name}).split('\n'))
	else:
		var positivity = 0
		for genre in favourite_book.genres:
			if previous_recommendations[-1].genres.has(genre):
				positivity += 1
			
		events.append(get_dialogic_start() + previous_book_line.format({"book": previous_recommendations[-1].title, "feeling": get_feedback(positivity)}))
	
	if not success:
		if previous_recommendations.size() < hints.size():
			events.append(get_dialogic_start() + hints[previous_recommendations.size()].hint)
		else:
			events.append(get_dialogic_start() + no_more_hints_line)
		
		# Player choice construction
		var choices = """
			- I think I have just the book, bear with me one moment
				{dialogic_start}Thank you!
			- I know just the book but need to order it in, would you mind coming back tomorrow?
				{dialogic_start}No problem, I'll see you tomorrow. 
				[signal arg="leave_{name}"]
			""".format({"dialogic_start": get_dialogic_start(), "name": name}).split('\n')
		
		if GameManager.data.selected_book != null:
			choices.append_array("""
			- Here, try this one [Give current book]
				{dialogic_start}Thank you! 
				[signal arg="book_given_{name}"]
				[signal arg="leave_{name}"]
			""".format({"dialogic_start": get_dialogic_start(), "name": name}).split('\n')
		)

		events.append_array(choices)
	
	var timeline : DialogicTimeline = DialogicTimeline.new()
	timeline.events = events
	
	return timeline
