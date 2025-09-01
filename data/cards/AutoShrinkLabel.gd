# AutoShrinkLabel.gd
# A script that automatically shrinks the font size of a Label to fit its container.
extends Label

# Set this in the Inspector to the largest you'd ever want the font to be.
@export var max_font_size: int = 16

func set_shrinking_text(new_text: String):
	# 1. First, reset to the largest possible font size and set the text.
	# This ensures that if we go from a long text to a short one, the font grows back.
	set("theme_override_font_sizes/font_size", max_font_size)
	text = new_text

	# 2. Wait for the next frame for the visual server to update the label's size.
	# This is a common and necessary trick for UI programming in Godot.
	await get_tree().process_frame

	# 3. Now, shrink the font size in a loop until the text fits inside the box.
	# get_minimum_size() is the size the text *wants* to be.
	# size is the actual size of the box it has to fit in.
	while get_minimum_size().y > size.y:
		var current_size = get_theme_font_size("font_size")
		
		# Safety check to stop it from shrinking into nothingness.
		if current_size <= 4:
			break
			
		set("theme_override_font_sizes/font_size", current_size - 1)
		# We have to wait again after each change for the new size to be calculated.
		await get_tree().process_frame
