
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

-- Season cycle
local season_loc_vars = function(self, info_queue, card)
    return { vars = { localize(card.ability.extra.from_suit, 'suits_singular'), localize(card.ability.extra.to_suit, 'suits_plural'), colours = { card.ability.extra.from_color, card.ability.extra.to_color } } }
end
local season_calculate = function(self, card, context)
    if context.before and not context.blueprint then
        local convert = false
        for _, scored_card in ipairs(context.scoring_hand) do
            if scored_card:is_suit(card.ability.extra.from_suit) and not scored_card.debuff then
                convert = true
                assert(SMODS.change_base(scored_card, card.ability.extra.to_suit))
                G.E_MANAGER:add_event(Event({
                    func = function()
                        scored_card:juice_up()
                        return true
                    end
                }))
            end
        end
        if convert then
            return {
                message = localize('season_convert'),
                colour = card.ability.extra.to_color
            }
        end
    end
end

-- Summer
SMODS.Joker {
    key = "summer",
    unlocked = true,
    blueprint_compat = false,
    rarity = 1,
    cost = 4,
    atlas = 'atlas_cod_jokers',
    pos = { x = 3, y = 0 },
    config = { extra = { from_suit = "Clubs", to_suit = "Hearts", from_color = G.C.SUITS.Clubs, to_color = G.C.SUITS.Hearts} },
    loc_vars = season_loc_vars,
    calculate = season_calculate,
}

-- Fall
SMODS.Joker {
    key = "fall",
    unlocked = true,
    blueprint_compat = false,
    rarity = 1,
    cost = 4,
    atlas = 'atlas_cod_jokers',
    pos = { x = 4, y = 0 },
    config = { extra = { from_suit = "Hearts", to_suit = "Spades", from_color = G.C.SUITS.Hearts, to_color = G.C.SUITS.Spades} },
    loc_vars = season_loc_vars,
    calculate = season_calculate,
}

-- Winter
SMODS.Joker {
    key = "winter",
    unlocked = true,
    blueprint_compat = false,
    rarity = 1,
    cost = 4,
    atlas = 'atlas_cod_jokers',
    pos = { x = 5, y = 0 },
    config = { extra = { from_suit = "Spades", to_suit = "Diamonds", from_color = G.C.SUITS.Spades, to_color = G.C.SUITS.Diamonds} },
    loc_vars = season_loc_vars,
    calculate = season_calculate,
}

-- Spring
SMODS.Joker {
    key = "spring",
    unlocked = true,
    blueprint_compat = false,
    rarity = 1,
    cost = 4,
    atlas = 'atlas_cod_jokers',
    pos = { x = 6, y = 0 },
    config = { extra = { from_suit = "Diamonds", to_suit = "Clubs", from_color = G.C.SUITS.Diamonds, to_color = G.C.SUITS.Clubs} },
    loc_vars = season_loc_vars,
    calculate = season_calculate,
}

-- Four Seasons
SMODS.Joker {
    key = "four_seasons",
    unlocked = false,
    blueprint_compat = true,
    rarity = 2,
    cost = 6,
    atlas = 'atlas_cod_jokers',
    pos = { x = 7, y = 0 },
    config = {},
    calculate = function(self, card, context)
        if context.before then
            local convert = false
            for _, scored_card in ipairs(context.scoring_hand) do
                if not SMODS.has_no_suit(scored_card) and not scored_card.debuff then
                    convert = true
                    local suits = {"Hearts", "Spades", "Diamonds", "Clubs", "Hearts"}
                    for i=1,4 do
                        if scored_card.base.suit == suits[i] then
                            assert(SMODS.change_base(scored_card, suits[i+1]))
                            G.E_MANAGER:add_event(Event({
                                func = function()
                                    scored_card:juice_up()
                                    return true
                                end
                                
                            }))
                            break
                        end
                    end
                end
            end
            if convert then
                return {
                    message = localize('season_convert'),
                }
            end
        end
    end,

    check_for_unlock = function(self, args)
        if args.type == 'hand_contents' then
            
            if G.P_CENTERS["j_cod_winter"].discovered and G.P_CENTERS["j_cod_spring"].discovered and G.P_CENTERS["j_cod_summer"].discovered and G.P_CENTERS["j_cod_fall"].discovered then

                return true
            end
            return false
        end
    end
}

-- Suit imbalance cycle

-- Mitosis
SMODS.Joker {
    key = "mitosis",
    unlocked = true,
    blueprint_compat = true,
    rarity = 1,
    cost = 4,
    atlas = 'atlas_cod_jokers',
    pos = { x = 4, y = 3 },
    -- amount is unused
    config = { extra = { amount = 1, suit = "Hearts", color = G.C.SUITS.Hearts} },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.amount, localize(card.ability.extra.suit, 'suits_singular'), colours = { card.ability.extra.color } } }
    end,
    calculate = function(self, card, context)
        if context.setting_blind then
            local valid_mitosis_cards = {}
            for _, playing_card in ipairs(G.playing_cards) do
                if playing_card:is_suit(card.ability.extra.suit) and not playing_card.getting_sliced then
                    valid_mitosis_cards[#valid_mitosis_cards + 1] = playing_card
                end
            end
            local mitosis_card = pseudorandom_element(valid_mitosis_cards, 'cod_mitosis')
            if mitosis_card then

                draw_card(G.deck, G.play, 90, 'up', nil, mitosis_card)

                local card_copied = copy_card(mitosis_card, nil, nil, G.playing_card)
                card_copied.states.visible = nil
                G.playing_card = (G.playing_card and G.playing_card + 1) or 1
                card_copied.playing_card = G.playing_card
                table.insert(G.playing_cards, card_copied)

                G.E_MANAGER:add_event(Event({
                    trigger = 'after',
                    delay = 0.5,
                    func = function()
                        card_copied:start_materialize()
                        G.play:emplace(card_copied)
                        return true
                    end
                }))

                G.E_MANAGER:add_event(Event({
                    trigger = 'after',
                    delay = 1,
                    func = function()
                        return true
                    end
                }))

                draw_card(G.play, G.deck, 90, 'up', nil, mitosis_card)
                draw_card(G.play, G.deck, 90, 'up', nil, card_copied)
                SMODS.calculate_context({ playing_card_added = true, cards = { card_copied } })
                return {
                    message = localize('mitosis_split'),
                    colour = card.ability.extra.color,
                }
            end
        end
    end
}

-- Invasion
SMODS.Joker {
    key = "invasion",
    unlocked = true,
    blueprint_compat = true,
    rarity = 1,
    cost = 4,
    atlas = 'atlas_cod_jokers',
    pos = { x = 6, y = 3 },
    config = { extra = { amount = 2, suit = "Spades", color = G.C.SUITS.Spades} },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.amount, localize(card.ability.extra.suit, 'suits_singular'), colours = { card.ability.extra.color } } }
    end,
    calculate = function(self, card, context)
        if context.setting_blind then
            
            local spade_card1 = SMODS.create_card { set = "Base", suit = card.ability.extra.suit, area = G.discard }
            G.playing_card = (G.playing_card and G.playing_card + 1) or 1
            spade_card1.playing_card = G.playing_card
            table.insert(G.playing_cards, spade_card1)

            G.E_MANAGER:add_event(Event({
                func = function()
                    spade_card1:start_materialize()
                    G.play:emplace(spade_card1)
                    return true
                end
            }))

            local spade_card2 = SMODS.create_card { set = "Base", suit = card.ability.extra.suit, area = G.discard }
            G.playing_card = (G.playing_card and G.playing_card + 1) or 1
            spade_card2.playing_card = G.playing_card
            table.insert(G.playing_cards, spade_card2)

            G.E_MANAGER:add_event(Event({
                func = function()
                    spade_card2:start_materialize()
                    G.play:emplace(spade_card2)
                    return true
                end
            }))

            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 1,
                func = function()
                    G.deck.config.card_limit = G.deck.config.card_limit + 2
                    return true
                end
            }))

            draw_card(G.play, G.deck, 90, 'up', nil, spade_card1)
            draw_card(G.play, G.deck, 90, 'up', nil, spade_card2)

            SMODS.calculate_context({ playing_card_added = true, cards = { spade_card1, spade_card2 } })
            return {
                message = localize('invasion_attack'),
                colour = card.ability.extra.color,
            }
        end
    end
}

-- Purification
SMODS.Joker {
    key = "purification",
    unlocked = true,
    blueprint_compat = true,
    rarity = 1,
    cost = 4,
    atlas = 'atlas_cod_jokers',
    pos = { x = 5, y = 3 },
    config = { extra = { amount = 1, suit = "Diamonds", color = G.C.SUITS.Diamonds} },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.amount, localize(card.ability.extra.suit, 'suits_singular'), colours = { card.ability.extra.color } } }
    end,
    calculate = function(self, card, context)
        if context.setting_blind then
            local cards_removed = 0
            for i=1,card.ability.extra.amount do
                local valid_remove_cards = {}
                for _, playing_card in ipairs(G.playing_cards) do
                    if not playing_card:is_suit(card.ability.extra.suit) and not playing_card.getting_sliced then
                        valid_remove_cards[#valid_remove_cards + 1] = playing_card
                    end
                end
                local remove_card = pseudorandom_element(valid_remove_cards, 'cod_purification')
                if remove_card then
                    remove_card.getting_sliced = true
                    draw_card(G.deck, G.play, 90, 'up', nil, remove_card)
                    G.E_MANAGER:add_event(Event({
                        trigger = 'after',
                        delay = 1,
                        func = function()
                            return true
                        end
                    }))
                    SMODS.destroy_cards(remove_card)
                    cards_removed = cards_removed + 1
                end
            end
            
            if cards_removed > 0 then
                return {
                    message = localize('purification_remove'),
                    colour = card.ability.extra.color,
                }
            end
        end
    end
}

-- Overgrowth
SMODS.Joker {
    key = "overgrowth",
    unlocked = true,
    blueprint_compat = true,
    rarity = 1,
    cost = 4,
    atlas = 'atlas_cod_jokers',
    pos = { x = 2, y = 0 },
    -- amount is unused
    config = { extra = { amount = 1, suit = "Clubs", color = G.C.SUITS.Clubs} },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.amount, localize(card.ability.extra.suit, 'suits_plural'), colours = { card.ability.extra.color } } }
    end,
    calculate = function(self, card, context)
        if context.setting_blind then
            local valid_overgrowth_cards = {}
            for _, playing_card in ipairs(G.playing_cards) do
                if playing_card.base.suit ~= card.ability.extra.suit and not SMODS.has_no_suit(playing_card) and not playing_card.getting_sliced then
                    valid_overgrowth_cards[#valid_overgrowth_cards + 1] = playing_card
                end
            end
            local overgrowth_card = pseudorandom_element(valid_overgrowth_cards, 'cod_overgrowth')
            if overgrowth_card then
                draw_card(G.deck, G.play, 90, 'up', nil, overgrowth_card)

                assert(SMODS.change_base(overgrowth_card, card.ability.extra.suit, nil, true))

                G.E_MANAGER:add_event(Event({
                    trigger = 'after',
                    delay = 1,
                    func = function()
                        overgrowth_card:set_sprites(nil, overgrowth_card.config.card)
                        return true
                    end
                }))

                G.E_MANAGER:add_event(Event({
                    trigger = 'after',
                    delay = 1,
                    func = function()
                        return true
                    end
                }))

                draw_card(G.play, G.deck, 90, 'up', nil, overgrowth_card)
                
                return {
                    message = localize('overgrowth_grow'),
                    colour = card.ability.extra.color,
                }
            end

        end
    end
}

-- Harmony
SMODS.Joker {
    key = "harmony",
    unlocked = true,
    blueprint_compat = true,
    perishable_compat = false,
    rarity = 1,
    cost = 4,
    atlas = 'atlas_cod_jokers',
    pos = { x = 7, y = 3 },
    -- amount is unused
    config = { extra = { amount = 1, mult_gain = 2, mult = 0 } },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.mult_gain, card.ability.extra.amount, card.ability.extra.mult } }
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            return {
                mult = card.ability.extra.mult
            }
        end
        if context.setting_blind then

            card.ability.extra.mult = card.ability.extra.mult + card.ability.extra.mult_gain

            local spades = {}
            local hearts = {}
            local diamonds = {}
            local clubs = {}

            for _, playing_card in ipairs(G.playing_cards) do
                if not SMODS.has_no_suit(playing_card) and not SMODS.has_any_suit(playing_card) then
                    if playing_card:is_suit("Hearts") then hearts[#hearts + 1] = playing_card end
                    if playing_card:is_suit("Clubs") then clubs[#clubs + 1] = playing_card end
                    if playing_card:is_suit("Spades") then spades[#spades + 1] = playing_card end
                    if playing_card:is_suit("Diamonds") then diamonds[#diamonds + 1] = playing_card end
                end
            end

            if #spades == #hearts and #hearts == #diamonds and #diamonds == #clubs then
                return {
                    message = localize('harmony_balance'),
                    colour = G.C.GOLD,
                }
            end

            local majority = {}

            if #spades >= #hearts and #spades >= #diamonds and #spades >= #clubs then
                for _, v in ipairs(spades) do majority[#majority+1] = v end
            end
            if #hearts >= #spades and #hearts >= #diamonds and #hearts >= #clubs then
                for _, v in ipairs(hearts) do majority[#majority+1] = v end
            end
            if #clubs >= #hearts and #clubs >= #diamonds and #clubs >= #spades then
                for _, v in ipairs(clubs) do majority[#majority+1] = v end
            end
            if #diamonds >= #hearts and #diamonds >= #spades and #diamonds >= #clubs then
                for _, v in ipairs(diamonds) do majority[#majority+1] = v end
            end

            local minority = {}

            if #spades <= #hearts and #spades <= #diamonds and #spades <= #clubs then
                minority[#minority+1] = "Spades"
            end
            if #hearts <= #spades and #hearts <= #diamonds and #hearts <= #clubs then
                minority[#minority+1] = "Hearts"
            end
            if #clubs <= #hearts and #clubs <= #diamonds and #clubs <= #spades then
                minority[#minority+1] = "Clubs"
            end
            if #diamonds <= #hearts and #diamonds <= #spades and #diamonds <= #clubs then
                minority[#minority+1] = "Diamonds"
            end

            local majority_card = pseudorandom_element(majority, 'cod_harmony')
            local minority_suit = pseudorandom_element(minority, 'cod_harmony')

            if majority_card and minority_suit then
                draw_card(G.deck, G.play, 90, 'up', nil, majority_card)

                assert(SMODS.change_base(majority_card, minority_suit, nil, true))

                G.E_MANAGER:add_event(Event({
                    trigger = 'after',
                    delay = 1,
                    func = function()
                        majority_card:set_sprites(nil, majority_card.config.card)
                        return true
                    end
                }))

                G.E_MANAGER:add_event(Event({
                    trigger = 'after',
                    delay = 1,
                    func = function()
                        return true
                    end
                }))

                draw_card(G.play, G.deck, 90, 'up', nil, majority_card)
                
                return {
                    message = localize('season_convert'),
                    colour = G.C.GOLD,
                }
            end

        end
    end
}

-- Common Clone
SMODS.Joker {
    key = "common_clone",
    unlocked = true,
    blueprint_compat = true,
    rarity = 1,
    cost = 4,
    atlas = 'atlas_cod_jokers',
    pos = { x = 3, y = 1 },
    config = { extra = { chips = 35, cod_clone = true } },
    in_pool = function(self, args)
        return true, { allow_duplicates = true }
    end,
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.chips } }
    end,
    calculate = function(self, card, context)
        if context.other_joker and type(context.other_joker.ability.extra) == "table" and context.other_joker.ability.extra.cod_clone then
            return {
                chips = card.ability.extra.chips
            }
        end
    end,
}

-- Uncommon Clone
SMODS.Joker {
    key = "uncommon_clone",
    unlocked = false,
    blueprint_compat = true,
    rarity = 2,
    cost = 6,
    atlas = 'atlas_cod_jokers',
    pos = { x = 4, y = 1 },
    config = { extra = { mult = 20, cod_clone = true } },
    in_pool = function(self, args)
        return true, { allow_duplicates = true }
    end,
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.mult } }
    end,
    calculate = function(self, card, context)
        if context.other_joker and type(context.other_joker.ability.extra) == "table" and context.other_joker.ability.extra.cod_clone then
            return {
                mult = card.ability.extra.mult
            }
        end
    end,

    check_for_unlock = function(self, args)
        if args.type == 'modify_jokers' and G.jokers then
            local count = 0
            for _, joker in ipairs(G.jokers.cards) do
                if joker.ability.set == 'Joker' and type(joker.ability.extra) == "table" and joker.ability.extra.cod_clone then
                    count = count + 1
                end
                if count >= 2 then
                    return true
                end
            end
        end
        return false
    end
}

-- Rare Clone
SMODS.Joker {
    key = "rare_clone",
    unlocked = false,
    blueprint_compat = true,
    rarity = 3,
    cost = 8,
    atlas = 'atlas_cod_jokers',
    pos = { x = 5, y = 1 },
    config = { extra = { xmult = 1.5, cod_clone = true } },
    in_pool = function(self, args)
        return true, { allow_duplicates = true }
    end,
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.xmult } }
    end,
    calculate = function(self, card, context)
        if context.other_joker and type(context.other_joker.ability.extra) == "table" and context.other_joker.ability.extra.cod_clone then
            return {
                xmult = card.ability.extra.xmult
            }
        end
    end,

    check_for_unlock = function(self, args)
        if args.type == 'modify_jokers' and G.jokers then
            local count = 0
            for _, joker in ipairs(G.jokers.cards) do
                if joker.ability.set == 'Joker' and type(joker.ability.extra) == "table" and joker.ability.extra.cod_clone then
                    count = count + 1
                end
                if count >= 3 then
                    return true
                end
            end
        end
        return false
    end
}

-- Short Joker
SMODS.Joker {
    key = "short",
    unlocked = true,
    blueprint_compat = true,
    rarity = 1,
    cost = 4,
    atlas = 'atlas_cod_jokers',
    pos = { x = 4, y = 2 },
    pixel_size = { h = 56 },
    config = { extra = { chips = 75, max_sum = 25 } },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.chips, card.ability.extra.max_sum } }
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            local rank_sum = 0
            for i = 1,#context.full_hand do
                rank_sum = rank_sum + context.full_hand[i].base.nominal
            end

            if rank_sum <= card.ability.extra.max_sum then
                return {
                    chips = card.ability.extra.chips,
                }
            end
        end
    end,
}

-- Tall Joker
SMODS.Joker {
    key = "tall",
    unlocked = true,
    blueprint_compat = true,
    rarity = 1,
    cost = 4,
    atlas = 'atlas_cod_jokers',
    pos = { x = 3, y = 2 },
    config = { extra = { mult = 15, min_sum = 40 } },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.mult, card.ability.extra.min_sum } }
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            local rank_sum = 0
            for i = 1,#context.full_hand do
                rank_sum = rank_sum + context.full_hand[i].base.nominal
            end

            if rank_sum >= card.ability.extra.min_sum then
                return {
                    mult = card.ability.extra.mult,
                }
            end
        end
    end,
}

-- Hungry Joker
SMODS.Joker {
    key = "hungry",
    unlocked = true,
    blueprint_compat = true,
    rarity = 1,
    cost = 4,
    atlas = 'atlas_cod_jokers',
    pos = { x = 1, y = 1 },
    config = {  extra = { eat_size = 2 } },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.eat_size } }
    end,
    calculate = function(self, card, context)
        if context.setting_blind then
            local cards_eaten = 0
            local eaten_cards = {}
            for i=1,card.ability.extra.eat_size do
                local valid_hungry_cards = {}
                for _, playing_card in ipairs(G.playing_cards) do
                    if not playing_card.getting_sliced then
                        valid_hungry_cards[#valid_hungry_cards + 1] = playing_card
                    end
                end
                local hungry_card = pseudorandom_element(valid_hungry_cards, 'cod_hungry')
                if hungry_card then
                    draw_card(G.deck, G.play, 90, 'up', nil, hungry_card)
                    hungry_card.getting_sliced = true
                    eaten_cards[#eaten_cards+1] = hungry_card
                    cards_eaten = cards_eaten + 1
                end
            end
            
            if cards_eaten > 0 then
                G.E_MANAGER:add_event(Event({
                    trigger = 'after',
                    delay = 1,
                    func = function()
                        return true
                    end
                }))
                SMODS.destroy_cards(eaten_cards)

                return {
                    message = localize(pseudorandom_element({"hungry_1", "hungry_2", "hungry_3", "hungry_4", "hungry_5"}, 'cod_hungry_text')),
                    colour = G.C.RED,
                }
            else
                return {
                    message = localize('hungry_cant'),
                    colour = G.C.RED,
                }
            end

        end
    end
}

-- All-Seeing Joker
SMODS.Joker {
    key = "all_seeing",
    unlocked = true,
    blueprint_compat = false,
    rarity = 1,
    cost = 4,
    atlas = 'atlas_cod_jokers',
    pos = { x = 2, y = 1 },
    config = { extra = { pack_h_size = 3, active = false } },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.pack_h_size } }
    end,
    remove_from_deck = function(self, card, from_debuff)
        if card.ability.extra.active then
            card.ability.extra.active = false
            G.hand:change_size(-card.ability.extra.pack_h_size)
        end
    end,
    calculate = function(self, card, context)
        if context.open_booster and not context.blueprint and not card.ability.extra.active then
            G.hand:change_size(card.ability.extra.pack_h_size)
            card.ability.extra.active = true

            return {
                message = localize('all_seeing_pack'),
                colour = G.C.RED,
            }
        end
        if context.ending_booster and not context.blueprint and card.ability.extra.active then
            card.ability.extra.active = false
            G.hand:change_size(-card.ability.extra.pack_h_size)
        end
    end
}

-- Resourceful Joker
SMODS.Joker {
    key = "resourceful",
    unlocked = true,
    blueprint_compat = false,
    rarity = 1,
    cost = 4,
    atlas = 'atlas_cod_jokers',
    pos = { x = 7, y = 1 },
    config = { extra = { pack_size = 1 } },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.pack_size } }
    end,
    add_to_deck = function(self, card, from_debuff)
        if not G.GAME.modifiers.booster_size_mod then
            G.GAME.modifiers.booster_size_mod = 0
        end
        G.GAME.modifiers.booster_size_mod = G.GAME.modifiers.booster_size_mod + card.ability.extra.pack_size
    end,
    remove_from_deck = function(self, card, from_debuff)
        if not G.GAME.modifiers.booster_size_mod then
            G.GAME.modifiers.booster_size_mod = 0
        end
        G.GAME.modifiers.booster_size_mod = G.GAME.modifiers.booster_size_mod - card.ability.extra.pack_size
    end,
    calculate = function(self, card, context)
        if context.open_booster and not context.blueprint then
            return {
                message = localize('resourceful_pack'),
                colour = G.C.GOLD,
            }
        end
    end
}

-- Scavenging Joker
SMODS.Joker {
    key = "scavenging",
    unlocked = true,
    blueprint_compat = false,
    rarity = 2,
    cost = 6,
    atlas = 'atlas_cod_jokers',
    pos = { x = 8, y = 1 },
    config = { extra = { pack_choices = 1 } },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.pack_choices } }
    end,
    add_to_deck = function(self, card, from_debuff)
        if not G.GAME.modifiers.booster_choice_mod then
            G.GAME.modifiers.booster_choice_mod = 0
        end
        G.GAME.modifiers.booster_choice_mod = G.GAME.modifiers.booster_choice_mod + card.ability.extra.pack_choices
    end,
    remove_from_deck = function(self, card, from_debuff)
        if not G.GAME.modifiers.booster_choice_mod then
            G.GAME.modifiers.booster_choice_mod = 0
        end
        G.GAME.modifiers.booster_choice_mod = G.GAME.modifiers.booster_choice_mod - card.ability.extra.pack_choices
    end,
    calculate = function(self, card, context)
        if context.open_booster and not context.blueprint then
            return {
                message = localize('resourceful_pack'),
                colour = G.C.GOLD,
            }
        end
    end
}

-- Bully
SMODS.Joker {
    key = "bully",
    unlocked = true,
    blueprint_compat = true,
    rarity = 1,
    cost = 4,
    atlas = 'atlas_cod_jokers',
    pos = { x = 6, y = 1 },
    config = { extra = { xmult = 2 } },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.xmult } }
    end,
    calculate = function(self, card, context)
        if context.joker_main then
			if G.GAME.blind.name == "Small Blind" then
                return {
                    xmult = card.ability.extra.xmult
                }
            end
        end
    end,
}

-- Scam
SMODS.Joker {
    key = "scam",
    unlocked = true,
    blueprint_compat = true,
    rarity = 1,
    cost = 21,
    atlas = 'atlas_cod_jokers',
    pos = { x = 0, y = 1 },
    config = { extra = { xmult = 1.1 } },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.xmult } }
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            return {
                xmult = card.ability.extra.xmult,
            }
        end
    end,
}

-- Homework
SMODS.Joker {
    key = "homework",
    unlocked = true,
    blueprint_compat = true,
    rarity = 2,
    cost = 6,
    atlas = 'atlas_cod_jokers',
    pos = { x = 1, y = 0 },
    config = { extra = { xmult = 4, sum = 2, min_sum = 2, max_sum = 55 } },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.xmult, card.ability.extra.sum } }
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            local rank_sum = 0
            for i = 1,#context.full_hand do
                rank_sum = rank_sum + context.full_hand[i].base.nominal
            end
            
            local difference = math.abs(rank_sum - card.ability.extra.sum)

            if difference == 0 then
                return {
                    xmult = card.ability.extra.xmult,
                    message = localize('homework_a'),
                    colour = G.C.GREEN,
                }
            elseif difference == 1 then
                return {
                    xmult = card.ability.extra.xmult-1,
                    message = localize('homework_c'),
                    colour = G.C.GOLD,
                }
            elseif difference == 2 then
                return {
                    xmult = card.ability.extra.xmult-2,
                    message = localize('homework_e'),
                    colour = G.C.GOLD,
                }
            else
                return {
                    message = localize('homework_f'),
                    colour = G.C.RED,
                }
            end
        end
        if context.after and not context.blueprint then
            card.ability.extra.sum = pseudorandom('cod_homework', card.ability.extra.min_sum, card.ability.extra.max_sum)
            return {
                message = localize('k_reset')
            }
        end
    end,
    --initial random roll
    set_ability = function(self, card, initial, delay_sprites)
        card.ability.extra.sum = pseudorandom('cod_homework', card.ability.extra.min_sum, card.ability.extra.max_sum)
    end
}

-- The Conspiracy
SMODS.Joker {
    key = "conspiracy",
    unlocked = false,
    blueprint_compat = true,
    rarity = 3,
    cost = 8,
    atlas = 'atlas_cod_jokers',
    pos = { x = 8, y = 0 },
    config = { extra = { xmult = 4} },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.xmult } }
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            if next(context.poker_hands["Flush House"]) or next(context.poker_hands["Flush Five"]) or next(context.poker_hands["Five of a Kind"]) then          
                return {
                    xmult = card.ability.extra.xmult
                }
            end
            -- more general solution that doesnt work
            -- for i = 1, #G.hands do
            --     if G.hands[i].visible and next(context.poker_hands[G.hands[i]]) then          
            --         return {
            --             xmult = card.ability.extra.Xmult
            --         }
            --     end
            -- end
        end
    end,
    locked_loc_vars = function(self, info_queue, card)
        return { vars = { localize('High Card', 'poker_hands') } }
    end,
    check_for_unlock = function(self, args)
        return args.type == 'win_no_hand' and G.GAME.hands['High Card'].played == 0
    end
}

-- Singularity
SMODS.Joker {
    key = "singularity",
    unlocked = false,
    blueprint_compat = true,
    rarity = 3,
    cost = 8,
    atlas = 'atlas_cod_jokers',
    pos = { x = 9, y = 0 },
    config = { extra = { xmult = 1 } },
    loc_vars = function(self, info_queue, card)
        local lowest_plays = nil
        for handname, hand in pairs(G.GAME.hands) do
            if SMODS.is_poker_hand_visible(handname) then
                if not lowest_plays then
                    lowest_plays = hand.played
                elseif lowest_plays > hand.played then
                    lowest_plays = hand.played
                end
                
            end
        end

        return { vars = { card.ability.extra.xmult, 1 + card.ability.extra.xmult * lowest_plays } }
    end,
    
    calculate = function(self, card, context)
        if context.joker_main then
            local lowest_plays = nil
            for handname, hand in pairs(G.GAME.hands) do
                if SMODS.is_poker_hand_visible(handname) then
                    if not lowest_plays then
                        lowest_plays = hand.played
                    elseif lowest_plays > hand.played then
                        lowest_plays = hand.played
                    end
                    
                end
            end
            return {
                xmult = 1 + card.ability.extra.xmult * lowest_plays
            }
        end
    end,

    check_for_unlock = function(self, args)
        if args.type == 'hand_contents' then
            local lowest_plays = nil
            for handname, hand in pairs(G.GAME.hands) do
                if SMODS.is_poker_hand_visible(handname) then
                    if not lowest_plays then
                        lowest_plays = hand.played
                    elseif lowest_plays > hand.played then
                        lowest_plays = hand.played
                    end
                    
                end
            end
            return lowest_plays >= 3
        end
    end
}

-- Anchor
SMODS.Joker {
    key = "anchor",
    unlocked = true,
    blueprint_compat = false,
    rarity = 2,
    cost = 5,
    atlas = 'atlas_cod_jokers',
    pos = { x = 9, y = 1 },
    config = { extra = { suit = "Spades", color = G.C.SUITS.Spades } },
    loc_vars = function(self, info_queue, card)
        return { vars = { localize(card.ability.extra.suit, 'suits_singular'), colours = { card.ability.extra.color } } }
    end,
    calculate = function(self, card, context)
        if context.round_shuffle and not context.blueprint then
            local suit_cards = {}
            local non_suit_cards = {}
            for _, playing_card in ipairs(G.deck.cards) do
                if playing_card:is_suit(card.ability.extra.suit) then
                    suit_cards[#suit_cards + 1] = playing_card
                else
                    non_suit_cards[#non_suit_cards + 1] = playing_card
                end
            end
            for _, non_suit_card in ipairs(non_suit_cards) do
                suit_cards[#suit_cards + 1] = non_suit_card
            end
            G.deck.cards = suit_cards

            return {
                message = localize("anchor_sink"),
                colour = card.ability.extra.color,
            }
        end
    end
}

-- Faster than light
SMODS.Joker {
    key = "faster_than_light",
    unlocked = true,
    blueprint_compat = false,
    rarity = 3,
    cost = 9,
    atlas = 'atlas_cod_jokers',
    pos = { x = 0, y = 2 },
    config = { extra = { anti_ante = 1, skips = 3, skip_counter = 0 } },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.anti_ante, card.ability.extra.skips + (G.GAME.cod_faster_than_light_penalty or 0), card.ability.extra.skip_counter } }
    end,
    calculate = function(self, card, context)
        if context.skip_blind and not context.blueprint then
            card.ability.extra.skip_counter = card.ability.extra.skip_counter + 1
            if card.ability.extra.skip_counter >= card.ability.extra.skips + (G.GAME.cod_faster_than_light_penalty or 0) then

                ease_ante(-card.ability.extra.anti_ante)
                G.GAME.round_resets.blind_ante = G.GAME.round_resets.blind_ante or G.GAME.round_resets.ante
                G.GAME.round_resets.blind_ante = G.GAME.round_resets.blind_ante - card.ability.extra.anti_ante
                
                card.ability.extra.skip_counter = 0
                G.GAME.cod_faster_than_light_penalty = G.GAME.cod_faster_than_light_penalty or 0
                G.GAME.cod_faster_than_light_penalty = G.GAME.cod_faster_than_light_penalty + 1

                -- Refresh big blind and boss blind to show correct chips requirements
                -- no idea what this code does, got it from reroll tag logic
                G.E_MANAGER:add_event(Event({
                    trigger = 'after',
                    delay = 0.3,
                    func = (function()

                        local par_big = G.blind_select_opts.big.parent
                        G.blind_select_opts.big:remove()
                        G.blind_select_opts.big = UIBox{
                        T = {par_big.T.x, 0, 0, 0, },
                        definition =
                            {n=G.UIT.ROOT, config={align = "cm", colour = G.C.CLEAR}, nodes={
                            UIBox_dyn_container({create_UIBox_blind_choice('Big')},false,get_blind_main_colour('Big'), mix_colours(G.C.BLACK, get_blind_main_colour('Big'), 0.8))
                            }},
                        config = {align="bmi",
                                    offset = {x=0,y=G.ROOM.T.y + 9},
                                    major = par_big,
                                    xy_bond = 'Weak'
                                }
                        }
                        par_big.config.object = G.blind_select_opts.big
                        par_big.config.object:recalculate()
                        G.blind_select_opts.big.parent = par_big
                        G.blind_select_opts.big.alignment.offset.y = 0

                        local par_boss = G.blind_select_opts.boss.parent
                        G.blind_select_opts.boss:remove()
                        G.blind_select_opts.boss = UIBox{
                        T = {par_boss.T.x, 0, 0, 0, },
                        definition =
                            {n=G.UIT.ROOT, config={align = "cm", colour = G.C.CLEAR}, nodes={
                            UIBox_dyn_container({create_UIBox_blind_choice('Boss')},false,get_blind_main_colour('Boss'), mix_colours(G.C.BLACK, get_blind_main_colour('Boss'), 0.8))
                            }},
                        config = {align="bmi",
                                    offset = {x=0,y=G.ROOM.T.y + 9},
                                    major = par_boss,
                                    xy_bond = 'Weak'
                                }
                        }
                        par_boss.config.object = G.blind_select_opts.boss
                        par_boss.config.object:recalculate()
                        G.blind_select_opts.boss.parent = par_boss
                        G.blind_select_opts.boss.alignment.offset.y = 0

                        return true
                    end)
                }))

                G.E_MANAGER:add_event(Event({
                    func = function()
                        save_run()
                        return true
                    end
                }))

                return {
                    message = localize("faster_than_light_jump"),
                    colour = G.C.GOLD,
                }
            else
                return {
                    message = localize("faster_than_light_charge"),
                    colour = G.C.GOLD,
                }
            end
        end
    end
}

-- Chosen One
SMODS.Joker {
    key = "chosen_one",
    unlocked = true,
    blueprint_compat = true,
    rarity = 2,
    cost = 6,
    atlas = 'atlas_cod_jokers',
    pos = { x = 1, y = 2 },
    config = {},
    calculate = function(self, card, context)
        if context.repetition and context.cardarea == G.play and G.GAME.blind.name ~= "Small Blind" and G.GAME.blind.name ~= "Big Blind" then
            return {
                repetitions = 1
            }
        end
    end
}

-- Paperclip
SMODS.Joker {
    key = "paperclip",
    unlocked = true,
    blueprint_compat = true,
    cod_confidential_compat = false,
    cod_envy_compat = false,
    rarity = 1,
    cost = 4,
    atlas = 'atlas_cod_jokers',
    pos = { x = 2, y = 2 },
    config = { extra = { mult = 8, cod_paperclip = true, just_transformed = false } },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.mult } }
    end,
    calculate = function(self, card, context)
        if context.setting_blind and not context.blind.boss and not card.ability.extra.just_transformed and not context.blueprint then
            local destructable_jokers = {}
            for i = 1, #G.jokers.cards do
                if not (type(G.jokers.cards[i].ability.extra) == "table" and G.jokers.cards[i].ability.extra.cod_paperclip) and not SMODS.is_eternal(G.jokers.cards[i], card) and not G.jokers.cards[i].getting_sliced then
                    destructable_jokers[#destructable_jokers + 1] = G.jokers.cards[i]
                end
            end
            local joker_to_destroy = pseudorandom_element(destructable_jokers, 'cod_paperclip')

            if joker_to_destroy then
                joker_to_destroy.getting_sliced = true
                G.E_MANAGER:add_event(Event({
                    func = function()
                        (context.blueprint_card or card):juice_up(0.8, 0.8)
                        joker_to_destroy:start_dissolve({ G.C.RED }, nil, 1.6)
                        return true
                    end
                }))

                G.E_MANAGER:add_event(Event({
                    func = function()
                        local copied_joker = copy_card(card, nil, nil, nil, nil)
                        copied_joker:start_materialize()
                        copied_joker:add_to_deck()
                        copied_joker.ability.extra.just_transformed = true
                        G.jokers:emplace(copied_joker)
                        return true
                    end
                }))

                -- message idea: output the percentage of jokers that are paperclips, if all are: "Task Complete"
                return { message = localize("paperclip_copy") }
            end

        end
        card.ability.extra.just_transformed = false

        if context.joker_main then
			return {
                mult = card.ability.extra.mult
            }
        end
    end,
}

-- Hiding Joker
SMODS.Joker {
    key = "hiding",
    unlocked = true,
    blueprint_compat = false,
    rarity = 2,
    cost = 6,
    atlas = 'atlas_cod_jokers',
    pos = { x = 7, y = 2 },
    config = { extra = { d_size = 3, cards_to_flip = 0 } },
    soul_pos = {
        x = 6, y = 2
    },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.d_size } }
    end,
    add_to_deck = function(self, card, from_debuff)
        G.GAME.round_resets.discards = G.GAME.round_resets.discards + card.ability.extra.d_size
        ease_discard(card.ability.extra.d_size)
    end,
    remove_from_deck = function(self, card, from_debuff)
        G.GAME.round_resets.discards = G.GAME.round_resets.discards - card.ability.extra.d_size
        ease_discard(-card.ability.extra.d_size)
    end,
    calculate = function(self, card, context)
        if not context.blueprint then
            if context.discard then
                card.ability.extra.cards_to_flip = card.ability.extra.cards_to_flip + 1
            end
            if context.stay_flipped and context.to_area == G.hand and card.ability.extra.cards_to_flip > 0 then
                card.ability.extra.cards_to_flip = card.ability.extra.cards_to_flip - 1
                return {
                    stay_flipped = true
                }
            end
            if context.setting_blind or context.hand_drawn then
                card.ability.extra.cards_to_flip = 0
            end
        end
    end,
}

-- Elitist Joker
SMODS.Joker {
    key = "elitism",
    unlocked = false,
    blueprint_compat = false,
    rarity = 3,
    cost = 9,
    atlas = 'atlas_cod_jokers',
    pos = { x = 8, y = 2 },
    config = { extra = { previous_weight = nil } },
    add_to_deck = function(self, card, from_debuff)
        card.ability.extra.previous_weight = G.GAME.common_mod
        G.GAME.common_mod = 0
    end,
    remove_from_deck = function(self, card, from_debuff)
        if card.ability.extra.previous_weight then
            G.GAME.common_mod = card.ability.extra.previous_weight
            card.ability.extra.previous_weight = nil
        end
    end,
    locked_loc_vars = function(self, info_queue, back)
        local other_name = localize('k_unknown')
        if G.P_CENTERS['b_cod_average'].unlocked then
            other_name = localize { type = 'name_text', set = 'Back', key = 'b_cod_average' }
        end

        return { vars = { other_name } }
    end,
    check_for_unlock = function(self, args)
        return args.type == 'win_deck' and get_deck_win_stake('b_cod_average') and true
    end
}


-- Black Market
SMODS.Joker {
    key = "black_market",
    blueprint_compat = false,
    rarity = 3,
    cost = 10,
    atlas = 'atlas_cod_jokers',
    pos = { x = 9, y = 2 },
    calculate = function(self, card, context)
        if context.selling_card and not context.blueprint and card ~= context.card then
            local key_to_ban = context.card.config.center.key

            G.GAME.banned_keys[key_to_ban] = true

            return {
                message = localize("black_market_ban"),
                colour = G.C.RED,
            }
        end
    end
}

-- Spam
SMODS.Joker {
    key = "spam",
    blueprint_compat = true,
    rarity = 1,
    cost = 4,
    atlas = 'atlas_cod_jokers',
    pos = { x = 0, y = 3 },
    soul_pos = { x = 1, y = 3 },
    config = { extra = { spam_cards = 2 } },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.spam_cards } }
    end,
    calculate = function(self, card, context)
        if context.first_hand_drawn then
            for i=1,card.ability.extra.spam_cards do

                local _card = SMODS.create_card { set = "Base", area = G.discard }
                G.playing_card = (G.playing_card and G.playing_card + 1) or 1
                _card.playing_card = G.playing_card
                table.insert(G.playing_cards, _card)

                G.E_MANAGER:add_event(Event({
                    func = function()
                        G.hand:emplace(_card)
                        _card:start_materialize()
                        G.GAME.blind:debuff_card(_card)
                        G.hand:sort()
                        if context.blueprint_card then
                            context.blueprint_card:juice_up()
                        else
                            card:juice_up()
                        end
                        SMODS.calculate_context({ playing_card_added = true, cards = { _card } })
                        save_run()
                        return true
                    end
                }))
                            
            end

            return {
                message = localize(pseudorandom_element({"spam_1", "spam_2", "spam_3", "spam_4", "spam_5"}, 'cod_spam_text')),
                colour = G.C.GOLD,
            }
        end
    end
}

-- Cantrip
SMODS.Joker {
    key = "cantrip",
    blueprint_compat = true,
    rarity = 1,
    cost = 4,
    atlas = 'atlas_cod_jokers',
    pos = { x = 2, y = 3 },
    config = { extra = { hands = 1, poker_hand = "High Card"} },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.hands } }
    end,
    calculate = function(self, card, context)
        if context.before and context.scoring_name == card.ability.extra.poker_hand and G.GAME.hands[context.scoring_name].played_this_round == 1 then

            local blueprint_card = context.blueprint_card

            return {
                G.E_MANAGER:add_event(Event({
                    func = function()
                        ease_hands_played(card.ability.extra.hands)
                        SMODS.calculate_effect(
                            { message = localize { type = 'variable', key = 'a_hands', vars = { card.ability.extra.hands } }, colour = G.C.BLUE, },
                            blueprint_card or card)
                        return true
                    end
                }))
            }
        end
    end,
}

-- Password
SMODS.Joker {
    key = "password",
    blueprint_compat = true,
    rarity = 2,
    cost = 6,
    atlas = 'atlas_cod_jokers',
    pos = { x = 3, y = 3 },
    config = { extra = { xmult = 2 } },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.xmult } }
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            local number = false
            local letter = false
            for i = 1, #context.scoring_hand do
                if not SMODS.has_no_rank(context.scoring_hand[i]) then
                    if context.scoring_hand[i]:get_id() >= 11 then
                        letter = true
                    end
                    if context.scoring_hand[i]:get_id() <= 10 then
                        number = true
                    end
                end
            end
            if letter and number then
                return {
                    xmult = card.ability.extra.xmult,
                }
            else
                return {
                    message = localize("password_weak"),
                    colour = G.C.RED
                }
            end
        end
    end,
}

-- Unpredictable
SMODS.Joker {
    key = "random",
    blueprint_compat = true,
    rarity = 1,
    cost = 4,
    atlas = 'atlas_cod_jokers',
    pos = { x = 8, y = 3 },
    config = { extra = { current = {}, possibilities = { xmult = 1.5, mult = 10, chips = 50, h_size = 1, discards = 1, hands = 1, sell_value = 7, probability = 1 } } },
    loc_vars = function(self, info_queue, card)
        if card.ability.extra.current.xmult then return { key = "j_cod_random_xmult", vars = { card.ability.extra.current.xmult, localize("cod_random_joker_change"), localize("cod_random_joker_name") } } end
        if card.ability.extra.current.mult then return { key = "j_cod_random_mult", vars = { card.ability.extra.current.mult, localize("cod_random_joker_change"), localize("cod_random_joker_name") } } end
        if card.ability.extra.current.chips then return { key = "j_cod_random_chips", vars = { card.ability.extra.current.chips, localize("cod_random_joker_change"), localize("cod_random_joker_name") } } end
        if card.ability.extra.current.h_size then return { key = "j_cod_random_h_size", vars = { card.ability.extra.current.h_size, localize("cod_random_joker_change"), localize("cod_random_joker_name") } } end
        if card.ability.extra.current.discards then return { key = "j_cod_random_discards", vars = { card.ability.extra.current.discards, localize("cod_random_joker_change"), localize("cod_random_joker_name") } } end
        if card.ability.extra.current.hands then return { key = "j_cod_random_hands", vars = { card.ability.extra.current.hands, localize("cod_random_joker_change"), localize("cod_random_joker_name") } } end
        if card.ability.extra.current.sell_value then return { key = "j_cod_random_sell_value", vars = { card.ability.extra.current.sell_value, localize("cod_random_joker_change"), localize("cod_random_joker_name") } } end
        if card.ability.extra.current.probability then return { key = "j_cod_random_probability", vars = { card.ability.extra.current.probability, localize("cod_random_joker_change"), localize("cod_random_joker_name") } } end
    end,
    add_to_deck = function(self, card, from_debuff)
        if card.ability.extra.current.h_size then
            G.hand:change_size(card.ability.extra.current.h_size)
        end
        if card.ability.extra.current.hands then
            G.GAME.round_resets.hands = G.GAME.round_resets.hands + card.ability.extra.current.hands
            ease_hands_played(card.ability.extra.current.hands)
        end
        if card.ability.extra.current.discards then
            G.GAME.round_resets.discards = G.GAME.round_resets.discards + card.ability.extra.current.discards
            ease_discard(card.ability.extra.current.discards)
        end
    end,
    remove_from_deck = function(self, card, from_debuff)
        if card.ability.extra.current.h_size then
            G.hand:change_size(-card.ability.extra.current.h_size)
        end
        if card.ability.extra.current.hands then
            G.GAME.round_resets.hands = G.GAME.round_resets.hands - card.ability.extra.current.hands
            ease_hands_played(-card.ability.extra.current.hands)
        end
        if card.ability.extra.current.discards then
            G.GAME.round_resets.discards = G.GAME.round_resets.discards - card.ability.extra.current.discards
            ease_discard(-card.ability.extra.current.discards)
        end
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            if card.ability.extra.current.xmult or card.ability.extra.current.mult or card.ability.extra.current.chips then
                return card.ability.extra.current
            end
        end

        if context.mod_probability and card.ability.extra.current.probability then
            return {
                numerator = context.numerator + card.ability.extra.current.probability
            }
        end

        if context.end_of_round and context.game_over == false and context.main_eval and not context.blueprint then

            if card.ability.extra.current.discards then
                G.GAME.round_resets.discards = G.GAME.round_resets.discards - card.ability.extra.current.discards
                ease_discard(-card.ability.extra.current.discards)
            end

            if card.ability.extra.current.hands then
                G.GAME.round_resets.hands = G.GAME.round_resets.hands - card.ability.extra.current.hands
                ease_hands_played(-card.ability.extra.current.hands)
            end

            if card.ability.extra.current.h_size then
                G.hand:change_size(-card.ability.extra.current.h_size)
            end

            if card.ability.extra.current.sell_value then
                card.ability.extra_value = card.ability.extra_value - card.ability.extra.current.sell_value
            end

            local c_val, c_key = pseudorandom_element(card.ability.extra.possibilities, 'cod_random_joker')
            card.ability.extra.current = {}
            card.ability.extra.current[c_key] = c_val

            if card.ability.extra.current.discards then
                G.GAME.round_resets.discards = G.GAME.round_resets.discards + card.ability.extra.current.discards
                ease_discard(card.ability.extra.current.discards)
            end

            if card.ability.extra.current.hands then
                G.GAME.round_resets.hands = G.GAME.round_resets.hands + card.ability.extra.current.hands
                ease_hands_played(card.ability.extra.current.hands)
            end

            if card.ability.extra.current.h_size then
                G.hand:change_size(card.ability.extra.current.h_size)
            end

            if card.ability.extra.current.sell_value then
                card.ability.extra_value = card.ability.extra_value + card.ability.extra.current.sell_value
            end
            card:set_cost()

            return {
                message = localize('k_reset')
            }
        end
    end,
    --initial random roll
    set_ability = function(self, card, initial, delay_sprites)
        local c_val, c_key = pseudorandom_element(card.ability.extra.possibilities, 'cod_random_joker')
        card.ability.extra.current = {}
        card.ability.extra.current[c_key] = c_val

        if card.ability.extra.current.sell_value then
            card.ability.extra_value = card.ability.extra_value + card.ability.extra.current.sell_value
        end
    end
}

-- Possibility space
SMODS.Joker {
    key = "random_big",
    blueprint_compat = true,
    rarity = 2,
    cost = 6,
    atlas = 'atlas_cod_jokers',
    pos = { x = 9, y = 3 },
    config = { extra = { current = {}, possibilities = { xmult = 3, mult = 50, chips = 250, h_size = 2, discards = 3, hands = 2, sell_value = 20, probability = 2, retrigger = true } } },
    loc_vars = function(self, info_queue, card)
        if card.ability.extra.current.xmult then return { key = "j_cod_random_xmult", vars = { card.ability.extra.current.xmult, localize("cod_random_joker_change"), localize("cod_random_big_joker_name") } } end
        if card.ability.extra.current.mult then return { key = "j_cod_random_mult", vars = { card.ability.extra.current.mult, localize("cod_random_joker_change"), localize("cod_random_big_joker_name") } } end
        if card.ability.extra.current.chips then return { key = "j_cod_random_chips", vars = { card.ability.extra.current.chips, localize("cod_random_joker_change"), localize("cod_random_big_joker_name") } } end
        if card.ability.extra.current.h_size then return { key = "j_cod_random_h_size", vars = { card.ability.extra.current.h_size, localize("cod_random_joker_change"), localize("cod_random_big_joker_name") } } end
        if card.ability.extra.current.discards then return { key = "j_cod_random_discards", vars = { card.ability.extra.current.discards, localize("cod_random_joker_change"), localize("cod_random_big_joker_name") } } end
        if card.ability.extra.current.hands then return { key = "j_cod_random_hands", vars = { card.ability.extra.current.hands, localize("cod_random_joker_change"), localize("cod_random_big_joker_name") } } end
        if card.ability.extra.current.sell_value then return { key = "j_cod_random_sell_value", vars = { card.ability.extra.current.sell_value, localize("cod_random_joker_change"), localize("cod_random_big_joker_name") } } end
        if card.ability.extra.current.probability then return { key = "j_cod_random_probability", vars = { card.ability.extra.current.probability, localize("cod_random_joker_change"), localize("cod_random_big_joker_name") } } end
        if card.ability.extra.current.retrigger then return { key = "j_cod_random_retrigger", vars = { localize("cod_random_joker_change"), localize("cod_random_big_joker_name") } } end
    end,
    add_to_deck = function(self, card, from_debuff)
        if card.ability.extra.current.h_size then
            G.hand:change_size(card.ability.extra.current.h_size)
        end
        if card.ability.extra.current.hands then
            G.GAME.round_resets.hands = G.GAME.round_resets.hands + card.ability.extra.current.hands
            ease_hands_played(card.ability.extra.current.hands)
        end
        if card.ability.extra.current.discards then
            G.GAME.round_resets.discards = G.GAME.round_resets.discards + card.ability.extra.current.discards
            ease_discard(card.ability.extra.current.discards)
        end
    end,
    remove_from_deck = function(self, card, from_debuff)
        if card.ability.extra.current.h_size then
            G.hand:change_size(-card.ability.extra.current.h_size)
        end
        if card.ability.extra.current.hands then
            G.GAME.round_resets.hands = G.GAME.round_resets.hands - card.ability.extra.current.hands
            ease_hands_played(-card.ability.extra.current.hands)
        end
        if card.ability.extra.current.discards then
            G.GAME.round_resets.discards = G.GAME.round_resets.discards - card.ability.extra.current.discards
            ease_discard(-card.ability.extra.current.discards)
        end
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            if card.ability.extra.current.xmult or card.ability.extra.current.mult or card.ability.extra.current.chips then
                return card.ability.extra.current
            end
        end

        if context.repetition and context.cardarea == G.play and card.ability.extra.current.retrigger then
            return {
                repetitions = 1
            }
        end

        if context.mod_probability and card.ability.extra.current.probability then
            return {
                numerator = context.numerator + card.ability.extra.current.probability
            }
        end

        if context.end_of_round and context.game_over == false and context.main_eval and not context.blueprint then

            if card.ability.extra.current.discards then
                G.GAME.round_resets.discards = G.GAME.round_resets.discards - card.ability.extra.current.discards
                ease_discard(-card.ability.extra.current.discards)
            end

            if card.ability.extra.current.hands then
                G.GAME.round_resets.hands = G.GAME.round_resets.hands - card.ability.extra.current.hands
                ease_hands_played(-card.ability.extra.current.hands)
            end

            if card.ability.extra.current.h_size then
                G.hand:change_size(-card.ability.extra.current.h_size)
            end

            if card.ability.extra.current.sell_value then
                card.ability.extra_value = card.ability.extra_value - card.ability.extra.current.sell_value
            end

            local c_val, c_key = pseudorandom_element(card.ability.extra.possibilities, 'cod_random_big_joker')
            card.ability.extra.current = {}
            card.ability.extra.current[c_key] = c_val

            if card.ability.extra.current.discards then
                G.GAME.round_resets.discards = G.GAME.round_resets.discards + card.ability.extra.current.discards
                ease_discard(card.ability.extra.current.discards)
            end

            if card.ability.extra.current.hands then
                G.GAME.round_resets.hands = G.GAME.round_resets.hands + card.ability.extra.current.hands
                ease_hands_played(card.ability.extra.current.hands)
            end

            if card.ability.extra.current.h_size then
                G.hand:change_size(card.ability.extra.current.h_size)
            end

            if card.ability.extra.current.sell_value then
                card.ability.extra_value = card.ability.extra_value + card.ability.extra.current.sell_value
            end
            card:set_cost()

            return {
                message = localize('k_reset')
            }
        end
    end,
    --initial random roll
    set_ability = function(self, card, initial, delay_sprites)
        local c_val, c_key = pseudorandom_element(card.ability.extra.possibilities, 'cod_random_big_joker')
        card.ability.extra.current = {}
        card.ability.extra.current[c_key] = c_val

        if card.ability.extra.current.sell_value then
            card.ability.extra_value = card.ability.extra_value + card.ability.extra.current.sell_value
        end
    end
}

-- Ricochet
SMODS.Joker {
    key = "ricochet",
    blueprint_compat = true,
    rarity = 2,
    cost = 6,
    atlas = 'atlas_cod_jokers',
    pos = { x = 0, y = 4 },
    config = { extra = { odds = 2 } },
    loc_vars = function(self, info_queue, card)
        local numerator, denominator1 = SMODS.get_probability_vars(card, 1, card.ability.extra.odds, 'cod_ricochet')
        local denominator2 = denominator1 + 1
        local denominator3 = denominator2 + 1
        return { vars = {numerator, denominator1, denominator2, denominator3} }
    end,
    calculate = function(self, card, context)
        if context.repetition and context.cardarea == G.play and context.other_card:is_suit("Diamonds") then
            local bounces = 0
            local odds = card.ability.extra.odds
            for i=1,256 do
                if SMODS.pseudorandom_probability(card, 'cod_ricochet', 1, odds) then
                    bounces = bounces + 1
                    odds = odds + 1
                else
                    break
                end
            end
            
            if bounces>0 then
                return {
                    repetitions = bounces
                }
            end
        end
    end
}

-- Unlucky joker
SMODS.Joker {
    key = "unlucky",
    blueprint_compat = true,
    perishable_compat = false,
    rarity = 2,
    cost = 6,
    atlas = 'atlas_cod_jokers',
    pos = { x = 1, y = 4 },
    config = { extra = { odds = 3, chips = 0, chips_mod = 4 } },
    loc_vars = function(self, info_queue, card)
        local numerator, denominator = SMODS.get_probability_vars(card, 1, card.ability.extra.odds, 'cod_unlucky')
        return { vars = { numerator, denominator, card.ability.extra.chips, card.ability.extra.chips_mod, } }
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            if SMODS.pseudorandom_probability(card, 'cod_unlucky', 1, card.ability.extra.odds) then
                return {
                    chips = card.ability.extra.chips
                }
            end
        end
        if context.pseudorandom_result and not context.blueprint and not context.result then
            card.ability.extra.chips = card.ability.extra.chips + card.ability.extra.chips_mod
            return {
                message = localize("k_upgrade_ex"),
                colour = G.C.CHIPS,
            }
        end
    end
}

-- Tapas
SMODS.Joker {
    key = "tapas",
    blueprint_compat = true,
    eternal_compat = false,
    rarity = 1,
    cost = 4,
    atlas = 'atlas_cod_jokers',
    pos = { x = 2, y = 4 },
    config = { extra = { dishes = 3, current = {}, possibilities = { xmult = 1.5, mult = 10, chips = 50, h_size = 1, discards = 1, hands = 1, probability = 1 } } },
    loc_vars = function(self, info_queue, card)
        local effects = {}
        local colors = {}
        local index = 1
        for k, v in pairs(card.ability.extra.current) do
            if k == "xmult" then
                effects[index] = "X"..tostring(v)
                effects[index+1] = "Mult"
                colors[index] = G.C.WHITE
                colors[index+1] = G.C.RED
            end
            if k == "mult" then
                effects[index] = "+"..tostring(v)
                effects[index+1] = "Mult"
                colors[index] = G.C.RED
                colors[index+1] = G.C.WHITE
            end
            if k == "chips" then
                effects[index] = "+"..tostring(v)
                effects[index+1] = "Chips"
                colors[index] = G.C.BLUE
                colors[index+1] = G.C.WHITE
            end
            if k == "h_size" then
                effects[index] = "+"..tostring(v)
                effects[index+1] = "hand size"
                colors[index] = G.C.ORANGE
                colors[index+1] = G.C.WHITE
            end
            if k == "discards" then
                effects[index] = "+"..tostring(v)
                effects[index+1] = "discards"
                colors[index] = G.C.RED
                colors[index+1] = G.C.WHITE
            end
            if k == "hands" then 
                effects[index] = "+"..tostring(v)
                effects[index+1] = "Hands"
                colors[index] = G.C.BLUE
                colors[index+1] = G.C.WHITE
            end
            if k == "sell_value" then
                effects[index] = "+$"..tostring(v)
                effects[index+1] = "sell value"
                colors[index] = G.C.GOLD
                colors[index+1] = G.C.WHITE
            end
            if k == "probability" then
                effects[index] = "+"..tostring(v)
                effects[index+1] = "probability"
                colors[index] = G.C.GREEN
                colors[index+1] = G.C.WHITE
            end
            index = index + 2
        end

        effects["colours"] = colors;

        return {
            vars = effects,
            key = "j_cod_tapas_"..tostring(card.ability.extra.dishes),
        }

    end,
    add_to_deck = function(self, card, from_debuff)
        if card.ability.extra.current.h_size then
            G.hand:change_size(card.ability.extra.current.h_size)
        end
        if card.ability.extra.current.hands then
            G.GAME.round_resets.hands = G.GAME.round_resets.hands + card.ability.extra.current.hands
            ease_hands_played(card.ability.extra.current.hands)
        end
        if card.ability.extra.current.discards then
            G.GAME.round_resets.discards = G.GAME.round_resets.discards + card.ability.extra.current.discards
            ease_discard(card.ability.extra.current.discards)
        end
    end,
    remove_from_deck = function(self, card, from_debuff)
        if card.ability.extra.current.h_size then
            G.hand:change_size(-card.ability.extra.current.h_size)
        end
        if card.ability.extra.current.hands then
            G.GAME.round_resets.hands = G.GAME.round_resets.hands - card.ability.extra.current.hands
            ease_hands_played(-card.ability.extra.current.hands)
        end
        if card.ability.extra.current.discards then
            G.GAME.round_resets.discards = G.GAME.round_resets.discards - card.ability.extra.current.discards
            ease_discard(-card.ability.extra.current.discards)
        end
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            if card.ability.extra.current.xmult or card.ability.extra.current.mult or card.ability.extra.current.chips then
                return card.ability.extra.current
            end
        end

        if context.mod_probability and card.ability.extra.current.probability then
            return {
                numerator = context.numerator + card.ability.extra.current.probability
            }
        end

        if context.end_of_round and context.game_over == false and context.main_eval and not context.blueprint then

            card.ability.extra.dishes = card.ability.extra.dishes - 1

            local _, c_key = pseudorandom_element(card.ability.extra.current, 'cod_random_joker')

            if c_key == "discards" then
                G.GAME.round_resets.discards = G.GAME.round_resets.discards - card.ability.extra.current.discards
                ease_discard(-card.ability.extra.current.discards)
            end

            if c_key == "hands" then
                G.GAME.round_resets.hands = G.GAME.round_resets.hands - card.ability.extra.current.hands
                ease_hands_played(-card.ability.extra.current.hands)
            end

            if c_key == "h_size" then
                G.hand:change_size(-card.ability.extra.current.h_size)
            end

            if c_key == "sell_value" then
                card.ability.extra_value = card.ability.extra_value - card.ability.extra.current.sell_value
            end

            card.ability.extra.current[c_key] = nil

            card:set_cost()

            if card.ability.extra.dishes == 0 then
                SMODS.destroy_cards(card, nil, nil, true)
                return {
                    message = localize('k_eaten_ex')
                }
            else
                return {
                    message = localize('tapas_bite')
                }
            end
        end
    end,
    --initial random roll
    set_ability = function(self, card, initial, delay_sprites)
        card.ability.extra.current = {}
        
        for i=1,card.ability.extra.dishes do
            local c_val, c_key = pseudorandom_element(card.ability.extra.possibilities, 'cod_random_joker')
            card.ability.extra.current[c_key] = c_val
            card.ability.extra.possibilities[c_key] = nil
        end

        if card.ability.extra.current.sell_value then
            card.ability.extra_value = card.ability.extra_value + card.ability.extra.current.sell_value
        end
    end
}

-- Stargazer
SMODS.Joker {
    key = "stargazer",
    blueprint_compat = true,
    rarity = 1,
    cost = 4,
    atlas = 'atlas_cod_jokers',
    pos = { x = 3, y = 4 },
    calculate = function(self, card, context)
        if context.setting_blind and #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
            G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
            G.E_MANAGER:add_event(Event({
                func = (function()
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            SMODS.add_card {
                                set = 'Planet',
                                key_append = 'cod_stargazer'
                            }
                            G.GAME.consumeable_buffer = 0
                            return true
                        end
                    }))
                    SMODS.calculate_effect({ message = localize('k_plus_planet'), colour = G.C.SECONDARY_SET.Planet },
                        context.blueprint_card or card)
                    return true
                end)
            }))
            return nil, true
        end
    end,
}

-- Gear Stick
SMODS.Joker {
    key = "gear_stick",
    blueprint_compat = true,
    rarity = 2,
    cost = 7,
    atlas = 'atlas_cod_jokers',
    pos = { x = 4, y = 4 },
    config = { extra = { xmult = 0.2 } },
    loc_vars = function(self, info_queue, card)
        local gear = 0
        local passed_self = false
        if G.jokers then
            for i = 1, #G.jokers.cards do
                if G.jokers.cards[i].ability.set == 'Joker' then
                    if G.jokers.cards[i] == card then
                        passed_self = true
                    else
                        if passed_self then
                            gear = gear + 1
                        else
                            gear = gear - 1
                        end
                    end
                end
            end
        end
        return { vars = { card.ability.extra.xmult, 1 + (gear*card.ability.extra.xmult) } }
    end,
    calculate = function(self, card, context)
        local gear = 0
        local passed_self = false
        if context.joker_main then
            for i = 1, #G.jokers.cards do
                if G.jokers.cards[i].ability.set == 'Joker' then
                    if G.jokers.cards[i] == card then
                        passed_self = true
                    else
                        if passed_self then
                            gear = gear + 1
                        else
                            gear = gear - 1
                        end
                    end
                end
            end
            return {
                xmult = 1 + (gear*card.ability.extra.xmult)
            }
        end
    end,
}

-- Limbo
SMODS.Joker {
    key = "limbo",
    blueprint_compat = true,
    perishable_compat = false,
    rarity = 1,
    cost = 6,
    atlas = 'atlas_cod_jokers',
    pos = { x = 5, y = 4 },
    config = { extra = { mult_gain = 1, mult = 0 } },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.mult_gain, card.ability.extra.mult } }
    end,
    calculate = function(self, card, context)
        if context.before and not context.blueprint then
            if context.scoring_name == "High Card" then
                local last_mult = card.ability.extra.mult
                card.ability.extra.mult = 0
                if last_mult > 0 then
                    return {
                        message = localize('k_reset')
                    }
                end
            else
                card.ability.extra.mult = card.ability.extra.mult + card.ability.extra.mult_gain
            end
        end
        if context.joker_main then
            return {
                mult = card.ability.extra.mult
            }
        end
    end,
}

-- Patent
SMODS.Joker {
    key = "patent",
    blueprint_compat = true,
    rarity = 1,
    cost = 4,
    atlas = 'atlas_cod_jokers',
    pos = { x = 6, y = 4 },
    config = { extra = {  dollars = 5 } },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.dollars } }
    end,
    calculate = function(self, card, context)
        if context.before and G.GAME.hands[context.scoring_name].played == 1 then
            G.GAME.dollar_buffer = (G.GAME.dollar_buffer or 0) + card.ability.extra.dollars
            return {
                dollars = card.ability.extra.dollars,
                func = function()
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            G.GAME.dollar_buffer = 0
                            return true
                        end
                    }))
                end
            }
        end
    end,
    in_pool = function(self, args)
        for handname, hand in pairs(G.GAME.hands) do
            if G.GAME.hands[handname].played == 0 then
                return true
            end
        end
        return false
    end,
}

-- Rule of Three
SMODS.Joker {
    key = "rule_of_three",
    blueprint_compat = true,
    rarity = 2,
    cost = 7,
    atlas = 'atlas_cod_jokers',
    pos = { x = 7, y = 4 },
    config = { extra = { xmult = 3, required = 3, rank = 3, count = 0 } },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.xmult,card.ability.extra.required, card.ability.extra.rank, card.ability.extra.count } }
    end,
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play and context.other_card:get_id() == 3 then
            card.ability.extra.count = card.ability.extra.count + 1
            if (card.ability.extra.count >= card.ability.extra.required) then
                card.ability.extra.count = 0
                return {
                    xmult = card.ability.extra.xmult
                }
            end
        end
    end,
}

-- Astral Transit
SMODS.Joker {
    key = "astral_transit",
    blueprint_compat = true,
    rarity = 1,
    cost = 4,
    atlas = 'atlas_cod_jokers',
    pos = { x = 8, y = 4 },
    calculate = function(self, card, context)
         if context.using_consumeable and context.consumeable.ability.set == 'Planet' then
            local _poker_hands = {}
            for handname, _ in pairs(G.GAME.hands) do
                if SMODS.is_poker_hand_visible(handname) and handname ~= context.consumeable.ability.hand_type then
                    _poker_hands[#_poker_hands + 1] = handname
                end
            end
            local transit_planet = pseudorandom_element(_poker_hands, 'cod_astral_transit')
            SMODS.upgrade_poker_hands({hands = transit_planet, level_up = 1, from = card})
        end
    end,
}

-- Death Star
SMODS.Joker {
    key = "death_star",
    blueprint_compat = true,
    perishable_compat = false,
    rarity = 3,
    cost = 9,
    atlas = 'atlas_cod_jokers',
    pos = { x = 9, y = 4 },
    config = { extra = {  chips = 0, mult = 0 } },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.chips, card.ability.extra.mult } }
    end,
    calculate = function(self, card, context)
        if context.before and not context.blueprint then
            local level_ups = G.GAME.hands[context.scoring_name].level - 1
            if level_ups > 0 then

                -- update to work better with custom scaled hands? just check chips before vs chips after?
                card.ability.extra.chips = card.ability.extra.chips + (G.GAME.hands[context.scoring_name].l_chips*level_ups)
                card.ability.extra.mult = card.ability.extra.mult + (G.GAME.hands[context.scoring_name].l_mult*level_ups)

                SMODS.upgrade_poker_hands({hands = context.scoring_name, level_up = -level_ups, from = card})

                return {
                    message = localize("death_star_destroy"),
                    colour = G.C.RED,
                }
            end
        end
        if context.joker_main then
            return {
                chips = card.ability.extra.chips,
                mult = card.ability.extra.mult,
            }
        end
    end,
}

-- Infrastructure
SMODS.Joker {
    key = "infrastructure",
    unlocked = true,
    blueprint_compat = true,
    rarity = 1,
    cost = 4,
    atlas = 'atlas_cod_jokers',
    pos = { x = 0, y = 5 },
    -- amount is unused
    config = { extra = { amount = 1 } },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.amount } }
    end,
    calculate = function(self, card, context)
        if context.setting_blind then
            local valid_enhance_cards = {}
            for _, playing_card in ipairs(G.playing_cards) do
                if not next(SMODS.get_enhancements(playing_card)) and not playing_card.getting_sliced then
                    valid_enhance_cards[#valid_enhance_cards + 1] = playing_card
                end
            end
            local enhance_card = pseudorandom_element(valid_enhance_cards, 'cod_infrastructure')
            if enhance_card then
                draw_card(G.deck, G.play, 90, 'up', nil, enhance_card)

                G.E_MANAGER:add_event(Event({
                    trigger = 'after',
                    delay = 1,
                    func = function()
                        return true
                    end
                }))

                -- bug: to stone animation instantly removes rank and suit
                local random_enhancement = SMODS.poll_enhancement {key = "cod_infrastructure", guaranteed = true}
                enhance_card:set_ability(random_enhancement, nil, true)

                G.E_MANAGER:add_event(Event({
                    trigger = 'after',
                    delay = 1,
                    func = function()
                        return true
                    end
                }))

                draw_card(G.play, G.deck, 90, 'up', nil, enhance_card)
                
                return {
                    message = localize('infrastructure_build'),
                    colour = G.C.GOLD,
                }
            end

        end
    end
}

-- Printer
SMODS.Joker {
    key = "printer",
    unlocked = true,
    blueprint_compat = true,
    rarity = 1,
    cost = 4,
    atlas = 'atlas_cod_jokers',
    pos = { x = 1, y = 5 },
    config = { extra = { rank = "Ace", suit = "Hearts" } },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.rank, card.ability.extra.suit, colours = { G.C.SUITS[card.ability.extra.suit] } } }
    end,
    calculate = function(self, card, context)
        if context.setting_blind then
            
            local printer_card = SMODS.create_card { set = "Base", suit = card.ability.extra.suit, rank = card.ability.extra.rank, area = G.discard }
            G.playing_card = (G.playing_card and G.playing_card + 1) or 1
            printer_card.playing_card = G.playing_card
            table.insert(G.playing_cards, printer_card)

            G.E_MANAGER:add_event(Event({
                func = function()
                    printer_card:start_materialize()
                    G.play:emplace(printer_card)
                    return true
                end
            }))

            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 1,
                func = function()
                    G.deck.config.card_limit = G.deck.config.card_limit + 1
                    return true
                end
            }))

            draw_card(G.play, G.deck, 90, 'up', nil, printer_card)

            SMODS.calculate_context({ playing_card_added = true, cards = { printer_card } })
            return {
                message = localize('printer_print'),
                colour = G.C.GOLD,
            }
        end
    end,
    set_ability = function(self, card, initial, delay_sprites)
        card.ability.extra.suit = pseudorandom_element(SMODS.Suits, 'cod_printer_suit').key
        card.ability.extra.rank = pseudorandom_element(SMODS.Ranks, 'cod_printer_rank').key
    end
}

-- The Sun
SMODS.Joker {
    key = "the_sun",
    unlocked = true,
    blueprint_compat = true,
    rarity = 2,
    cost = 6,
    atlas = 'atlas_cod_jokers',
    pos = { x = 3, y = 5 },
    calculate = function(self, card, context)
        if context.end_of_round and context.game_over == false and context.main_eval and context.beat_boss then
            update_hand_text({ sound = 'button', volume = 0.7, pitch = 0.8, delay = 0.3 },
                { handname = localize('k_all_hands'), chips = '...', mult = '...', level = '' })
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.2,
                func = function()
                    play_sound('tarot1')
                    card:juice_up(0.8, 0.5)
                    G.TAROT_INTERRUPT_PULSE = true
                    return true
                end
            }))
            update_hand_text({ delay = 0 }, { mult = '+', StatusText = true })
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.9,
                func = function()
                    play_sound('tarot1')
                    card:juice_up(0.8, 0.5)
                    return true
                end
            }))
            update_hand_text({ delay = 0 }, { chips = '+', StatusText = true })
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.9,
                func = function()
                    play_sound('tarot1')
                    card:juice_up(0.8, 0.5)
                    G.TAROT_INTERRUPT_PULSE = nil
                    return true
                end
            }))
            update_hand_text({ sound = 'button', volume = 0.7, pitch = 0.9, delay = 0 }, { level = '+1' })
            delay(1.3)
            SMODS.upgrade_poker_hands({ instant = true })
            update_hand_text({ sound = 'button', volume = 0.7, pitch = 1.1, delay = 0 },
                { mult = 0, chips = 0, handname = '', level = '' })
            return {
                message = localize('sun_upgrade'),
                colour = G.C.RED
            }
        end
    end,
}

-- Dyson Sphere
-- SMODS.Joker {
--     key = "dyson_sphere",
--     unlocked = true,
--     blueprint_compat = true,
--     rarity = 2,
--     cost = 6,
--     atlas = 'atlas_cod_jokers',
--     pos = { x = 4, y = 5 },
--     calculate = function(self, card, context)
        
--     end,
-- }

-- Shackles
SMODS.Joker {
    key = "shackles",
    unlocked = true,
    blueprint_compat = true,
    rarity = 1,
    cost = 1,
    atlas = 'atlas_cod_jokers',
    pos = { x = 5, y = 5 },
    config = { card_limit = 1, extra = { xmult = 0.5 } },
    loc_vars = function(self, info_queue, card)
        return { vars = { 1, card.ability.extra.xmult } }
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            return {
                xmult = card.ability.extra.xmult,
            }
        end
    end,
}

-- Stellar Void
SMODS.Joker {
    key = "stellar_void",
    unlocked = true,
    blueprint_compat = true,
    rarity = 1,
    cost = 4,
    atlas = 'atlas_cod_jokers',
    pos = { x = 8, y = 5 },
    config = { extra = { mult = 2 } },
    loc_vars = function(self, info_queue, card)
        local unplayed = 0
        for _, hand in pairs(G.GAME.hands) do
            if hand.played == 0 then
                unplayed = unplayed + 1
            end
        end

        return { vars = { card.ability.extra.mult, unplayed*card.ability.extra.mult } }
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            local unplayed = 0
            for _, hand in pairs(G.GAME.hands) do
                if hand.played == 0 then
                    unplayed = unplayed + 1
                end
            end
            return {
                mult = unplayed * card.ability.extra.mult,
            }
        end
    end,
}

-- Stellar Cluster
SMODS.Joker {
    key = "stellar_cluster",
    unlocked = true,
    blueprint_compat = true,
    rarity = 1,
    cost = 4,
    atlas = 'atlas_cod_jokers',
    pos = { x = 7, y = 5 },
    config = { extra = { mult = 3 } },
    loc_vars = function(self, info_queue, card)
        local played = 0
        for _, hand in pairs(G.GAME.hands) do
            if hand.played > 0 then
                played = played + 1
            end
        end

        return { vars = { card.ability.extra.mult, played*card.ability.extra.mult } }
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            local played = 0
            for _, hand in pairs(G.GAME.hands) do
                if hand.played > 0 then
                    played = played + 1
                end
            end
            return {
                mult = played * card.ability.extra.mult,
            }
        end
    end,
}

-- Taxes
SMODS.Joker {
    key = "taxes",
    unlocked = true,
    blueprint_compat = true,
    rarity = 1,
    cost = 4,
    atlas = 'atlas_cod_jokers',
    pos = { x = 9, y = 5 },
    config = { extra = { mult = 1, cap = 25 } },
    loc_vars = function(self, info_queue, card)
        local played = 0
        for _, hand in pairs(G.GAME.hands) do
            if hand.played > 0 then
                played = played + 1
            end
        end

        return { vars = { card.ability.extra.mult, card.ability.extra.cap, math.max(0, card.ability.extra.cap - (G.GAME.dollars*card.ability.extra.mult)) } }
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            if context.joker_main then
                return {
                    mult = math.max(0, card.ability.extra.cap - (G.GAME.dollars*card.ability.extra.mult))
                }
            end
        end
    end,
}

-- Knockoff
SMODS.Joker {
    key = "knockoff",
    unlocked = true,
    blueprint_compat = true,
    rarity = 2,
    cost = 8,
    atlas = 'atlas_cod_jokers',
    pos = { x = 0, y = 6 },
    config = {},
    loc_vars = function(self, info_queue, card)
        if card.area and card.area == G.jokers then
            local lowest_cost = nil
            local other_joker = nil
            for i = 1, #G.jokers.cards do
                if G.jokers.cards[i] ~= card and (not lowest_cost or (lowest_cost and card.sell_cost<lowest_cost)) then
                    lowest_cost = card.sell_cost
                    other_joker = G.jokers.cards[i]
                end
            end
            local compatible = other_joker and other_joker ~= card and other_joker.config.center.blueprint_compat
            main_end = {
                {
                    n = G.UIT.C,
                    config = { align = "bm", minh = 0.4 },
                    nodes = {
                        {
                            n = G.UIT.C,
                            config = { ref_table = card, align = "m", colour = compatible and mix_colours(G.C.GREEN, G.C.JOKER_GREY, 0.8) or mix_colours(G.C.RED, G.C.JOKER_GREY, 0.8), r = 0.05, padding = 0.06 },
                            nodes = {
                                { n = G.UIT.T, config = { text = ' ' .. localize('k_' .. (compatible and 'compatible' or 'incompatible')) .. ' ', colour = G.C.UI.TEXT_LIGHT, scale = 0.32 * 0.8 } },
                            }
                        }
                    }
                }
            }
            return { main_end = main_end }
        end
    end,
    calculate = function(self, card, context)
        local lowest_cost = nil
        local other_joker = nil
        for i = 1, #G.jokers.cards do
            if G.jokers.cards[i] ~= card and (not lowest_cost or (lowest_cost and card.sell_cost<lowest_cost)) then
                lowest_cost = card.sell_cost
                other_joker = G.jokers.cards[i]
            end
        end
        local ret = SMODS.blueprint_effect(card, other_joker, context)
        if ret then
            ret.colour = G.C.GOLD
        end
        return ret
    end,
    check_for_unlock = function(self, args)
        return args.type == 'win_custom'
    end
}

-- Delivery
SMODS.Joker {
    key = "delivery",
    unlocked = true,
    blueprint_compat = true,
    rarity = 1,
    cost = 4,
    atlas = 'atlas_cod_jokers',
    pos = { x = 1, y = 6 },
    config = { extra = { dollars = 8 } },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.dollars } }
    end,
    calculate = function(self, card, context)
        if context.skip_blind then
            G.GAME.dollar_buffer = (G.GAME.dollar_buffer or 0) + card.ability.extra.dollars
            return {
                dollars = card.ability.extra.dollars,
                func = function()
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            G.GAME.dollar_buffer = 0
                            return true
                        end
                    }))
                end
            }
        end
    end
}

-- Gambler
SMODS.Joker {
    key = "gambler",
    unlocked = true,
    blueprint_compat = true,
    perishable_compat = false,
    rarity = 1,
    cost = 5,
    atlas = 'atlas_cod_jokers',
    pos = { x = 2, y = 6 },
    config = { extra = { mult = 0, mult_gain = 3, odds = 8 } },
    loc_vars = function(self, info_queue, card)
        local numerator, denominator = SMODS.get_probability_vars(card, 1, card.ability.extra.odds, 'cod_gambler')
        return { vars = { numerator, denominator, card.ability.extra.mult, card.ability.extra.mult_gain, } }
    end,
    calculate = function(self, card, context)
        if context.before and not context.blueprint then
            if context.scoring_name == "High Card" then
                card.ability.extra.mult = card.ability.extra.mult + card.ability.extra.mult_gain
                if SMODS.pseudorandom_probability(card, 'cod_gambler', 1, card.ability.extra.odds) then
                    SMODS.destroy_cards(card, nil, nil, true)
                    return {
                        colour = G.C.RED,
                        message = localize('gambler_ruined'),
                    }
                else
                    return {
                        colour = G.C.RED,
                        message = localize('gambler_win'),
                    }
                end
            end
        end
        if context.joker_main then
            return {
                mult = card.ability.extra.mult
            }
        end
    end
}

-- Coin Toss
SMODS.Joker {
    key = "coin_toss",
    unlocked = true,
    blueprint_compat = false,
    rarity = 1,
    cost = 2,
    atlas = 'atlas_cod_jokers',
    pos = { x = 3, y = 6 },
    config = { extra = { odds = 2 } },
    loc_vars = function(self, info_queue, card)
        local numerator, denominator = SMODS.get_probability_vars(card, 1, card.ability.extra.odds, 'cod_coin_toss')
        return { vars = { numerator, denominator } }
    end,
    calculate = function(self, card, context)
        if context.before and not context.blueprint then
            if context.scoring_name == "High Card" then
                card.ability.extra_value = card.ability.extra_value + card.sell_cost
                card:set_cost()
                if SMODS.pseudorandom_probability(card, 'cod_coin_toss', 1, card.ability.extra.odds) then
                    SMODS.destroy_cards(card, nil, nil, true)
                    return {
                        colour = G.C.RED,
                        message = localize('coin_toss_tails'),
                    }
                else
                    return {
                        colour = G.C.GOLD,
                        message = localize('coin_toss_heads'),
                    }
                end
            end
        end
    end
}

-- Oops! All 1s
SMODS.Joker {
    key = "oops_all_1s",
    unlocked = true,
    blueprint_compat = true,
    rarity = 2,
    cost = 6,
    atlas = 'atlas_cod_jokers',
    pos = { x = 4, y = 6 },
    config = { extra = { mult = 0, mult_gain = 1 } },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.mult_gain, card.ability.extra.mult} }
    end,
    calculate = function(self, card, context)
        if context.mod_probability and not context.blueprint then
            return {
                denominator = context.denominator * 2
            }
        end
        if context.pseudorandom_result and not context.blueprint and context.result then
            card.ability.extra.mult = card.ability.extra.mult + card.ability.extra.mult_gain
            return {
                message = localize("k_upgrade_ex"),
                colour = G.C.MULT,
            }
        end
        if context.joker_main then
            return {
                mult = card.ability.extra.mult
            }
        end
    end,
}

-- Call of the Void
SMODS.Joker {
    key = "call_of_the_void",
    unlocked = true,
    blueprint_compat = true,
    rarity = 3,
    cost = 8,
    atlas = 'atlas_cod_jokers',
    pos = { x = 5, y = 6 },
    calculate = function(self, card, context)
        if context.setting_blind and #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
            G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
            G.E_MANAGER:add_event(Event({
                func = (function()
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            SMODS.add_card {
                                set = 'Spectral',
                                key_append = 'cod_call_of_the_void'
                            }
                            G.GAME.consumeable_buffer = 0
                            return true
                        end
                    }))
                    SMODS.calculate_effect({ message = localize('k_plus_spectral'), colour = G.C.SECONDARY_SET.Spectral },
                        context.blueprint_card or card)
                    return true
                end)
            }))
            return nil, true
        end
        if context.check_eternal and context.trigger.from_sell and context.other_card.area == G.consumeables then
            return {
                no_destroy = { override_compat = true }
            }
        end
    end,
}