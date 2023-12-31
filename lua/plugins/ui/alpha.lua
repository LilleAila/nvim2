local if_nil = vim.F.if_nil
local leader = "SPC"

local function button(sc, icon, txt, keybind, keybind_opts)
	local sc_ = sc:gsub("%s", ""):gsub(leader, "<leader>")

	local opts = {
		position = "center",
		shortcut = sc,
		cursor = 3,
		width = 50,
		align_shortcut = "right",
		-- hl_shortcut = "Keyword",
		hl_shortcut = "Type", -- Blue instead of orange
	}
	if keybind then
		keybind_opts = if_nil(keybind_opts, { noremap = true, silent = true, nowait = true })
		opts.keymap = { "n", sc_, keybind, keybind_opts }
	end

	local function on_press()
		local key = vim.api.nvim_replace_termcodes(keybind or sc_ .. "<Ignore>", true, false, true)
		vim.api.nvim_feedkeys(key, "t", false)
	end

	return {
		type = "button",
		val = icon .. "  " .. txt,
		on_press = on_press,
		opts = opts,
	}
end

local padding = { type = "padding", val = 2 }

local factorio = {
	[[                 ttf(U                ]],
	[[                 fxctzO               ]],
	[[      n)(u    [|(jUUJuqm     $ $      ]],
	[[     {11zf00fnc|tUcCQnLvzfjn (YCLh    ]],
	[[      qJXc`.crvcXJjC/xUQOUw0vuYXUJk   ]],
	[[      1nn"vvrxnutcx0JcvLYzXcQZJch     ]],
	[[     1)vnnrunX0hopqdpbdCmrcvJvhpk     ]],
	[[    /1LLvjvXZa*        mdZzYcXLbq     ]],
	[[+|lOnO+YCzYqba          zOuvrnxpwm    ]],
	[[|)ufz[ucvCbdk            J{uzvXYkLUU0O]],
	[[mhphJtLvnxjkh            xicvnuZwxzumq]],
	[[    nxmuZcXnbh          U.rnxUuwzZxCkd]],
	[[     xY0czvvrmd        t+nYrYcZh&M    ]],
	[[     jv0JXcuYYfOpqZccX}rYXXuJO&kM     ]],
	[[     )nnX0CuJvznmQxunXj(urjzqa*W      ]],
	[[   xqpJtYCbbJJJvuJrnxuUvvJbMm0Yo      ]],
	[[    Zdkp8 &#h**MZYLzuC8o#WMYQYhMk     ]],
	[[              &o0Jzp&&WW   $###W      ]],
	[[               kzvuU8                 ]],
	[[               faM#h                  ]],
}

return {
	{
		"goolord/alpha-nvim",
		dependencies = { "nvim-tree/nvim-web-devicons", {
			"MaximilianLloyd/ascii.nvim",
			dependencies = "MunifTanjim/nui.nvim"
		}},
		config = function()
			local ascii = require("ascii")

			local header = {
					type = "text",
					-- val = ascii.get_random("text", "neovim"),
					-- val = ascii.art.planets.planets.saturn_plus,
					val = factorio,
					-- val = ascii.art.gaming.doom.logo,
					opts = {
							position = "center",
							-- hl = "Type",
							hl = "Keyword" -- Orange instead of blue header
					},
			}

			-- require("alpha").setup(require("alpha.themes.dashboard").config)
			require("alpha").setup({
				layout = {
					padding,
					header,
					padding,
					{
						type = "group",
						val = {
							button("n", "", "New file", "<cmd>ene<cr>"),
							button("SPC e e", "", "File browser"),
							button("SPC e t", "󰙅", "Nvim Tree"),
							button("SPC s c", "󱦺", "Load cwd session"),
							button("SPC s l", "󰥔", "Load last session"),
							button("SPC s o", "", "Pick session"),
							button("SPC m c", "", "Change color scheme"),
							button("c", "", "Edit config", "<cmd>cd ~/.config/nvim<cr> <cmd>SessionManager load_current_dir_session<cr>"), -- CD to config and load last session
							button("q", "", "Quit", "<cmd>qa!<cr>"),
						},
						opts = {
							spacing = 1,
						}
					},
				},
				opts = {
					margin = 5,
				},
			})
		end,
	}
}
