
SMODS.Atlas {
	key = "atlas_cod_blinds",
	path = "blinds.png",
	px = 34,
	py = 34
}

-- The Innocent
SMODS.Blind {
    key = "innocent",
    dollars = 5,
    mult = 2,
    atlas = 'atlas_cod_blinds',
    pos = { x = 0, y = 0 },
    boss = { min = 1 },
    boss_colour = HEX("7e05bf"),
    calculate = function(self, blind, context)
        if not blind.disabled then
            if context.end_of_round and context.main_eval then
                local current_score = G.GAME.chips
                local current_requirements = G.GAME.blind.chips
                if (current_score>current_requirements) then
                    blind.triggered = true
                    G.GAME.cod_b_innocent_excess = G.GAME.cod_b_innocent_excess or 0
                    G.GAME.cod_b_innocent_excess = G.GAME.cod_b_innocent_excess + current_score - current_requirements
                end
            end
        end
    end
}

-- hook to adjust blind score requirements
local get_blind_amount_ref = get_blind_amount
function get_blind_amount(ante)

    local chip_requirement = get_blind_amount_ref(ante)

    local innocent_karma = G.GAME.cod_b_innocent_excess or 0
    chip_requirement = chip_requirement + innocent_karma

    return chip_requirement
end

-- The Rot
SMODS.Blind {
    key = "rot",
    dollars = 5,
    mult = 2,
    atlas = 'atlas_cod_blinds',
    pos = { x = 0, y = 1 },
    boss = { min = 2 },
    boss_colour = HEX("72663f"),
    calculate = function(self, blind, context)
        if not blind.disabled then
            if context.round_shuffle then

                local debuff_amount = math.ceil(#G.deck.cards / 5)

                for i=0,(debuff_amount-1) do
                    SMODS.debuff_card(G.deck.cards[#G.deck.cards-i], true, "cod_rot")
                end
            end
        end
    end,
    disable = function(self)
        for _, playing_card in pairs(G.playing_cards) do
            SMODS.debuff_card(playing_card, false, "cod_rot")
        end
    end,
    defeat = function(self)
        for _, playing_card in pairs(G.playing_cards) do
            SMODS.debuff_card(playing_card, false, "cod_rot")
        end
    end
}

-- The Spire
SMODS.Blind {
    key = "spire",
    dollars = 5,
    mult = 2,
    atlas = 'atlas_cod_blinds',
    pos = { x = 0, y = 2 },
    boss = { min = 1 },
    boss_colour = HEX("c88d11"),
    calculate = function(self, blind, context)
        if not blind.disabled then
            if context.round_shuffle then
                for i=1,25 do
                    if G.deck.cards[i] then
                        SMODS.debuff_card(G.deck.cards[i], true, "cod_spire")
                    end
                end
            end
        end
    end,
    disable = function(self)
        for _, playing_card in pairs(G.playing_cards) do
            SMODS.debuff_card(playing_card, false, "cod_spire")
        end
    end,
    defeat = function(self)
        for _, playing_card in pairs(G.playing_cards) do
            SMODS.debuff_card(playing_card, false, "cod_spire")
        end
    end
}

-- The Snow
SMODS.Blind {
    key = "snow",
    dollars = 5,
    mult = 2,
    atlas = 'atlas_cod_blinds',
    pos = { x = 0, y = 5 },
    boss = { min = 1 },
    boss_colour = HEX("dfdfdf"),
    calculate = function(self, blind, context)
        if not blind.disabled then
            if context.round_shuffle then
                for i=1,#G.deck.cards do
                    if (i%4==1) then
                        SMODS.debuff_card(G.deck.cards[#G.deck.cards-i], true, "cod_snow")
                    end
                end
            end
        end
    end,
    disable = function(self)
        for _, playing_card in pairs(G.playing_cards) do
            SMODS.debuff_card(playing_card, false, "cod_snow")
        end
    end,
    defeat = function(self)
        for _, playing_card in pairs(G.playing_cards) do
            SMODS.debuff_card(playing_card, false, "cod_snow")
        end
    end
}

-- The Lost
SMODS.Blind {
    key = "lost",
    dollars = 5,
    mult = 2,
    atlas = 'atlas_cod_blinds',
    pos = { x = 0, y = 4 },
    boss = { min = 5 },
    boss_colour = HEX("ab85c8"),
    calculate = function(self, blind, context)
        if not blind.disabled then
            if context.end_of_round and context.main_eval then
                
                local planet = nil
                for _, v in pairs(G.P_CENTER_POOLS.Planet) do
                    if v.config.hand_type == G.GAME.last_hand_played then
                        planet = v.key
                    end
                end

                if planet then
                    G.GAME.banned_keys[planet] = true
                end
            end
        end
    end,
}

-- The Ascetuc
SMODS.Blind {
    key = "ascetic",
    dollars = 0,
    mult = 2,
    atlas = 'atlas_cod_blinds',
    pos = { x = 0, y = 6 },
    boss = { max = 1 },
    boss_colour = HEX("dfc87e"),
    calculate = function(self, blind, context)
        if blind.disabled then
            if context.end_of_round and context.main_eval then
                local boss_reward = 5
                G.GAME.dollar_buffer = (G.GAME.dollar_buffer or 0) + boss_reward
                return {
                    remove_default_message = true,
                    dollars = boss_reward,
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
    end,
}