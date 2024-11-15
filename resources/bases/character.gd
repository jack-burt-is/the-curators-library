class_name Character
extends Resource

## Character's name (type String)
@export var name: String

## The book they are seeking (type Book)
@export var favourite_books: Array[Book] = []

## The number of favourite books the player has already recommended
@export var books_found: int = 0

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

## The character's line if you have found them their favourite book
@export var complete_line: String

## The rarity of a character's visit, 1 to 10, 1 being common, 10 being rare
@export var visit_rarity: int = 1

var have_spoken: bool = false

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
	
	# Skip the preamble if we've already spoken today
	if not have_spoken:
		# Never recommended anything before
		if books_found == 0 and previous_recommendations.size() == 0:
			events.append(get_dialogic_start() + intro_line)
			
		# Last time they were here we recommended a favourite
		elif previous_recommendations[-1] == favourite_books[books_found]:
			events.append(get_dialogic_start() + success_line)
			books_found += 1
			previous_recommendations.clear()
			GameManager.data.character_glossary.update_character(self)
			
		# Last time they were here we recommended a non-favourite
		else:
			var positivity = 0
			for genre in favourite_books[books_found].genres:
				if previous_recommendations[-1].genres.has(genre):
					positivity += 1
				
			events.append(get_dialogic_start() + previous_book_line.format({"book": previous_recommendations[-1].title, "feeling": get_feedback(positivity)}))
	
	# They're still looking for more books
	if not books_found >= favourite_books.size():
		var target_book = favourite_books[books_found]
		var relevant_hints = hints.filter(func(e):
			return e.book == target_book
		)[0].hints
		
		if previous_recommendations.size() < relevant_hints.size():
			events.append(get_dialogic_start() + relevant_hints[previous_recommendations.size()])
		else:
			events.append(get_dialogic_start() + no_more_hints_line)
		
		# Player choice construction
		var choices = """
			- I think I have just the book, hold on
				{dialogic_start}Thank you!
			""".format({"dialogic_start": get_dialogic_start(), "name": name}).split('\n')
		
		if GameManager.data.selected_book != null:
			choices.append_array("""
			- Here, try this one [GIVE CURRENT BOOK]
				{dialogic_start}Thank you! 
				[signal arg="book_given_{name}"]
				[signal arg="leave_{name}"]
			""".format({"dialogic_start": get_dialogic_start(), "name": name}).split('\n')
		)

		events.append_array(choices)
		
	# We've finished the character's arc
	else:
		events.append(get_dialogic_start() + complete_line)
		events.append_array("""
			[signal arg="character_finished_{name}"]
			[signal arg="leave_{name}"]
		""".format({"name": name}).split('\n'))
	
	var timeline : DialogicTimeline = DialogicTimeline.new()
	timeline.events = events.filter(func(e):
		return e != null and e.dedent() != ""
	)
	
	have_spoken = true
	
	return timeline
