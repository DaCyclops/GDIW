data:extend(
	{
	  {
		type = "font",
		name = "gdiw-font",
		from = "default",
		size = 12
	  }
	}
)

data.raw["gui-style"].default["gdiw_frame_style"] =
{
type = "frame_style",
	parent = "frame_style",
	width = 33,
	height = 33,
	left_padding = 1,
	right_padding = 1,
	top_padding = 2,
	bottom_padding = 2,
}

data.raw["gui-style"].default["gdiw_button_style"] = {
    type = "button_style",
    parent = "button_style",
    width = 33,
    height = 33,
    default_graphical_set = {
        type="monolith",
        monolith_image = {
            filename = "__GDIW__/graphics/gdiw-button-default.png",
            width = 32,
            height = 32
        }
    },
    hovered_graphical_set = {
        type="monolith",
        monolith_image = {
            filename = "__GDIW__/graphics/gdiw-button-hove-s1.png",
            width = 32,
            height = 32
        }
    },
    clicked_graphical_set = {
        type="monolith",
        monolith_image = {
            filename = "__GDIW__/graphics/gdiw-button-hove-s1.png",
            width = 32,
            height = 32
        }
    },
    disabled_graphical_set = {
        type="monolith",
        monolith_image = {
            filename = "__GDIW__/graphics/gdiw-button-default.png",
            width = 32,
            height = 32
        }
    }
}

data.raw["gui-style"].default["gdiw_text"] =
{
	type = "label_style",
	parent = "label_style",
	width = 160,
	align = "center",
	font = "gdiw-font",
	font_color = {r = 1, g = 1, b = 1}
}


