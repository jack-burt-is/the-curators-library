class_name Book
extends Resource

## The title of the book (type String)
@export var title: String

## The author of the book (type String)
@export var author: String

## The release date of the book formatted YYYY-MM-DD (type String)
@export var released: String

## The genre of the book (type Genre)
@export var genre: Genre

## The cost of the book in coins (type int)
@export var cost: int

## A popularity scale between 0 and 100 for how well the book will sell (type int)
@export var popularity: int

## A summary of the book (type String)
@export var synopsis: String
