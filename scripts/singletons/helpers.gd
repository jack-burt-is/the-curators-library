extends Node

# Function to load all .tres files in the given directory
func load_all_resources(directory_path: String):
	var dir = DirAccess.open(directory_path)
	var resources = []
	
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			# Check if the file has a .tres extension
			if file_name.ends_with(".tres"):
				var file_path = directory_path + file_name
				# Load the resource and add it to the array
				var resource = load(file_path)
				if resource:
					resources.append(resource)
			# Get the next file
			file_name = dir.get_next()
	
	dir.list_dir_end()
	return resources
	
func array_to_string(arr: Array):
	var string = ""
	for item in arr:
		string += item.to_string()
		string += ", "
	
	return string.left(string.length() - 2)
