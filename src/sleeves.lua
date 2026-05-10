
SMODS.Atlas {
	key = "atlas_cod_sleeves",
	path = "sleeves.png",
	px = 73,
	py = 95,
}

-- Royal
CardSleeves.Sleeve {
    key = "royal",
    unlocked = true,
    atlas = "atlas_cod_sleeves",
    pos = { x = 1, y = 1 },
    config = {},
    apply = function(self)
        G.E_MANAGER:add_event(Event({
            func = function()
                local cards = {}
                for _, playing_card in ipairs(G.playing_cards) do
                    if playing_card:is_face() then
                        cards[#cards+1] = playing_card
                    end
                end
                for _,playing_card in pairs(cards) do
                    local card_copied = copy_card(playing_card, nil, nil, G.playing_card)
                    G.playing_card = (G.playing_card and G.playing_card + 1) or 1
                    card_copied.playing_card = G.playing_card
                    table.insert(G.playing_cards, card_copied)
                    G.deck:emplace(card_copied)
                end
                G.GAME.starting_deck_size = #G.playing_cards
                return true
            end,
        }))
    end,
}

-- Triangle
CardSleeves.Sleeve {
    key = "triangle",
    unlocked = true,
    atlas = "atlas_cod_sleeves",
    pos = { x = 3, y = 0 },
    config = {},
    apply = function(self)
        -- there is now a built in way to do this in SMODS
        G.GAME.starting_params.remove_random_suit = (G.GAME.starting_params.remove_random_suit or 0) + 1
    end,
}

-- Flow
CardSleeves.Sleeve {
    key = "flow",
    unlocked = true,
    atlas = "atlas_cod_sleeves",
    pos = { x = 8, y = 0 },
    config = { rerolls = 1 },
    apply = function(self)
        SMODS.change_free_rerolls(self.config.rerolls)
    end,
}

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
                if G.GAME.starting_params.erratic_suits_and_ranks then
                    for _=1,13 do
                        SMODS.add_card { set = "Base", enhancement = "m_wild", area = G.deck }
                    end
                else
                    local ranks = {}
                    for _, playing_card in ipairs(G.playing_cards) do
                        ranks[playing_card.base.value] = true
                    end
                    for rank,_ in pairs(ranks) do
                        SMODS.add_card { set = "Base", rank = rank, enhancement = "m_wild", area = G.deck }
                    end
                end
                G.GAME.starting_deck_size = #G.playing_cards
                return true
            end,
        }))
    end,
}

-- Inverted
local config = SMODS.current_mod.config
if config.cod_tags_enabled then
    CardSleeves.Sleeve{
        key = "inverted",
        unlocked = true,
        atlas = "atlas_cod_sleeves",
        pos = { x = 0, y = 1 },
        config = {},
        apply = function(self)
            G.E_MANAGER:add_event(Event({
                func = function()
                    add_tag({ key = 'tag_cod_clean' })
                    add_tag({ key = 'tag_negative' })
                    return true
                end
            }))
        end,
    }
end

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
            
                    local edition = SMODS.poll_edition { key = "cod_vip_sleeve", guaranteed = true, options = { 'e_polychrome', 'e_holo', 'e_foil' } }
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

-- Isometric
CardSleeves.Sleeve {
    key = "isometric",
    unlocked = true,
    atlas = "atlas_cod_sleeves",
    pos = { x = 9, y = 0 },
    config = {},
    loc_vars = function(self, info_queue, back)
        if self.get_current_deck_key() == "b_cod_isometric" then
            return { key = self.key .. "_alt", vars = { (G.GAME.cod_sleeve_isometric_chip_excess or 0) } }
        end
    end,
    apply = function(self)
        if self.get_current_deck_key() ~= "b_cod_isometric" then
            G.GAME.modifiers.cod_isometric = true
            G.GAME.modifiers.money_per_discard = (G.GAME.modifiers.money_per_discard or 0) + 1
        else
            G.GAME.cod_sleeve_isometric_chip_excess = 0
        end
    end,
    calculate = function(self, back, context)
        if self.get_current_deck_key() ~= "b_cod_isometric" then
            if context.end_of_round and context.main_eval and not context.beat_boss then
                G.GAME.round_bonus.discards = (G.GAME.round_bonus.discards or 0) + G.GAME.current_round.discards_left
                G.GAME.round_bonus.next_hands = (G.GAME.round_bonus.next_hands or 0) + G.GAME.current_round.hands_left
            end
        else
            if context.end_of_round and context.main_eval then
                local current_score = G.GAME.chips
                local current_requirements = G.GAME.blind.chips
                if (current_score>current_requirements) then
                    G.GAME.cod_sleeve_isometric_chip_excess = (current_score - current_requirements)/2
                end
            end
            if context.setting_blind then
                G.GAME.chips = (G.GAME.chips or 0) + (G.GAME.cod_sleeve_isometric_chip_excess or 0)
                G.GAME.cod_sleeve_isometric_chip_excess = 0
            end
        end
    end,
}

-- Average
CardSleeves.Sleeve {
    key = "average",
    unlocked = true,
    atlas = "atlas_cod_sleeves",
    pos = { x = 2, y = 0 },
    config = {},
    loc_vars = function(self, info_queue, back)
        if self.get_current_deck_key() == "b_cod_average" then
            return { key = self.key .. "_alt" }
        end
    end,
    apply = function(self)
        if self.get_current_deck_key() ~= "b_cod_average" then
            G.GAME.uncommon_mod = 4
        else
            G.GAME.common_mod = 0
            G.GAME.rare_mod = 0
        end
    end,
}

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
CardSleeves.Sleeve {
    key = "ponzi",
    unlocked = true,
    atlas = "atlas_cod_sleeves",
    pos = { x = 1, y = 0 },
    config = {dollars = -20, credit_cards = 5},

    loc_vars = function(self, info_queue, back)
        if self.get_current_deck_key() == "b_cod_ponzi" then
            return { key = self.key .. "_alt", vars = { localize { type = 'name_text', key = "j_credit_card", set = 'Joker'}, -self.config.dollars } }
        else
            return { vars = { self.config.credit_cards, localize { type = 'name_text', key = "j_credit_card", set = 'Joker'}, -self.config.dollars } }
        end
    end,

    apply = function(self)
        G.GAME.starting_params.dollars = (G.GAME.starting_params.dollars or 0) + self.config.dollars
        G.E_MANAGER:add_event(Event({
            func = function()
                if G.jokers then

                    if self.get_current_deck_key() ~= "b_cod_ponzi" then
                        for i=1,self.config.credit_cards do
                            SMODS.add_card{ set = "Joker", key = "j_credit_card", no_edition = true }
                        end
                    end
                    
                    return true
                end
            end,
        }))
    end,
}