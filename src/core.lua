SMODS.Atlas {
	key = "atlas_cod_jokers",
	path = "jokers.png",
	px = 71,
	py = 95
}

-- Redacted
-- dummy joker for confidential sticker
SMODS.Joker {
	key = "redacted",
    atlas = 'atlas_cod_jokers',
    discovered = true,
    pos = { x = 6, y = 5 },
	no_collection = true,
	in_pool = function(self, args)
		return false
	end,
}

-- Hooks

-- hook to run context on moved cards
local stop_drag_ref = Card.stop_drag
function Card:stop_drag()
    SMODS.calculate_context({ move_card = true })
    stop_drag_ref(self)
end