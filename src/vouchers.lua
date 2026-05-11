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

-- Packed
SMODS.Voucher {
    key = 'packed',
    atlas = 'atlas_cod_vouchers',
    pos = { x = 2, y = 0 },
    config = { extra = { booster_options = 1 } },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.booster_options } }
    end,
    redeem = function(self, card)
        G.E_MANAGER:add_event(Event({
            func = function()
                G.GAME.modifiers.booster_size_mod = (G.GAME.modifiers.booster_size_mod or 0) + card.ability.extra.booster_options
                return true
            end
        }))
    end
}

-- Collector's Edition
SMODS.Voucher {
    key = 'collectors_edition',
    atlas = 'atlas_cod_vouchers',
    pos = { x = 2, y = 1 },
    config = { extra = { booster_choices = 1 } },
    requires = { 'v_cod_packed' },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.booster_choices } }
    end,
    redeem = function(self, card)
        G.E_MANAGER:add_event(Event({
            func = function()
                G.GAME.modifiers.booster_choice_mod = (G.GAME.modifiers.booster_choice_mod or 0) + card.ability.extra.booster_choices
                return true
            end
        }))
    end,
}

-- Serendipity
SMODS.Voucher {
    key = 'serendipity',
    atlas = 'atlas_cod_vouchers',
    pos = { x = 3, y = 0 },
    config = { extra = { boosters = 1 } },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.boosters } }
    end,
    redeem = function(self, card)
        G.E_MANAGER:add_event(Event({
            func = function()
                SMODS.change_booster_limit(card.ability.extra.boosters)
                return true
            end
        }))
    end
}

-- Recursion
SMODS.Voucher {
    key = 'recursion',
    atlas = 'atlas_cod_vouchers',
    pos = { x = 3, y = 1 },
    config = { extra = { vouchers = 1 } },
    requires = { 'v_cod_serendipity' },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.vouchers } }
    end,
    redeem = function(self, card)
        G.E_MANAGER:add_event(Event({
            func = function()
                SMODS.change_voucher_limit(card.ability.extra.vouchers)
                return true
            end
        }))
    end,
}