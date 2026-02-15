-- Final Exam
SMODS.Challenge {
    key = 'final_exam',
    jokers = {
        { id = 'j_cod_homework', eternal = true },
        { id = 'j_cod_homework', eternal = true },
    },
}

-- Unaccountably Peckish
SMODS.Challenge {
    key = 'unaccountably_peckish',
    jokers = {
        { id = 'j_cod_hungry', edition = "negative", eternal = true },
        { id = 'j_cod_hungry', edition = "negative", eternal = true },
    },
    vouchers = {
        { id = 'v_magic_trick' },
    }
}

-- Universal Paperclips
SMODS.Challenge {
    key = 'universal_paperclips',
    jokers = {
        { id = 'j_cod_paperclip', edition = "negative", eternal = true },
    }
}

-- Chaos Chaos
SMODS.Challenge {
    key = 'chaos_chaos',
    rules = {
        modifiers = {
            { id = 'hands',       value = 2 },
            { id = 'discards',    value = 2 },
            { id = 'hand_size',   value = 7 },
            { id = 'joker_slots', value = 4 },
        }
    },
    jokers = {
        { id = 'j_cod_random', edition = "negative" },
        { id = 'j_cod_random', edition = "negative" },
        { id = 'j_cod_random', edition = "negative" },
        { id = 'j_cod_random', edition = "negative" },
    }
}

-- Sleepover
SMODS.Challenge {
    key = 'sleepover',
    rules = {
        custom = {
            { id = 'all_dormant' },
        }
    },
}

-- Top Secret
SMODS.Challenge {
    key = 'top_secret',
    rules = {
        custom = {
            { id = 'all_confidential' },
        }
    },
    restrictions = {
        banned_cards = {
            { id = 'j_madness' },
            { id = 'j_cod_paperclip' },
        },
    },
}

-- Fishbucket
SMODS.Challenge {
    key = 'fishbucket',
    rules = {
        custom = {
            { id = 'fishbucket' },
        }
    },
    restrictions = {
        banned_cards = function()
            local banned = {}
            for k, v in pairs(G.P_CENTERS) do
                if v.set == 'Joker' and not (v.original_mod and v.original_mod.id == "CodMod") then
                    banned[#banned+1] = {id = v.key}
                end
            end
            return banned
        end
    },
}