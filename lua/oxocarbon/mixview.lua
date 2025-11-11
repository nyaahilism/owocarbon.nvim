local highlights = {};
highlights.rgb = function (input)

if type(input) == "string" then
		--- Match cases,
		---     • RR GG BB, # is optional.
		---     • R G B, # is optional.
		---     • Color name.
		---     • HSL values(as `{ h, s, l }`)

		if input:match("^%#?(%x%x?)(%x%x?)(%x%x?)$") then
			--- Pattern explanation:
			---     #? RR? GG? BB?
			--- String should have **3** parts & each part
			--- should have a minimum of *1* & a maximum
			--- of *2* characters.
			---
			--- # is optional.
			---
			---@type string, string, string
			local r, g, b = input:match("^%#?(%x%x?)(%x%x?)(%x%x?)$");

			return { tonumber(r, 16), tonumber(g, 16), tonumber(b, 16) };
		elseif lookup[input] then
			local r, g, b = lookup[input]:match("(%x%x)(%x%x)(%x%x)$");

			return { tonumber(r, 16), tonumber(g, 16), tonumber(b, 16) };
		elseif lookup_nvim[input] then
			local r, g, b = lookup_nvim[input]:match("(%x%x)(%x%x)(%x%x)$");

			return { tonumber(r, 16), tonumber(g, 16), tonumber(b, 16) };
		end

	elseif type(input) == "number" then
		--- Format the number into a hexadecimal string.
		--- Then get the **r**, **g**, **b** parts.
		---
		---@type string, string, string
		local r, g, b = string.format("%06x", input):match("(%x%x)(%x%x)(%x%x)$");

		return { tonumber(r, 16), tonumber(g, 16), tonumber(b, 16) };
	end
end

--- Simple RGB *color-mixer* function.
--- Supports mixing colors by % values.
---
--- NOTE: `per_1` & `per_2` are between
--- **0** & **1**.
---
---@param c_1 number[]
---@param c_2 number[]
---@param per_1 number
---@param per_2 number
---@return number[]
highlights.mix = function (c_1, c_2, per_1, per_2)
	local _r = (c_1[1] * per_1) + (c_2[1] * per_2);
	local _g = (c_1[2] * per_1) + (c_2[2] * per_2);
	local _b = (c_1[3] * per_1) + (c_2[3] * per_2);

	return { math.floor(_r), math.floor(_g), math.floor(_b) };
end

--- RGB to hexadecimal string converter.
---
---@param color number[]
---@return string
highlights.rgb_to_hex = function (color)
	return string.format("#%02x%02x%02x", math.floor(color[1]), math.floor(color[2]), math.floor(color[3]))
end

--- Gets the luminosity of a RGB value.
---
--- Input: `{ r, g, b }` where,
---   r ∈ [0, 255]
---   g ∈ [0, 255]
---   b ∈ [0, 255]
---
--- Return: `l` where,
---   l ∈ [0, 1]
---
---@param input number[]
---@return number
highlights.lumen = function (input)
	local min = math.min(input[1], input[2], input[3]);
	local max = math.max(input[1], input[2], input[3]);

	return (min + max) / 2;
end

--- Turns RGB color-space into Lab.
---@param RGB number[]
---@return number[]
highlights.rgb_to_lab = function (RGB)
	local XYZ = highlights.rgb_to_xyz(RGB);
	return highlights.xyz_to_lab(XYZ);
end

--- Turns Lab color-space into RGB.
---@param Lab number[]
---@return number[]
highlights.lab_to_rgb = function (Lab)
	local XYZ = highlights.lab_to_xyz(Lab);
	return highlights.xyz_to_rgb(XYZ);
end

highlights.palette0 = {
    function()
        local vim_bg = highlights.rgb_to_lab(highlights.rgb("#161626"));
        local h_fg = highlights.rgb_to_lab(highlights.rgb("#505684"));

        local lbg = highlights.lumen(highlights.lab_to_rgb(vim_bg));
        local alpha = (lbg > 0.5 and 0.15 or 0.25);
        local res_bg = highlights.lab_to_rgb(highlights.mix(h_fg, lbg, alpha, 1 - alpha));

        return {
            bg = highlights.rgb_to_hex(res_bg),
            fg = highlights.rgb_to_hex(h_fg)
        };
    end
}

highlights.palette1 = {
    function()
        local vim_bg = highlights.rgb_to_lab(highlights.rgb("#161626"));
        local h_fg = highlights.rgb_to_lab(highlights.rgb("#469ffc"));

        local l_bg = highlights.lumen(highlights.lab_to_rgb(vim_bg));
        local alpha = (l_bg > 0.5 and 0.15 or 0.25);
        local res_bg = highlights.lab_to_rgb(highlights.mix(h_fg, l_bg, alpha, 1 - alpha));

        return {
            bg = highlights.rgb_to_hex(res_bg),
            fg = highlights.rgb_to_hex(h_fg)
        };
    end
}

highlights.palette02 {
    function()
        local vim_bg = highlights.rgb_to_lab(highlights.rgb("#161626"));
        local h_fg = highlights.rgb_to_lab(highlights.rgb("#4acade"));

        local l_bg = highlights.lumen(highlights.lab_to_rgb(vim_bg));
        local alpha = (l_bg > 0.5 and 0.15 or 0.25);
        local res_bg = highlights.lab_to_rgb(highlights.mix(h_fg, l_bg, alpha, 1 - alpha));

        return {
            bg = highlights.rgb_to_hex(res_bg),
            fg = highlights.rgb_to_hex(h_fg)
        };
    end
}
