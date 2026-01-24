return {
    descriptions = {
        Back={
            b_cod_debug={
                name="Debug Deck",
                text={
                    "For Debugging",
                },
                unlock = {
                    "Impossible",
                }
            },
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
        },
        Blind={},
        Edition={},
        Enhanced={},
        Joker={
            j_cod_conspiracy={
                name="The Conspiracy",
                text={
                    "{X:mult,C:white} X#1# {} Mult if played",
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
                    "{X:mult,C:white} X#1# {} Mult if sum",
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
            j_cod_overgrowth={
                name="Overgrowth",
                text={
                    "When {C:attention}Blind{} is selected,",
                    "converts {C:attention}1{} card",
                    "in deck to {V:1}#1#{}",
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
                    "All played scoring",
                    "cards become the",
                    "next suit",
                    "{C:hearts,s:0.8}Hearts{s:0.8} > {C:spades,s:0.8}Spades{s:0.8} > {C:diamonds,s:0.8}Diamonds{s:0.8} > {C:clubs,s:0.8}Clubs",
                },
                unlock = {
                    "Discover all Seasons",
                }
            },
            j_cod_singularity={
                name="Singularity",
                text={
                    "Gives {X:mult,C:white} X#1# {} Mult for each time",
                    "you have played your least",
                    "played {C:attention}poker hand{} this run",
                    "{C:inactive}(Currently {X:mult,C:white} X#2# {C:inactive} Mult)",
                },
                unlock = {
                    "Play every visible {C:attention}poker hand{}",
                    "at least {C:attention}3{} times in a run",
                },
            },
            j_cod_scam={
                name="Scam",
                text={
                    "{X:mult,C:white} X#1# {} Mult"
                }
            },
            j_cod_bully={
                name="Bully",
                text={
                    "{X:mult,C:white} X#1# {} Mult against {C:attention}Small Blinds{}"
                }
            },
            j_cod_hungry={
                name="Hungry Joker",
                text={
                    "When {C:attention}Blind{} is selected,",
                    "destroys {C:attention}1{} random",
                    "card in deck",
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
                    "{V:1}#1#{} cards are ",
                    "drawn last",
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
            },
            j_cod_black_market = {
                name = "Black Market",
                text = {
                    "Each card {C:attention}sold{} is banned",
                    "and this gains {C:mult}+#1#{} Mult",
                    "{C:inactive}(Currently {C:mult}+#2#{C:inactive} Mult)",
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
        },
        Other={},
        Planet={},
        Spectral={},
        Stake={},
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
        },
        collabs={},
        dictionary={
            overgrowth_grow="Grow",
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
        },
        high_scores={},
        labels={},
        poker_hand_descriptions={},
        poker_hands={},
        quips={},
        ranks={},
        suits_plural={},
        suits_singular={},
        tutorial={},
        v_dictionary={},
        v_text={},
    },
}