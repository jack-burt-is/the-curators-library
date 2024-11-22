class_name Book
extends Resource

enum Category {FICTION, NONFICTION}
enum Rights {PUBLIC, OBTAINED, FAKE}

## The title of the book (type String)
@export var title: String

## The author of the book (type String)
@export var author: String

## The release date of the book formatted YYYY-MM-DD (type String)
@export var released: String

## Fiction or non-fiction (type Category enum)
@export var category: Category

## The genre of the book (type Genre)
@export var genres: Array[Genre]

## The length of the book in pages (type int)
@export var length: int

## A popularity scale between 0 and 100 for how well the book will sell (type int)
@export var popularity: int

## A summary of the book (type String)
@export var synopsis: String

## The cost of the book to buy in the shop (type int)
@export var cost: int = 0

func _to_string() -> String:
	return title + " by " + author
