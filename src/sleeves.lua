
SMODS.Atlas {
	key = "atlas_cod_sleeves",
	path = "sleeves.png",
	px = 73,
	py = 95,
}

-- Triangle

-- Gravity
CardSleeves.Sleeve {
    key = "gravity",
    unlocked = true,
    atlas = "atlas_cod_sleeves",
    pos = { x = 4, y = 0 },
    config = {},
    apply = function(self)
        G.E_MANAGER:add_event(Event({
            func = function()
                SMODS.add_card{ set = "Spectral", key = "c_black_hole", no_edition = true }
                return true
            end,
        }))
    end,
}

-- Rainbow
CardSleeves.Sleeve {
    key = "rainbow",
    unlocked = true,
    atlas = "atlas_cod_sleeves",
    pos = { x = 5, y = 0 },
    config = {},
    apply = function(self)
        G.E_MANAGER:add_event(Event({
            func = function()
                local ranks = {}
                for _, playing_card in ipairs(G.playing_cards) do
                    ranks[playing_card.base.value] = true
                end
                for rank,_ in pairs(ranks) do
                    SMODS.add_card { set = "Base", rank = rank, enhancement = "m_wild", area = G.deck }
                end
                G.GAME.starting_deck_size = #G.playing_cards
                return true
            end,
        }))
    end,
}

-- VIP
CardSleeves.Sleeve {
    key = "vip",
    unlocked = true,
    atlas = "atlas_cod_sleeves",
    pos = { x = 0, y = 0 },
    config = {},
    apply = function(self)
         G.E_MANAGER:add_event(Event({
            func = function()
                local valid_enhance_cards = {}
                for _, playing_card in ipairs(G.playing_cards) do
                    if not (next(SMODS.get_enhancements(playing_card)) and playing_card.seal and playing_card.edition) and not playing_card.getting_sliced then
                        valid_enhance_cards[#valid_enhance_cards + 1] = playing_card
                    end
                end
                local vip_card = pseudorandom_element(valid_enhance_cards, 'cod_vip_sleeve')
                if vip_card then
            
                    local edition = SMODS.poll_edition { key = "cod_vip_sleeve", guaranteed = true, no_negative = true, options = { 'e_polychrome', 'e_holo', 'e_foil' } }
                    vip_card:set_edition(edition, true)

                    local seal = SMODS.poll_seal({ guaranteed = true, key = 'cod_vip_sleeve' })
                    vip_card:set_seal(seal, true)

                    local enhancement = SMODS.poll_enhancement({ guaranteed = true, type_key = 'cod_vip_sleeve' })
                    vip_card:set_ability(enhancement, true)
                end
                return true
            end
        }))
    end,
}

-- Average

-- Horror
CardSleeves.Sleeve {
    key = "horror",
    unlocked = true,
    atlas = "atlas_cod_sleeves",
    pos = { x = 6, y = 0 },
    config = {},
    apply = function(self)
        G.GAME.cod_sleeve_horror_life_used = false
    end,
    loc_vars = function(self, info_queue, back)
        return { vars = { (G.GAME.cod_sleeve_horror_life_used and localize("horror_deck_used") or "") } }
    end,
    calculate = function(self, back, context)
        if context.end_of_round and context.game_over and context.main_eval then
            if not G.GAME.cod_sleeve_horror_life_used then
                G.GAME.cod_sleeve_horror_life_used = true

                -- todo: replace sleeve sprite with bloody ver

                return {
                    saved = 'horror_sleeve_saved',
                }
            end
        end
    end,
}

-- Ponzi