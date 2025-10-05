function grokon_in_pool(self, args)
    if next(find_joker("Showman")) then
        return true
    end

    if next(find_joker(self.key)) then
        return false
    end

    if self.enhancement_gate and G.playing_cards then
        for _, v in pairs(G.playing_cards) do
            if v.config.center.key == self.enhancement_gate then
                return true
            end
        end
        return false
    end

    return true
end

SMODS.Joker {
    key = "marsh",
    pos = {x = 0, y = 0},
    config = {extra = {}},
    loc_vars = function(self, info_queue, card)
        return {vars = {}}
    end,
    rarity = 1,
    cost = 5,
    atlas = "grokon_jokers",
    blueprint_compat = true,
    calculate = function(self, card, context)
        if context.setting_blind and ((#G.jokers.cards + G.GAME.joker_buffer) < G.jokers.config.card_limit) then
            if pseudorandom("marsh",1,6) == 6 then
                local riz = SMODS.create_card({set = "Joker", area = G.jokers, key = "j_grokon_riz"})
                riz:add_to_deck()
                G.jokers:emplace(riz)
                riz:start_materialize()
                G.E_MANAGER:add_event(Event({
                    func = function() 
                        SMODS.destroy_cards(card, true, nil, true)
                        return true
                    end
                }))
                return {
                    message = localize("grokon_riz_ex")
                }
            else
                local pates = SMODS.create_card({set = "Joker", area = G.jokers, key = "j_grokon_pates"})
                pates:add_to_deck()
                G.jokers:emplace(pates)
                pates:start_materialize()
                return {
                    message = localize("grokon_pates")
                }
            end
        end
    end,
    in_pool = function (self, args)
        return grokon_in_pool(self, args)
    end
}

SMODS.Joker {
    key = "pates",
    pos = {x = 1, y = 0},
    config = {extra = {mult = 20}},
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.mult}}
    end,
    rarity = 1,
    cost = 4,
    atlas = "grokon_jokers",
    blueprint_compat = true,
    calculate = function(self, card, context)
        if context.joker_main then
            return {
                mult = card.ability.extra.mult
            }
        end
    end,
    in_pool = function (self)
        return false
    end,
    calc_dollar_bonus = function(self, card)
        card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize("k_eaten_ex"), colour = G.C.RED})
        SMODS.destroy_cards(card, true, nil, true)
    end
}

SMODS.Joker {
    key = "riz",
    pos = {x = 2, y = 0},
    config = {extra = {mult = 50, mult_minus = 10}},
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.mult, card.ability.extra.mult_minus}}
    end,
    rarity = 1,
    cost = 4,
    atlas = "grokon_jokers",
    blueprint_compat = true,
    calculate = function(self, card, context)
        if context.end_of_round and context.game_over == false and context.main_eval and not context.blueprint then
            if card.ability.extra.mult - card.ability.extra.mult_minus <= 0 then
                SMODS.destroy_cards(card, true, nil, true)
                return {
                    message = localize("k_eaten_ex"),
                    colour = G.C.RED
                }
            else
                card.ability.extra.mult = card.ability.extra.mult - card.ability.extra.mult_minus
                return {
                    message = localize { type = 'variable', key = 'a_mult_minus', vars = { card.ability.extra.mult_minus } },
                    colour = G.C.MULT
                }
            end
        end

        if context.joker_main then
            return {
                mult = card.ability.extra.mult
            }
        end
    end,
    in_pool = function (self, args)
        return false
    end
}

SMODS.Joker {
    key = "revarine",
    pos = { x = 9, y = 0 },
    config = { extra = { chips = 60 } },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.chips } }
    end,
    rarity = 1,
    cost = 5,
    atlas = "grokon_jokers",
    blueprint_compat = true,
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.hand and not context.end_of_round and context.other_card:get_id() == 11 then
            if context.other_card.debuff then
                return {
                    message = localize('k_debuffed'),
                    colour = G.C.RED
                }
            else
                return {
                    mult = card.ability.extra.chips
                }
            end
        end
    end,
}