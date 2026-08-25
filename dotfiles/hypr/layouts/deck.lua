hl.layout.register("deck", {
    recalculate = function(ctx)
        local n = #ctx.targets
        if n == 0 then return end
        local a = ctx.area
        local mfact = 0.55

        if n == 1 then
            ctx.targets[1]:place(a)
            return
        end

        local mw = math.floor(a.w * mfact)

        ctx.targets[1]:place({x = a.x, y = a.y, w = mw, h = a.h})

        for i = 2, n do
            ctx.targets[i]:place({x = a.x + mw, y = a.y, w = a.w - mw, h = a.h})
        end
    end,
})
