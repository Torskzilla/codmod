return {
    descriptions = {
        Back={
            b_cod_ponzi={
                name="Ponzi Deck",
                text={
                    "Start with {C:attention}#1#{}",
                    "copies of {C:joker,T:j_credit_card}#2#",
                    "and {C:red}-$#3#",
                },
                unlock = {
                    "Have {C:red}-$#1#",
                }
            },
            b_cod_average={
                name="Average Deck",
                text={
                    "No {C:blue}Common{} or {C:red}Rare",
                    "{C:attention}Jokers{} naturally appear"
                },
            },
            b_cod_vip={
                name="VIP Deck",
                text={
                    "{C:attention}1{} card starts with a {C:attention}Seal{}",
                    "{C:enhanced}Enhancement{} and {C:dark_edition}Edition{}"
                },
            },
            b_cod_gravity={
                name="Gravity Deck",
                text={
                    "Start run with a",
                    "copy of {C:legendary,E:1,T:c_black_hole}Black Hole{}"
                },
            },
        },
        Blind={
            bl_cod_innocent = {
                name = "The Innocent",
                text = {
                    "Excess score is added",
                    "to the requirement",
                    "of future blinds"
                },
            },
            bl_cod_rot = {
                name = "The Rot",
                text = {
                    "First 5th of deck",
                    "is debuffed",
                },
            },
            bl_cod_spire = {
                name = "The Spire",
                text = {
                    "Last 25 cards of",
                    "deck are debuffed",
                },
            },
            bl_cod_snow = {
                name = "The Snow",
                text = {
                    "Every 4th card",
                    "is debuffed",
                },
            },
            bl_cod_lost = {
                name = "The Lost",
                text = {
                    "Bans the winning",
                    "hand's planet card",
                },
            },
            bl_cod_ascetic = {
                name = "The Ascetic",
                text = {
                    "No reward money"
                },
            },
        },
        Edition={},
        Enhanced={},
        Joker={
            j_cod_conspiracy={
                name="The Conspiracy",
                text={
                    "{X:mult,C:white}X#1#{} Mult if played",
                    "hand is {C:attention}Secret",
                },
                unlock = {
                    "Win a run",
                    "without playing",
                    "a {E:1,C:attention}#1#",
                }
            },
            j_cod_homework={
                name="Homework",
                text={
                    "{X:mult,C:white}X#1#{} Mult if sum",
                    "of played ranks is {C:attention}#2#{}",
                    "{s:0.8}Sum changes every hand",
                }
            },
            j_cod_tall={
                name="Tall Joker",
                text={
                    "{C:mult}+#1#{} Mult if sum",
                    "of played ranks",
                    "is at least {C:attention}#2#{}",
                }
            },
            j_cod_short={
                name="Short Joker",
                text={
                    "{C:chips}+#1#{} Chips if sum",
                    "of played ranks",
                    "is at most {C:attention}#2#{}",
                }
            },
            j_cod_mitosis={
                name="Mitosis",
                text={
                    "When {C:attention}Blind{} is selected,",
                    "duplicate {C:attention}#1#{} {V:1}#2#{}",
                    "card in deck",
                }
            },
            j_cod_invasion={
                name="Invasion",
                text={
                    "When {C:attention}Blind{} is selected,",
                    "add {C:attention}#1#{} {V:1}#2#{}",
                    "cards to deck",
                }
            },
            j_cod_purification={
                name="Purification",
                text={
                    "When {C:attention}Blind{} is selected,",
                    "destroy {C:attention}#1#{} non-{V:1}#2#{}",
                    "card in deck",
                }
            },
            j_cod_overgrowth={
                name="Overgrowth",
                text={
                    "When {C:attention}Blind{} is selected,",
                    "convert {C:attention}#1#{} card",
                    "in deck to {V:1}#2#{}",
                }
            },
            j_cod_harmony={
                name="Harmony",
                text={
                    "When {C:attention}Blind{} is selected, gain",
                    "{C:mult}+#1#{} Mult and convert {C:attention}#2#{} card from",
                    "your most common suit to your least",
                    "{C:inactive}(Currently {C:mult}+#3#{C:inactive} Mult)",
                }
            },
            j_cod_summer={
                name="Summer",
                text={
                    "All played scoring",
                    "{V:1}#1#{} cards",
                    "become {V:2}#2#{}",
                }
            },
            j_cod_fall={
                name="Fall",
                text={
                    "All played scoring",
                    "{V:1}#1#{} cards",
                    "become {V:2}#2#{}",
                }
            },
            j_cod_winter={
                name="Winter",
                text={
                    "All played scoring",
                    "{V:1}#1#{} cards",
                    "become {V:2}#2#{}",
                }
            },
            j_cod_spring={
                name="Spring",
                text={
                    "All played scoring",
                    "{V:1}#1#{} cards",
                    "become {V:2}#2#{}",
                }
            },
            j_cod_four_seasons={
                name="Four Seasons",
                text={
                    "All played scoring cards",
                    "become the next suit",
                    "{C:hearts,s:0.8}Hearts{s:0.8} > {C:spades,s:0.8}Spades{s:0.8} > {C:diamonds,s:0.8}Diamonds{s:0.8} > {C:clubs,s:0.8}Clubs",
                },
                unlock = {
                    "Discover all Seasons",
                }
            },
            j_cod_singularity={
                name="Singularity",
                text={
                    "Gives {X:mult,C:white}X#1#{} Mult for each time",
                    "you have played your least",
                    "played {C:attention}poker hand{} this run",
                    "{C:inactive}(Currently {X:mult,C:white}X#2#{C:inactive} Mult)",
                },
                unlock = {
                    "Play every visible {C:attention}poker hand{}",
                    "at least {C:attention}3{} times in a run",
                },
            },
            j_cod_scam={
                name="Scam",
                text={
                    "{X:mult,C:white}X#1#{} Mult"
                }
            },
            j_cod_bully={
                name="Bully",
                text={
                    "{X:mult,C:white}X#1#{} Mult against {C:attention}Small Blinds{}"
                }
            },
            j_cod_hungry={
                name="Hungry Joker",
                text={
                    "When {C:attention}Blind{} is selected,",
                    "destroy {C:attention}#1#{} random",
                    "cards in deck",
                }
            },
            j_cod_all_seeing = {
                name = "All-Seeing Joker",
                text = {
                    "{C:attention}+#1#{} hand size while",
                    "opening {C:attention}Booster Packs{}",
                },
            },
            j_cod_resourceful = {
                name = "Resourceful Joker",
                text = {
                    "{C:attention}+#1#{} option in {C:attention}Booster Packs{}",
                },
            },
            j_cod_scavenging = {
                name = "Scavenging Joker",
                text = {
                    "Take {C:attention}+#1#{} item from {C:attention}Booster Packs{}",
                },
            },
            j_cod_common_clone = {
                name = "Imperfect Clone",
                text = {
                    "Clones each give {C:chips}+#1#{} Chips,",
                    "may appear multiple times",
                },
            },
            j_cod_uncommon_clone = {
                name = "Uncanny Clone",
                text = {
                    "Clones each give {C:mult}+#1#{} Mult,",
                    "may appear multiple times",
                },
                unlock = {
                    "Have {C:attention}2{} Clones",
                    "at the same time"
                },
            },
            j_cod_rare_clone = {
                name = "Perfect Clone",
                text = {
                    "Clones each give {X:mult,C:white}X#1#{} Mult,",
                    "may appear multiple times",
                },
                unlock = {
                    "Have {C:attention}3{} Clones",
                    "at the same time"
                },
            },
            j_cod_anchor = {
                name = "Anchor",
                text = {
                    "{V:1}#1#{} cards start at",
                    "the bottom of the deck",
                },
            },
            j_cod_faster_than_light = {
                name = "Faster Than Light",
                text = {
                    "Skip {C:attention}#2# Blinds{}",
                    "for {C:attention}-#1#{} Ante",
                    "{C:inactive}#3# skipped",
                },
            },
            j_cod_chosen_one = {
                name = "Chosen One",
                text = {
                    "Retrigger all cards",
                    "played in {C:attention}Boss Blinds",
                },
            },
            j_cod_paperclip = {
                name = "Paperclip",
                text = {
                    "{C:mult}+#1#{} Mult",
                    "When {C:attention}Small Blind{} or {C:attention}Big Blind{} is",
                    "selected, {C:attention}destroy{} a random Joker",
                    "to create a copy of this one"
                },
            },
            j_cod_hiding = {
                name = "Hidden Joker",
                text = {
                    "{C:red}+#1#{} discards each round,",
                    "cards are drawn face",
                    "down after discards",
                },
            },
            j_cod_elitism = {
                name = "Elitist Joker",
                text = {
                    "{C:blue}Common{C:attention} Jokers{} can't",
                    "naturally appear",
                },
                unlock = {
                    "Win a run with",
                    "{C:attention}#1#{}",
                    "on any difficulty",
                }
            },
            j_cod_black_market = {
                name = "Black Market",
                text = {
                    "{C:red}Bans{} sold cards",
                    "{C:inactive}(Banned cards can't appear)",
                },
            },
            j_cod_spam = {
                name = "Spam",
                text = {
                    "When round begins,",
                    "add {C:attention}#1#{} random {C:attention}playing",
                    "{C:attention}cards{} to your hand",
                },
            },
            j_cod_cantrip = {
                name = "Cantrip",
                text = {
                    "{C:blue}+#1#{} Hand if played",
                    "hand is the first",
                    "{C:attention}High Card{} of the round",
                },
            },
            j_cod_password = {
                name = "Password",
                text = {
                    "{X:mult,C:white}X#1#{} Mult if poker hand",
                    "contains a letter and a number",
                },
            },
            j_cod_random_xmult = {
                name = "#3#",
                text = {
                    "{X:mult,C:white}X#1#{} Mult",
                    "{s:0.8}#2#",
                },
            },
            j_cod_random_mult = {
                name = "#3#",
                text = {
                    "{C:mult}+#1#{} Mult",
                    "{s:0.8}#2#",
                },
            },
            j_cod_random_chips = {
                name = "#3#",
                text = {
                    "{C:chips}+#1#{} Chips",
                    "{s:0.8}#2#",
                },
            },
            j_cod_random_h_size = {
                name = "#3#",
                text = {
                    "{C:attention}+#1#{} hand size",
                    "{s:0.8}#2#",
                },
            },
            j_cod_random_discards = {
                name = "#3#",
                text = {
                    "{C:red}+#1#{} discards",
                    "{s:0.8}#2#",
                },
            },
            j_cod_random_hands = {
                name = "#3#",
                text = {
                    "{C:blue}+#1#{} Hands",
                    "{s:0.8}#2#",
                },
            },
            j_cod_random_sell_value = {
                name = "#3#",
                text = {
                    "{C:money}+$#1#{} sell value",
                    "{s:0.8}#2#",
                },
            },
            j_cod_random_probability = {
                name = "#3#",
                text = {
                    "{C:green}+#1#{} probability",
                    "{s:0.8}#2#",
                },
            },
            j_cod_random_retrigger = {
                name = "#2#",
                text = {
                    "Retrigger played cards",
                    "{s:0.8}#1#",
                },
            },
            j_cod_ricochet = {
                name = "Ricochet",
                text = {
                    "{C:green}#1# in #2#{} chance to retrigger played {C:diamonds}Diamonds{},",
                    "{C:green}#1# in #3#{} chance to retrigger again,",
                    "{C:green}#1# in #4#{} chance to retrigger again, etc",
                },
            },
            j_cod_unlucky = {
                name = "Unlucky Joker",
                text = {
                    "{C:green}#1# in #2#{} chance to give {C:chips}+#3#{} Chips,",
                    "gains {C:chips}+#4#{} Chips when a chance fails",
                },
            },
            j_cod_tapas_1 = {
                name = "Tapas",
                text = {
                    "{V:1,B:2}#1#{} #2#",
                    "lose {C:red}1{} effect each round",
                },
            },
            j_cod_tapas_2 = {
                name = "Tapas",
                text = {
                    "{V:1,B:2}#1#{} #2#",
                    "{V:3,B:4}#3#{} #4#",
                    "lose {C:red}1{} effect each round",
                },
            },
            j_cod_tapas_3 = {
                name = "Tapas",
                text = {
                    "{V:1,B:2}#1#{} #2#",
                    "{V:3,B:4}#3#{} #4#",
                    "{V:5,B:6}#5#{} #6#",
                    "lose {C:red}1{} effect each round",
                },
            },
            j_cod_tapas_4 = {
                name = "Tapas",
                text = {
                    "{V:1,B:2}#1#{} #2#",
                    "{V:3,B:4}#3#{} #4#",
                    "{V:5,B:6}#5#{} #6#",
                    "{V:7,B:8}#7#{} #8#",
                    "lose {C:red}1{} effect each round",
                },
            },
            j_cod_stargazer = {
                name = "Stargazer",
                text = {
                    "Create a {C:planet}Planet{} card",
                    "when {C:attention}Blind{} is selected",
                    "{C:inactive}(Must have room)",
                },
            },
            j_cod_gear_stick = {
                name = "Gear Stick",
                text = {
                    "{X:mult,C:white}+X#1#{} Mult for each joker to the right",
                    "{X:mult,C:white}-X#1#{} Mult for each joker to the left",
                    "{C:inactive}(Currently {X:mult,C:white}X#2#{C:inactive} Mult)",
                },
            },
            j_cod_limbo = {
                name = "Limbo",
                text = {
                    "This Joker gains {C:mult}+#1#{} Mult",
                    "per {C:attention}consecutive{} hand",
                    "played that is not",
                    "a {C:attention}High Card{}",
                    "{C:inactive}(Currently {C:mult}+#2#{C:inactive} Mult)",
                },
            },
            j_cod_patent = {
                name = "Patent",
                text = {
                    "Earn {C:money}$#1#{} when playing a",
                    "{C:attention}poker hand{} for the first time",
                },
            },
            j_cod_rule_of_three = {
                name = "Rule of Three",
                text = {
                    "{X:mult,C:white}X#1#{} Mult every {C:attention}#2#rd{} scored {C:attention}#3#{}",
                    "{C:inactive}(#4# scored)",
                },
            },
            j_cod_astral_transit = {
                name = "Astral Transit",
                text = {
                    "When a {C:planet}Planet{} card is",
                    "used, also level up a",
                    "random other {C:attention}poker hand{}",
                },
            },
            j_cod_death_star = {
                name = "Death Star",
                text = {
                    "{C:red}Removes{} all level ups from",
                    "played {C:attention}poker hand{} and gains",
                    "the removed {C:blue}Chips{} and {C:mult}Mult{}",
                    "{C:inactive}({C:chips}+#1#{C:inactive} Chips, {C:mult}+#2#{C:inactive} Mult)",
                },
            },
            j_cod_infrastructure = {
                name = "Infrastructure",
                text = {
                    "When {C:attention}Blind{} is selected,",
                    "randomly {C:enhanced}Enhance{} {C:attention}#1#{}",
                    "card in deck",
                },
            },
            j_cod_printer = {
                name = "Printer",
                text = {
                    "When {C:attention}Blind{} is selected,",
                    "add a {C:attention}#1#{} of {V:1}#2#{}",
                    "to deck",
                },
            },
            j_cod_the_sun = {
                name = "The Sun",
                text = {
                    "When {C:attention}Boss Blind{} is defeated,",
                    "upgrade level of every {C:attention}poker hand",
                },
            },
            j_cod_shackles = {
                name = "Shackles",
                text = {
                    "{C:dark_edition}+#1#{} Joker Slot,",
                    "{X:mult,C:white}#2#X{} Mult",
                },
            },
            j_cod_redacted = {
                name = "Redacted",
                text = {
                    "Unknown effect"
                },
            },
            j_cod_stellar_void = {
                name = "Stellar Void",
                text = {
                    "{C:mult}+#1#{} Mult per {C:attention}poker hand{}",
                    "you have never played",
                    "{C:inactive}(Currently {C:mult}+#2#{C:inactive} Mult)",
                },
            },
            j_cod_stellar_cluster = {
                name = "Stellar Cluster",
                text = {
                    "{C:mult}+#1#{} Mult per different",
                    "{C:attention}poker hand{} you have played",
                    "{C:inactive}(Currently {C:mult}+#2#{C:inactive} Mult)",
                },
            },
            j_cod_taxes = {
                name = "Taxes",
                text = {
                    "{C:mult}+#1#{} Mult for every {C:money}$1{}",
                    "you are below {C:money}$#2#{}",
                    "{C:inactive}(Currently {C:mult}+#3#{C:inactive} Mult)",
                },
            },
            j_cod_knockoff = {
                name = "Knockoff",
                text = {
                    "Copies ability of the",
                    "lowest sell value {C:attention}Joker{}",
                },
            },
            j_cod_delivery = {
                name = "Delivery",
                text = {
                    "Earn {C:money}$#1#{} when",
                    "{C:attention}Blind{} is skipped",
                },
            },
            j_cod_gambler = {
                name = "Gambler",
                text = {
                    "When {C:attention}High Card{} is played,",
                    "gain {C:mult}+#4#{} Mult but {C:green}#1# in #2#{}",
                    "chance to {C:red}self destruct{}",
                    "{C:inactive}(Currently {C:mult}+#3#{C:inactive} Mult)",
                },
            },
            j_cod_coin_toss = {
                name = "Coin Toss",
                text = {
                    "When {C:attention}High Card{} is played,",
                    "{C:attention}double{} sell value but {C:green}#1# in #2#{}",
                    "chance to {C:red}self destruct{}",
                },
            },
            j_cod_oops_all_1s = {
                name = "Oops! All 1s",
                text = {
                    "Halves {C:green,E:1,S:1.1}probabilities{} but gains",
                    "{C:mult}+#1#{} Mult when they succeed",
                    "{C:inactive}(Currently {C:mult}+#2#{C:inactive} Mult)",
                },
            },
        },
        Other={
            cod_dormant = {
                name = "Dormant",
                text = {
                    "Debuffed until",
                    "{C:attention}#1#{} rounds pass",
                    "{C:inactive}({C:attention}#2#{C:inactive} remaining)",
                },
            },
            cod_envy = {
                name = "Envious",
                text = {
                    "Debuffed if",
                    "you have another",
                    "{C:green}Envious{} card"
                },
            },
            cod_claustrophobic = {
                name = "Claustrophobic",
                text = {
                    "Debuffed if Joker",
                    "Slots are full",
                },
            },
            cod_confidential = {
                name = "Confidential",
                text = {
                    "Hides card"
                },
            },
            confidential_default = {
                name = "Redacted",
                text = {
                    "Unknown effect"
                },
            },
            cod_expensive = {
                name = "Expensive",
                text = {
                    "Costs more",
                },
            },
            cod_imprisoned = {
                name = "Imprisoned",
                text = {
                    "Debuffed until a",
                    "{C:attention}Blind{} is skipped"
                },
            },
            cod_platinum_sticker = {
                name = "Platinum Sticker",
                text = {
                    "Used this Joker",
                    "to win on {C:attention}Platinum",
                    "{C:attention}Stake{} difficulty",
                },
            },
        },
        Planet={},
        Spectral={},
        Stake={
            stake_cod_platinum = {
                name = "Platinum Stake",
                text = {
                    "Adds several new {C:attention}Stickers{}",
                    "{s:0.8}Applies all previous Stakes",
                },
            },
        },
        Tag={},
        Tarot={},
        Voucher={},
    },
    misc = {
        achievement_descriptions={},
        achievement_names={},
        blind_states={},
        challenge_names={
            c_cod_universal_paperclips = "Universal Paperclips",
            c_cod_chaos_chaos = "Chaos Chaos",
            c_cod_sleepover = "Sleepover",
            c_cod_jailbreak = "Jailbreak",
            c_cod_top_secret = "Top Secret",
            c_cod_final_exam = "Final Exam",
            c_cod_unaccountably_peckish = "Unaccountably Peckish",
            c_cod_fishbucket = "Fishbucket",
        },
        collabs={},
        dictionary={
            overgrowth_grow="Grow",
            mitosis_split="Split",
            invasion_attack="Attack",
            purification_remove="Enrich",
            harmony_balance="Balance",
            season_convert="Transform",
            homework_a="A",
            homework_c="C",
            homework_e="E",
            homework_f="F",
            hungry_1="Munch",
            hungry_2="Chomp",
            hungry_3="Nom nom",
            hungry_4="Burp",
            hungry_5="Gulp",
            hungry_cant="Starves",
            resourceful_pack="Scrounge",
            all_seeing_pack="I see you",
            anchor_sink="Sink",
            faster_than_light_jump="Jump",
            faster_than_light_charge="Charge",
            paperclip_copy="Assimilate",
            spam_1="Mail!",
            spam_2="Click Now!",
            spam_3="Win Big!",
            spam_4="100000$!!",
            spam_5="Top Cards!",
            password_weak="Weak",
            cod_random_joker_change="ability changes at end of round",
            cod_random_joker_name="Unpredictable Joker",
            cod_random_big_joker_name="Possibility Space",
            tapas_bite="Munch",
            black_market_ban="Banned!",
            death_star_destroy="Obliterate!",
            infrastructure_build="Improve",
            printer_print="Print",
            sun_upgrade="Sizzle",
            dormant_awaken="Wake",
            gambler_ruined="Ruined!",
            gambler_win="Roll!",
            coin_toss_heads="Heads!",
            coin_toss_tails="Tails!",
            imprisoned_freed="Freed"
        },
        high_scores={},
        labels={
            cod_envy="Envious",
            cod_dormant="Dormant",
            cod_claustrophobic="Claustrophobic",
            cod_confidential="Confidential",
            cod_expensive="Expensive",
            cod_imprisoned="Imprisoned",
        },
        poker_hand_descriptions={},
        poker_hands={},
        quips={},
        ranks={},
        suits_plural={},
        suits_singular={},
        tutorial={},
        v_dictionary={},
        v_text={
            ch_c_all_confidential={
                "All Jokers are {C:attention}Confidential{}",
            },
            ch_c_all_dormant={
                "All Jokers are {C:attention}Dormant{}",
            },
            ch_c_all_imprisoned={
                "All Jokers are {C:attention}Imprisoned{}",
            },
            ch_c_fishbucket={
                "Only Jokers from Cod's Mod",
            },
        },
    },
}