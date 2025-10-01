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
}

SMODS.Joker {
    key = "expedixon",
    pos = {x = 4, y = 0},
    soul_pos = {x = 5, y = 0},
    config = {extra = {common = 3, rare = 1}},
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.common, card.ability.extra.rare}}
    end,
    rarity = 4,
    cost = 20,
    atlas = "grokon_jokers",
    blueprint_compat = true,
    calculate = function(self, card, context)
        if context.setting_blind then
            for i = 1, #G.jokers.cards do
                local v = G.jokers.cards[i]
                if v.ability.expedixon then
                    G.E_MANAGER:add_event(Event({
                    func = function() 
                        SMODS.destroy_cards(v, true, nil, true)
                        return true
                    end
                }))
                end
            end
            for _ = 1, card.ability.extra.common do
                local rarity = pseudorandom("expedixon",1,100) < 70*1.05263158 and "Common" or "Uncommon"
                local cardgen = SMODS.create_card({
                    set = "Joker",
                    area = G.jokers,
                    rarity = rarity,
                    edition = "e_negative",
                    stickers = {"eternal"},
                    force_stickers = true,
                    key_append = 'expedixon'
                })
                cardgen.ability.expedixon = true
                cardgen:add_to_deck()
                G.jokers:emplace(cardgen)
                cardgen:start_materialize()
            end
            for _ = 1, card.ability.extra.rare do
                local rarity = pseudorandom("expedixon",1,1) == 1 and "Legendary" or "Rare"
                local cardgen = SMODS.create_card({
                    set = "Joker",
                    area = G.jokers,
                    rarity = rarity,
                    edition = "e_negative",
                    legendary = rarity == "Legendary" or nil,
                    stickers = {"eternal"},
                    force_stickers = true,
                    key_append = 'expedixon'
                })
                cardgen.ability.expedixon = true
                cardgen:add_to_deck()
                G.jokers:emplace(cardgen)
                cardgen:start_materialize()
            end
        end
    end,
    in_pool = function (self, args)
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
}