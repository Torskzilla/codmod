
SMODS.Atlas {
	key = "atlas_cod_stakes",
	path = "stakes.png",
	px = 29,
	py = 29
}

-- Black Stake
SMODS.Stake:take_ownership('black',
    {
    loc_vars = function(self, info_queue)
        return { key = self.key .. "_alt" }
    end,
    modifiers = function()
        G.GAME.modifiers.enable_eternals_in_shop = true
        G.GAME.modifiers.enable_cod_envy = true
    end,
    },
    true
)

-- Blue Stake Rework
SMODS.Stake:take_ownership('blue',
    {
    loc_vars = function(self, info_queue)
        return { key = self.key .. "_alt" }
    end,
    modifiers = function()
        G.GAME.modifiers.enable_cod_imprisoned = true
        G.GAME.modifiers.enable_cod_claustrophobic = true
    end,
    },
    true
)

-- Orange Stake
SMODS.Stake:take_ownership('orange',
    {
    loc_vars = function(self, info_queue)
        return { key = self.key .. "_alt" }
    end,
    modifiers = function()
        G.GAME.modifiers.enable_perishables_in_shop = true
        G.GAME.modifiers.enable_cod_dormant = true
    end,
    },
    true
)

-- Gold Stake
SMODS.Stake:take_ownership('gold',
    {
    loc_vars = function(self, info_queue)
        return { key = self.key .. "_alt" }
    end,
    modifiers = function()
        G.GAME.modifiers.enable_rentals_in_shop = true
        G.GAME.modifiers.enable_cod_expensive = true
    end,
    },
    true
)

-- Platinum
SMODS.Stake {
    name = "Platinum Stake",
    key = "platinum",
    applied_stakes = { "stake_gold" },
    prefix_config = {
        applied_stakes = { mod = false },
        above_stake = { mod = false }
    },
    atlas = 'atlas_cod_stakes',
    pos = { x = 0, y = 0 },
    sticker_atlas = 'atlas_cod_stickers',
    sticker_pos = { x = 4, y = 0 },
    modifiers = function()
        G.GAME.modifiers.enable_cod_confidential = true
        G.GAME.modifiers.enable_cod_fragile = true
    end,
    colour = HEX("d4fbf3"),
    shiny = true,
    unlocked = false,
}