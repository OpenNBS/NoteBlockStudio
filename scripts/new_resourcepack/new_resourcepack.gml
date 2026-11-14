function new_resourcepack(){
	var pack = create(obj_resource);

	pack.type = argument[0] //0 = Vanilla, 1 = zip file, 2 = Folder
	pack.filename = argument[1]

	return pack
}