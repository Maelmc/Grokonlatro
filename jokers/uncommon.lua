-- mostly taken from VanillaRemade
SMODS.Joker {
    key = "candide",
    grokon = true,
    pos = {x = 8, y = 0},
    config = {extra = {chips = 50, mult = 10, min_chips_mult = 0, xmult = 2, min_xmult = 1}},
    loc_vars = function(self, info_queue, card)
        local r_chips = {}
        for i = card.ability.extra.min_chips_mult, card.ability.extra.chips do
            r_chips[#r_chips + 1] = tostring(i)
        end
        local r_mults = {}
        for i = card.ability.extra.min_chips_mult, card.ability.extra.mult do
            r_mults[#r_mults + 1] = tostring(i)
        end
        local r_xmults = {}
        for i = card.ability.extra.min_xmult*20, card.ability.extra.xmult*20 do
            r_xmults[#r_xmults + 1] = string.format("%.2f", i/20)
        end
        local loc_chips = (localize('grokon_chips'))
        local loc_mult = (localize('k_mult'))
        local main_start = {
            -- chips
            { n = G.UIT.T, config = { text = '+', colour = G.C.CHIPS, scale = 0.32 } },
            { n = G.UIT.O, config = { object = DynaText({ string = r_chips, colours = { G.C.BLUE }, pop_in_rate = 9999999, silent = true, random_element = true, pop_delay = 0.5, scale = 0.32, min_cycle_time = 0 }) } },
            {n = G.UIT.O,config = {
                    object = DynaText({
                        string = {
                            { string = 'rand()', colour = G.C.JOKER_GREY }, { string = "#@" .. (G.deck and G.deck.cards[1] and G.deck.cards[#G.deck.cards].base.id or 11) .. (G.deck and G.deck.cards[1] and G.deck.cards[#G.deck.cards].base.suit:sub(1, 1) or 'D'), colour = G.C.BLUE },
                            loc_chips, loc_chips, loc_chips, loc_chips, loc_chips, loc_chips, loc_chips, loc_chips, loc_chips,
                            loc_chips, loc_chips, loc_chips, loc_chips },
                        colours = { G.C.UI.TEXT_DARK },
                        pop_in_rate = 9999999,
                        silent = true,
                        random_element = true,
                        pop_delay = 0.2011,
                        scale = 0.32,
                        min_cycle_time = 0
                    })
                }
            },
            -- mult
            { n = G.UIT.T, config = { text = ', ', colour = G.C.L_BLACK, scale = 0.32 } },
            { n = G.UIT.T, config = { text = '+', colour = G.C.MULT, scale = 0.32 } },
            { n = G.UIT.O, config = { object = DynaText({ string = r_mults, colours = { G.C.RED }, pop_in_rate = 9999999, silent = true, random_element = true, pop_delay = 0.5, scale = 0.32, min_cycle_time = 0 }) } },
            {n = G.UIT.O,config = {
                    object = DynaText({
                        string = {
                            { string = 'rand()', colour = G.C.JOKER_GREY }, { string = "#@" .. (G.deck and G.deck.cards[1] and G.deck.cards[#G.deck.cards].base.id or 11) .. (G.deck and G.deck.cards[1] and G.deck.cards[#G.deck.cards].base.suit:sub(1, 1) or 'D'), colour = G.C.RED },
                            loc_mult, loc_mult, loc_mult, loc_mult, loc_mult, loc_mult, loc_mult, loc_mult, loc_mult,
                            loc_mult, loc_mult, loc_mult, loc_mult },
                        colours = { G.C.UI.TEXT_DARK },
                        pop_in_rate = 9999999,
                        silent = true,
                        random_element = true,
                        pop_delay = 0.2011,
                        scale = 0.32,
                        min_cycle_time = 0
                    })
                }
            },
            { n = G.UIT.T, config = { text = ', ', colour = G.C.L_BLACK, scale = 0.32 } },
            -- xmult
            {n=G.UIT.C, config={align = "m", colour = G.C.MULT, r = 0.05, padding = 0.03, res = 0.15}, nodes={
                {n=G.UIT.T, config={text = 'X', colour = G.C.WHITE, scale = 0.32}},
                {n=G.UIT.O, config={object = DynaText({string = r_xmults, colours = {G.C.WHITE},pop_in_rate = 9999999, silent = true, random_element = true, pop_delay = 0.5, scale = 0.32, min_cycle_time = 0})}}
            }},
            {n=G.UIT.O, config={
                object = DynaText({
                    string = {
                        { string = 'rand()', colour = G.C.JOKER_GREY }, { string = "#@" .. (G.deck and G.deck.cards[1] and G.deck.cards[#G.deck.cards].base.id or 11) .. (G.deck and G.deck.cards[1] and G.deck.cards[#G.deck.cards].base.suit:sub(1, 1) or 'D'), colour = G.C.RED },
                        { string = loc_mult, colour = G.C.L_BLACK}, { string = loc_mult, colour = G.C.L_BLACK}, { string = loc_mult, colour = G.C.L_BLACK}, { string = loc_mult, colour = G.C.L_BLACK}, { string = loc_mult, colour = G.C.L_BLACK}, { string = loc_mult, colour = G.C.L_BLACK}, { string = loc_mult, colour = G.C.L_BLACK}, { string = loc_mult, colour = G.C.L_BLACK}, { string = loc_mult, colour = G.C.L_BLACK},
                        { string = loc_mult, colour = G.C.L_BLACK}, { string = loc_mult, colour = G.C.L_BLACK}, { string = loc_mult, colour = G.C.L_BLACK}, { string = loc_mult, colour = G.C.L_BLACK} },
                    colours = {G.C.WHITE},
                    pop_in_rate = 9999999,
                    silent = true,
                    random_element = true,
                    pop_delay = 0.2011,
                    scale = 0.32,
                    min_cycle_time = 0
                })
            }},
        }
        return { main_start = main_start }
    end,
    rarity = 2,
    cost = 7,
    atlas = "grokon_jokers",
    blueprint_compat = true,
    calculate = function(self, card, context)
        if context.joker_main then
            return {
                chips = pseudorandom('candide', card.ability.extra.min_chips_mult, card.ability.extra.chips),
                mult = pseudorandom('candide', card.ability.extra.min_chips_mult, card.ability.extra.mult),
                xmult = pseudorandom('candide', card.ability.extra.min_xmult*20, card.ability.extra.xmult*20)/20,
                message = localize("grokon_chaos")
            }
        end
    end,
    in_pool = function (self, args)
        return grokon_in_pool(self, args)
    end
}

SMODS.Joker {
    key = "santithur",
    grokon = true,
    pos = {x = 12, y = 0},
    config = {extra = {}},
    loc_vars = function(self, info_queue, card)
        return { vars = {} }
    end,
    rarity = 2,
    cost = 6,
    atlas = "grokon_jokers",
    blueprint_compat = true,
    calculate = function(self, card, context)
        if context.before and context.cardarea == G.jokers then
            for _, v in pairs(context.scoring_hand) do
                if SMODS.get_enhancements(v) then
                    v:set_ability(G.P_CENTERS.m_wild,nil,true)
                end
            end
        end
    end,
    in_pool = function (self, args)
        return grokon_in_pool(self, args)
    end
}

SMODS.Joker {
    key = "felt",
    grokon = true,
    pos = {x = 13, y = 0},
    config = {extra = {num = 0, mult = 0, mult_mod = 5}},
    loc_vars = function(self, info_queue, card)
        return { vars = {card.ability.extra.num, card.ability.extra.mult_mod, card.ability.extra.mult} }
    end,
    rarity = 2,
    cost = 6,
    atlas = "grokon_jokers",
    blueprint_compat = true,
    calculate = function(self, card, context)
        if context.fix_probability and not context.blueprint then
            if context.from_roll then
                card.ability.extra.mult = card.ability.extra.mult + card.ability.extra.mult_mod
            end
            return {
                numerator = 0,
                message = localize("k_upgrade_ex")
            }
        end

        if context.joker_main then
            return {
                mult = card.ability.extra.mult
            }
        end
    end,
    in_pool = function (self, args)
        return grokon_in_pool(self, args)
    end
}

SMODS.Joker {
    key = "scarapace",
    grokon = true,
    pos = {x = 0, y = 1},
    config = {extra = {xmult = 3}},
    loc_vars = function(self, info_queue, card)
        return { vars = {card.ability.extra.xmult} }
    end,
    rarity = 2,
    cost = 6,
    atlas = "grokon_jokers",
    blueprint_compat = true,
    calculate = function(self, card, context)
        if context.joker_main and G.GAME.current_round.hands_played == 0 then
            return {
                xmult = card.ability.extra.xmult
            }
        end
    end,
    in_pool = function (self, args)
        return grokon_in_pool(self, args)
    end
}