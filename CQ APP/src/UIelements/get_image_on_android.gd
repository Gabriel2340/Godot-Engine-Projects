extends VBoxContainer

var imagePlugin


func _ready() -> void:
	if Engine.has_singleton("GodotGetImage"):
		imagePlugin = Engine.get_singleton("GodotGetImage")
		imagePlugin.connect("image_request_completed", self, "set_image")

func _on_Load_pressed() -> void:
	if imagePlugin:
		imagePlugin.getGalleryImage()
	else:
		print2("Plugin isn't loaded")


func set_image(dict):
	for image in dict.values():
		var currentImage = Image.new()
		currentImage.load_jpg_from_buffer(image)
		print2("Loading Image")
		yield(get_tree(), "idle_frame")
		var texture = ImageTexture.new()
		texture.create_from_image(currentImage, 0)
		$TextureRect.texture = texture
		$TextureRect.visible = true


func print2(message : String):
	$Label.text = message


func _on_Clear_pressed() -> void:
	$TextureRect.texture = null
	$TextureRect.visible = false
