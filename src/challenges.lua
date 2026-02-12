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
    }
}

-- Final Exam
SMODS.Challenge {
    key = 'final_exam',
    jokers = {
        { id = 'j_cod_homework', eternal = true },
        { id = 'j_cod_homework', eternal = true },
    },
}