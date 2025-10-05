SMODS.Joker {
    key = "echelle",
    pos = {x = 3, y = 0},
    config = {extra = {xmult_mod = 0.2, xmult = 1, last_hand = "None"}},
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.xmult_mod, card.ability.extra.xmult, G.GAME.last_hand_played and localize(G.GAME.last_hand_played, 'poker_hands') or localize("grokon_none")}}
    end,
    rarity = 3,
    cost = 8,
    atlas = "grokon_jokers",
    blueprint_compat = true,
    calculate = function(self, card, context)
        if context.before and not context.blueprint then
            if G.GAME.last_hand_played == card.ability.extra.last_hand then
                card.ability.extra.xmult = card.ability.extra.xmult + card.ability.extra.xmult_mod
                return {
                    message = localize('grokon_stable_ex'),
                    colour = G.C.MULT
                }
            else
                card.ability.extra.xmult = 1
                card.ability.extra.last_hand = context.scoring_name
                return {
                    message = localize('grokon_instable_dot'),
                }
            end
        end

        if context.joker_main then
            return {
                xmult = card.ability.extra.xmult
            }
        end
    end,
    add_to_deck = function (self, card, from_debuff)
        card.ability.extra.last_hand = G.GAME.last_hand_played or "None"
    end,
    in_pool = function (self, args)
        return grokon_in_pool(self, args)
    end
}

SMODS.Joker {
    key = "turnute",
    pos = {x = 10, y = 0},
    config = {extra = {money = 1}},
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.money}}
    end,
    rarity = 3,
    cost = 8,
    atlas = "grokon_jokers",
    blueprint_compat = true,
    calculate = function(self, card, context)
        if context.buying_card and not context.blueprint then
            return {
                message = localize('grokon_achete'),
            }
        end
    end,
    add_to_deck = function (self, card, from_debuff)
        G.GAME.turnute_reduc = (G.GAME.turnute_reduc or 0) + card.ability.extra.money
        G.GAME.round_resets.reroll_cost = G.GAME.round_resets.reroll_cost - card.ability.extra.money
        G.GAME.current_round.reroll_cost = math.max(0, G.GAME.current_round.reroll_cost - card.ability.extra.money)
        G.E_MANAGER:add_event(Event({func = function()
            for _, v in pairs(G.I.CARD) do
                if v.set_cost then v:set_cost() end
            end
            return true end
        }))
    end,
    remove_from_deck = function(self, card, from_debuff)
        G.GAME.turnute_reduc = G.GAME.turnute_reduc - card.ability.extra.money
        G.GAME.round_resets.reroll_cost = G.GAME.round_resets.reroll_cost + card.ability.extra.money
        G.GAME.current_round.reroll_cost = math.max(0, G.GAME.current_round.reroll_cost + card.ability.extra.money)
        G.E_MANAGER:add_event(Event({func = function()
            for _, v in pairs(G.I.CARD) do
                if v.set_cost then v:set_cost() end
            end
            return true end
        }))
    end,
    in_pool = function (self, args)
        return grokon_in_pool(self, args)
    end
}

SMODS.Joker {
    key = "boba",
    pos = {x = 11, y = 0},
    config = {extra = {mult = 0, mult_mod = 2}},
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.mult_mod, card.ability.extra.mult}}
    end,
    rarity = 3,
    cost = 8,
    atlas = "grokon_jokers",
    blueprint_compat = true,
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play and context.other_card:get_id() == 2 and not context.blueprint then
            card.ability.extra.mult = card.ability.extra.mult + card.ability.extra.mult_mod

            return {
                message = localize('grokon_johto_caps'),
                colour = G.C.MULT,
                message_card = card
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