
SMODS.Atlas {
	key = "atlas_cod_decks",
	path = "decks.png",
	px = 71,
	py = 95
}

SMODS.Back{
    key = "average",
    unlocked = true,
    atlas = 'atlas_cod_decks',
    pos = {x = 3, y = 0},
    config = {},

    apply = function(self)
        G.GAME.common_mod = 0
        G.GAME.rare_mod = 0
    end,
}

SMODS.Back{
    key = "ponzi",
    unlocked = false,
    atlas = 'atlas_cod_decks',
    pos = {x = 2, y = 0},
    config = {dollars = -24, credit_cards = 5},

    loc_vars = function(self, info_queue, back)
        return { vars = { self.config.credit_cards, localize { type = 'name_text', key = "j_credit_card", set = 'Joker'}, -self.config.dollars-4 } }
    end,

    apply = function(self)
        G.E_MANAGER:add_event(Event({
            func = function()
                if G.jokers then

                    for i=1,self.config.credit_cards do
                        local credit_card = create_card("Joker", G.jokers, nil, nil, nil, nil, "j_credit_card")
                        credit_card:set_edition(nil, true, true)
                        credit_card:add_to_deck()
                        credit_card:start_materialize()
                        G.jokers:emplace(credit_card)
                    end
                    
                    return true
                end
            end,
        }))
    end,
    
    locked_loc_vars = function(self, info_queue, back)
        return { vars = { 30 } }
    end,
    check_for_unlock = function(self, args)
        return args.type == 'money' and G.GAME.dollars <= -30
    end
}

SMODS.Back{
    key = "vip",
    unlocked = true,
    atlas = 'atlas_cod_decks',
    pos = {x = 4, y = 0},
    config = {},

    apply = function(self)
         G.E_MANAGER:add_event(Event({
            func = function()
                local vip_card = pseudorandom_element(G.playing_cards, 'cod_vip')
                if vip_card then
            
                    local edition = SMODS.poll_edition { key = "cod_vip", guaranteed = true, no_negative = true, options = { 'e_polychrome', 'e_holo', 'e_foil' } }
                    vip_card:set_edition(edition, true)

                    local seal = SMODS.poll_seal({ guaranteed = true, key = 'cod_vip' })
                    vip_card:set_seal(seal, true)

                    local enhancement = SMODS.poll_enhancement({ guaranteed = true, type_key = 'cod_vip' })
                    vip_card:set_ability(enhancement, true)
                end
                return true
            end
        }))
    end,
}