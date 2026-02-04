
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