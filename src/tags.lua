SMODS.Atlas {
	key = "atlas_cod_tags",
	path = "tags.png",
	px = 34,
	py = 34
}

-- Clone Tag
SMODS.Tag {
    key = "clone",
    min_ante = 2,
    atlas = 'atlas_cod_tags',
    pos = { x = 0, y = 0 },
    apply = function(self, tag, context)
        if context.type == 'store_joker_create' and #G.jokers.cards > 0 then
            local owned_joker_keys = {}
            for i=1,#G.jokers.cards do
                owned_joker_keys[#owned_joker_keys+1] = G.jokers.cards[i].config.center.key
            end

            local owned_joker = pseudorandom_element(owned_joker_keys, 'cod_clone_tag')
            local card = SMODS.create_card {
                set = "Joker",
                key = owned_joker,
                area = context.area,
                key_append = "cod_clone_tag"
            }
            create_shop_card_ui(card, 'Joker', context.area)
            card.states.visible = false
            tag:yep('+', G.C.BLUE, function()
                card:start_materialize()
                return true
            end)
            tag.triggered = true
            return card
        end
    end
}

-- Dark Tag
SMODS.Tag {
    key = "dark",
    min_ante = 2,
    atlas = 'atlas_cod_tags',
    pos = { x = 1, y = 0 },
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = { key = 'e_negative_playing_card', set = 'Edition', config = { extra = 1 } }
    end,
    apply = function(self, tag, context)
        if context.type == 'store_joker_create' then

            local set = "Base"
            local seal = nil
            if G.GAME.used_vouchers.v_illusion then
                if pseudorandom(pseudoseed('illusion')) > 0.6 then set = "Enhanced" end
                if pseudorandom(pseudoseed('illusion')) > 0.7 then seal = SMODS.poll_seal {key = "cod_dark_illusion", guaranteed = true} end
            end

            local card = SMODS.create_card {
                set = set,
                seal = seal,
                edition = "e_negative",
                area = context.area,
                key_append = "cod_dark_tag"
            }
            
            create_shop_card_ui(card, 'Playing Card', context.area)
            card.states.visible = false
            tag:yep('+', G.C.DARK_EDITION, function()
                card:start_materialize()
                return true
            end)
            tag.triggered = true
            return card
        end
    end
}