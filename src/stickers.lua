SMODS.Atlas {
	key = "atlas_cod_stickers",
	path = "stickers.png",
	px = 71,
	py = 95
}

-- hook to let debuffed cards have sticker effects
local eval_card_ref = eval_card
function eval_card(card, context)
    context = context or {}
    if not card:can_calculate(context.ignore_debuff, context.remove_playing_cards or context.joker_type_destroyed) then
        local ret = {}
        for _,k in ipairs(SMODS.Sticker.obj_buffer) do
            local v = SMODS.Stickers[k]
            local sticker = card:calculate_sticker(context, k)
            if sticker then
                ret[v] = sticker
            end
        end
        return ret, {}
    end

    return eval_card_ref(card, context)
end

-- Dormant
local dormant_rounds = 3

SMODS.Sticker {
    key = "dormant",
    badge_colour = HEX '3c11b2',
    atlas = 'atlas_cod_stickers',
    pos = { x = 0, y = 0 },
    default_compat = true,
    rate = 0.25,
    needs_enable_flag = true,
    apply = function(self, card, val)
        card.ability[self.key] = val
        card.ability.dormant_tally = dormant_rounds
        SMODS.debuff_card(card, true, "cod_dormant")
        
    end,
    loc_vars = function(self, info_queue, card)
        return { vars = { dormant_rounds, card.ability.dormant_tally or dormant_rounds } }
    end,
    calculate = function(self, card, context)
        if context.end_of_round and not context.repetition and not context.individual then
            if card.ability.dormant_tally > 0 then
                if card.ability.dormant_tally == 1 then
                    card.ability.dormant_tally = 0
                    card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize('dormant_awaken'),colour = G.C.FILTER, delay = 0.45})
                    SMODS.debuff_card(card, false, "cod_dormant")
                else
                    card.ability.dormant_tally = card.ability.dormant_tally - 1
                    card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize{type='variable',key='a_remaining',vars={card.ability.dormant_tally}},colour = G.C.FILTER, delay = 0.45})
                end
            end
        end
    end
}

-- Envious
SMODS.Sticker {
    key = "envy",
    badge_colour = HEX '85e768',
    atlas = 'atlas_cod_stickers',
    pos = { x = 1, y = 0 },
    default_compat = true,
    rate = 0.25,
    needs_enable_flag = true,
    apply = function(self, card, val)
        card.ability[self.key] = val
    end,
    calculate = function(self, card, context)
        if (context.joker_type_destroyed or context.selling_card) and context.card ~= card then
            local envy_count = 0
            for i = 1, #G.jokers.cards do
                if G.jokers.cards[i].ability.cod_envy then
                    envy_count = envy_count + 1
                end
            end
            if context.card.ability.cod_envy then
                envy_count = envy_count - 1
            end
            if (envy_count>1) then
                SMODS.debuff_card(card, true, "cod_envy")
            else
                SMODS.debuff_card(card, false, "cod_envy")
            end
        end
        if context.buying_self or context.card_added then
            local envy_count = 0
            if context.card.ability.cod_envy then
                envy_count = envy_count + 1
            end
            for i = 1, #G.jokers.cards do
                if G.jokers.cards[i].ability.cod_envy then
                    envy_count = envy_count + 1
                end
            end
            if (envy_count>1) then
                SMODS.debuff_card(card, true, "cod_envy")
            else
                SMODS.debuff_card(card, false, "cod_envy")
            end
            if context.card.ability.cod_envy then
                if (envy_count>1) then
                    SMODS.debuff_card(context.card, true, "cod_envy")
                end
            end
        end
    end
}

-- Claustrophobic
SMODS.Sticker {
    key = "claustrophobic",
    badge_colour = HEX 'aeaeae',
    atlas = 'atlas_cod_stickers',
    pos = { x = 2, y = 0 },
    default_compat = true,
    rate = 0.25,
    needs_enable_flag = true,
    apply = function(self, card, val)
        card.ability[self.key] = val
    end,
    calculate = function(self, card, context)
        if context.buying_self or context.card_added or ((context.joker_type_destroyed or context.selling_card) and context.card ~= card) then
            local empty_count = G.jokers.config.card_limit - #G.jokers.cards
            if (context.joker_type_destroyed or context.selling_card) then
                empty_count = empty_count - context.card.ability.card_limit + 1
            end
            if context.card_added or context.buying_self then
                empty_count = empty_count - 1 + context.card.ability.card_limit
                if (context.card.ability.cod_claustrophobic and empty_count<=0) then
                    SMODS.debuff_card(context.card, true, "cod_claustrophobic")
                end
            end
            if (empty_count>0) then
                SMODS.debuff_card(card, false, "cod_claustrophobic")
            else
                SMODS.debuff_card(card, true, "cod_claustrophobic")
            end
        end
    end
}