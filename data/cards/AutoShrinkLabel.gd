# AutoShrinkLabel.gd
# A script that automatically shrinks the font size of a Label to fit its container.
extends Label

# Set this in the Inspector to the largest you'd ever want the font to be.
@export var max_font_size: int = 16

func set_shrinking_text(new_text: String):
	# 1. First, reset to the largest possible font size and set the text.
	set("theme_override_font_sizes/font_size", max_font_size)
	text = new_text

	# 2. Wait for the next frame for the visual server to update the label's size.
	await get_tree().process_frame

	# 3. Get the actual font resource so we can do proper height calculations.
	var font = get_theme_font("font")
	var current_font_size = get_theme_font_size("font_size")
	
	# This is the new, ACCURATE height calculation.
	var true_text_height = get_line_count() * font.get_height(current_font_size)

	# 4. Now, shrink the font size in a loop until the text fits inside the box.
	while true_text_height > size.y:
		current_font_size -= 1
		
		# Safety check to stop it from shrinking into nothingness.
		if current_font_size <= 4:
			break
			
		set("theme_override_font_sizes/font_size", current_font_size)
		# We must wait a frame for the line_count and height to update after changing the font size.
		await get_tree().process_frame
		
		# Recalculate the height with the new, smaller font size for the next loop check.
		true_text_height = get_line_count() * font.get_height(current_font_size)
