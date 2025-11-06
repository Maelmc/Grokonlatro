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
        return grokon_in_pool(self, args)
    end
}

SMODS.Joker {
    key = "typhou",
    blueprint_compat = true,
    rarity = 4,
    cost = 20,
    pos = { x = 6, y = 0 },
    soul_pos = {x = 7, y = 0},
    atlas = "grokon_jokers",
    config = { extra = { xmult = 2 } },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.xmult } }
    end,
    calculate = function(self, card, context)
        if context.other_joker and (context.other_joker.config.center.grokon) then
            return {
                xmult = card.ability.extra.xmult
            }
        end
    end,
}