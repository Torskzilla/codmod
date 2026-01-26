
SMODS.Atlas {
	key = "atlas_cod_jokers",
	path = "jokers.png",
	px = 71,
	py = 95
}

-- Season cycle
local season_loc_vars = function(self, info_queue, card)
    return { vars = { localize(card.ability.extra.from_suit, 'suits_singular'), localize(card.ability.extra.to_suit, 'suits_plural'), colours = { card.ability.extra.from_color, card.ability.extra.to_color } } }
end
local season_calculate = function(self, card, context)
    if context.before and not context.blueprint then
        local convert = false
        for _, scored_card in ipairs(context.scoring_hand) do
            if scored_card:is_suit(card.ability.extra.from_suit) then
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
                if not SMODS.has_no_suit(scored_card) then
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
                if playing_card:is_suit(card.ability.extra.suit) then
                    valid_mitosis_cards[#valid_mitosis_cards + 1] = playing_card
                end
            end
            local mitosis_card = pseudorandom_element(valid_mitosis_cards, 'cod_mitosis')
            if mitosis_card then
                local card_copied = copy_card(mitosis_card, nil, nil, G.playing_card)
                card_copied.states.visible = nil
                G.playing_card = (G.playing_card and G.playing_card + 1) or 1
                card_copied.playing_card = G.playing_card
                table.insert(G.playing_cards, card_copied)

                G.E_MANAGER:add_event(Event({
                    func = function()
                        card_copied:start_materialize()
                        G.play:emplace(card_copied)
                        return true
                    end
                }))
                return {
                    message = localize('mitosis_split'),
                    colour = card.ability.extra.color,
                    func = function()
                        G.E_MANAGER:add_event(Event({
                            func = function()
                                G.deck.config.card_limit = G.deck.config.card_limit + 1
                                return true
                            end
                        }))
                        draw_card(G.play, G.deck, 90, 'up')
                        SMODS.calculate_context({ playing_card_added = true, cards = { card_copied } })
                    end
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
            return {
                message = localize('invasion_attack'),
                colour = card.ability.extra.color,
                func = function()
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            G.deck.config.card_limit = G.deck.config.card_limit + 2
                            return true
                        end
                    }))
                    draw_card(G.play, G.deck, 90, 'up')
                    draw_card(G.play, G.deck, 90, 'up')
                    SMODS.calculate_context({ playing_card_added = true, cards = { spade_card1, spade_card2 } })
                end
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
                    if not playing_card:is_suit(card.ability.extra.suit) then
                        valid_remove_cards[#valid_remove_cards + 1] = playing_card
                    end
                end
                local remove_card = pseudorandom_element(valid_remove_cards, 'cod_purification')
                if remove_card then
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
                if playing_card.base.suit ~= card.ability.extra.suit and not SMODS.has_no_suit(playing_card) then
                    valid_overgrowth_cards[#valid_overgrowth_cards + 1] = playing_card
                end
            end
            local overgrowth_card = pseudorandom_element(valid_overgrowth_cards, 'cod_overgrowth')
            if overgrowth_card then
                assert(SMODS.change_base(overgrowth_card, card.ability.extra.suit))

                return {
                    message = localize('overgrowth_grow'),
                    colour = card.ability.extra.color,
                }
            end

        end
    end
}

-- Harmony

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
            for i=1,card.ability.extra.eat_size do
                local valid_hungry_cards = {}
                for _, playing_card in ipairs(G.playing_cards) do
                    valid_hungry_cards[#valid_hungry_cards + 1] = playing_card
                end
                local hungry_card = pseudorandom_element(valid_hungry_cards, 'cod_hungry')
                if hungry_card then
                    SMODS.destroy_cards(hungry_card)
                    cards_eaten = cards_eaten + 1
                end
            end
            
            if cards_eaten > 0 then
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
                colour = G.C.Gold,
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
                colour = G.C.Gold,
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
    config = { extra = { xmult = 3} },
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
    config = { extra = { mult = 25, cod_clone = true } },
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
        if context.setting_blind and not context.blueprint then
            return {
                message = localize("anchor_sink"),
                colour = card.ability.extra.color,
            }
        elseif context.drawing_cards and not context.blueprint then
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
        return { vars = { card.ability.extra.anti_ante, card.ability.extra.skips, card.ability.extra.skip_counter } }
    end,
    calculate = function(self, card, context)
        if context.skip_blind and not context.blueprint then
            card.ability.extra.skip_counter = card.ability.extra.skip_counter + 1
            if card.ability.extra.skip_counter >= card.ability.extra.skips then

                ease_ante(-card.ability.extra.anti_ante)
                G.GAME.round_resets.blind_ante = G.GAME.round_resets.blind_ante or G.GAME.round_resets.ante
                G.GAME.round_resets.blind_ante = G.GAME.round_resets.blind_ante - card.ability.extra.anti_ante
                
                card.ability.extra.skip_counter = 0
                card.ability.extra.skips = card.ability.extra.skips + 1

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
                    colour = G.C.Gold,
                }
            else
                return {
                    message = localize("faster_than_light_charge"),
                    colour = G.C.Gold,
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

-- Short Joker
SMODS.Joker {
    key = "short",
    unlocked = true,
    blueprint_compat = true,
    rarity = 1,
    cost = 4,
    atlas = 'atlas_cod_jokers',
    pos = { x = 4, y = 2 },
    config = { extra = { chips = 100, max_sum = 25 } },
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

-- Elitism
SMODS.Joker {
    key = "elitism",
    unlocked = false,
    blueprint_compat = false,
    rarity = 3,
    cost = 8,
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
    blueprint_compat = true,
    rarity = 3,
    cost = 9,
    atlas = 'atlas_cod_jokers',
    pos = { x = 9, y = 2 },
    config = { extra = { mult_gain = 1, mult = 0 } },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.mult_gain, card.ability.extra.mult } }
    end,
    calculate = function(self, card, context)
        if context.selling_card and not context.blueprint then
            local key_to_ban = context.card.config.center.key

            G.GAME.banned_keys[key_to_ban] = true

            SMODS.scale_card(card, {
                ref_table = card.ability.extra,
                ref_value = "mult",
                scalar_value = "mult_gain",
            })
        end
        if context.joker_main then
            return {
                mult = card.ability.extra.mult
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