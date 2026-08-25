local function fair_cols(n)
    for c = 1, n do
        if c * c >= n then return c end
    end
    return n
end

local function fair_grid(n)
    local cols = fair_cols(n)
    local base = math.floor(n / cols)
    local rem = n % cols
    local narrow_cols = cols - rem

    local col_rows = {}
    for c = 0, cols - 1 do
        col_rows[c] = (c < narrow_cols) and base or (base + 1)
    end
    local col_offsets = {}
    local off = 0
    for c = 0, cols - 1 do
        col_offsets[c] = off
        off = off + col_rows[c]
    end
    local function find_col(idx)
        for c = 0, cols - 1 do
            if idx < col_offsets[c] + col_rows[c] then
                return c, idx - col_offsets[c]
            end
        end
        return cols - 1, col_rows[cols - 1] - 1
    end
    local pos = {}
    for i = 0, n - 1 do
        pos[i] = {find_col(i)}
    end
    return pos, cols, col_rows
end

hl.layout.register("fair", {
    recalculate = function(ctx)
        local n = #ctx.targets
        if n == 0 then return end
        if n == 1 then
            ctx.targets[1]:place(ctx.area)
            return
        end

        local pos, cols, col_rows = fair_grid(n)
        local a = ctx.area
        local cw = math.floor(a.w / cols)

        for i, target in ipairs(ctx.targets) do
            local col, row = pos[i - 1][1], pos[i - 1][2]
            local rh = math.floor(a.h / col_rows[col])
            target:place({
                x = a.x + col * cw,
                y = a.y + row * rh,
                w = cw,
                h = rh,
            })
        end
    end,
})
