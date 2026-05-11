SMODS.Atlas {
	key = "atlas_cod_vouchers",
	path = "vouchers.png",
	px = 71,
	py = 95
}

-- Eccentric
SMODS.Voucher {
    key = 'eccentric',
    atlas = 'atlas_cod_vouchers',
    pos = { x = 0, y = 0 },
    config = { extra = { common_rate = 0.8 } },
    redeem = function(self, card)
        G.E_MANAGER:add_event(Event({
            func = function()
                G.GAME.common_mod = (G.GAME.common_mod or 1) * card.ability.extra.common_rate
                return true
            end
        }))
    end
}

-- Blue Blood
SMODS.Voucher {
    key = 'blue_blood',
    atlas = 'atlas_cod_vouchers',
    pos = { x = 0, y = 1 },
    config = { extra = { common_rate = 0.75 } },
    requires = { 'v_cod_eccentric' },
    redeem = function(self, card)
        G.E_MANAGER:add_event(Event({
            func = function()
                G.GAME.common_mod = (G.GAME.common_mod or 1) * card.ability.extra.common_rate
                return true
            end
        }))
    end,
}