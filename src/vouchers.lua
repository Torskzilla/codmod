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

-- Handy
SMODS.Voucher {
    key = 'handy',
    atlas = 'atlas_cod_vouchers',
    pos = { x = 1, y = 0 },
    config = { extra = { hand_money = 1 } },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.hand_money } }
    end,
    redeem = function(self, card)
        G.E_MANAGER:add_event(Event({
            func = function()
                G.GAME.modifiers.money_per_hand = (G.GAME.modifiers.money_per_hand or 1) + card.ability.extra.hand_money
                return true
            end
        }))
    end
}

-- Hoarder
SMODS.Voucher {
    key = 'hoarder',
    atlas = 'atlas_cod_vouchers',
    pos = { x = 1, y = 1 },
    config = { extra = { discard_money = 1 } },
    requires = { 'v_cod_handy' },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.discard_money } }
    end,
    redeem = function(self, card)
        G.E_MANAGER:add_event(Event({
            func = function()
                G.GAME.modifiers.money_per_discard = (G.GAME.modifiers.money_per_discard or 0) + card.ability.extra.discard_money
                return true
            end
        }))
    end,
}