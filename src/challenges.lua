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