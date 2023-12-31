-- https://www.ejmastnak.com/tutorials/vim-latex/luasnip/

local ls = require("luasnip")
local s = ls.snippet
local sn = ls.snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local d = ls.dynamic_node
local fmt = require("luasnip.extras.fmt").fmt
local fmta = require("luasnip.extras.fmt").fmta
local rep = require("luasnip.extras").rep
local ms = ls.multi_snippet

local helpers = require('luasnip_helpers.global')
local get_visual = helpers.get_visual
local nl_whitespace = helpers.nl_whitespace
local line_begin = require("luasnip.extras.expand_conditions").line_begin

local tex_utils = require("luasnip_helpers.tex")

-- local tex_utils = {} -- Has to be loaded after lervag/vimtex
-- tex_utils.in_mathzone = function()  -- math context detection
--   return vim.fn["vimtex#syntax#in_mathzone"]() == 1
-- end
-- tex_utils.in_text = function()
--   return not tex_utils.in_mathzone()
-- end
-- tex_utils.in_comment = function()  -- comment detection
--   return vim.fn["vimtex#syntax#in_comment"]() == 1
-- end
-- tex_utils.in_env = function(name)  -- generic environment detection
--     local is_inside = vim.fn["vimtex#env#is_inside"](name)
--     return (is_inside[1] > 0 and is_inside[2] > 0)
-- end
-- -------------------------
-- tex_utils.in_tikz = function()  -- TikZ picture environment detection
--     return tex_utils.in_env("tikzpicture")
-- end
-- tex_utils.in_list = function()
-- 	return tex_utils.in_env("enumerate")
-- end
-- -------------------------
-- tex_utils.in_text_wsnl = function(a, b, c) -- wsnl stands for whitespace / newline
-- 	return tex_utils.in_text() and nl_whitespace(a, b, c)
-- end
-- tex_utils.in_text_lnstart = function(a, b, c)
-- 	return tex_utils.in_text() and line_begin(a, b, c)
-- end
-- tex_utils.in_list_lnstart = function(a, b, c)
-- 	return tex_utils.in_list() and line_begin(a, b, c)
-- end
-- tex_utils.in_tikz_lnstart = function(a, b, c)
-- 	return tex_utils.in_tikz() and line_begin(a, b, c)
-- end
-- tex_utils.in_tikz_nlnstart = function(a, b, c) -- Also has to be whitespace in front
-- 	return tex_utils.in_tikz() and not line_begin(a, b, c) and not not string.match(a, "%s" .. b .. "$")
-- end
-- tex_utils.in_list_nlnstart = function(a, b, c)
-- 	return tex_utils.in_list() and not line_begin(a, b, c)
-- end
-- tex_utils.in_list_nlnstart_math = function()
-- 	return tex_utils.in_list_nlnstart and tex_utils.in_mathzone()
-- end
-- tex_utils.in_flalign = function(a, b, c)
-- 	return tex_utils.in_env("flalign*") and not tex_utils.in_list() and not line_begin(a, b, c)
-- end

-- local nl_whitespace = function(line_to_cursor, matched_trigger, captures)
-- 	local whitespaceEnding = not not string.match(line_to_cursor, "%s" .. matched_trigger .. "$")
-- 	local lineStart = line_begin(line_to_cursor, matched_trigger, captures)
-- 	return whitespaceEnding or lineStart
-- end

-- Function to re-insert capture
-- f( function(_, snip) return snip.captures[1] end )

--------------
-- Snippets --
--------------
return {
	------------------
	-- New document --
	------------------
	s({ trig = "doc", descr = "LaTeX document boilerplate" },
		fmta(
			-- [[
			-- 	%! TEX program = pdf_escaped
			-- 	\documentclass[11pt, oneside]{article}
			-- 	\usepackage{mathtools, amssymb, amsthm, graphicx, enumitem, titlesec, tikz, microtype, minted, xparse, tcolorbox}
			-- 	\usepackage[a4paper, margin=1in]{geometry}
			-- 	\mathtoolsset{showonlyrefs}
			-- 	\graphicspath{ {./images/} }
			-- 	\usepackage[parfill]{parskip}
			-- 	\setlength{\parindent}{0pt}
			--
			-- 	\title{\vspace{-2cm}<>}
			-- 	\author{<>}
			-- 	\date{<>}
			--
			-- 	\renewcommand{\labelenumi}{\alph{enumi})}
			-- 	\titleformat*{\section}{\fontsize{14}{18}\selectfont}
			-- 	\titleformat*{\subsection}{\fontsize{10}{12}\selectfont}
			-- 	\pagestyle{empty}
			-- 	\pagenumbering{gobble}
			--
			-- 	\definecolor{bg}{HTML}{282828}
			-- 	\usemintedstyle{monokai}
			-- 	\setminted{bgcolor=bg}
			--
			-- 	\newtcolorbox{mintedbox}{
			-- 		arc=5mm,
			-- 		colframe = bg,
			-- 		colback = bg,
			-- 	}
			--
			-- 	\begin{document}
			-- 	\maketitle
			--
			-- 	<>
			--
			-- 	\end{document}
			-- ]],
			[[
				\documentclass[10pt, preview, border=2cm]{standalone}
				\usepackage[a4paper, margin=2cm]{geometry}
				\usepackage[parfill]{parskip} % Better line breaks
				\usepackage{xcolor} % Colored text: \textcolor{color}{text}
				\usepackage{lmodern} % Change the font
				\usepackage{multicol} % Add \begin{multicols}{} environment

				%%%%% Images
				\iffalse % This is a native way to use multiline comments
				\usepackage{graphicx} % Images
				\graphicspath{ {./images/} }
				\fi
				%%%%%

				%%%%% Math
				\usepackage{mathtools, amssymb, amsthm, amsmath, array} % Math
				\mathtoolsset{showonlyrefs}
				\setlength{\parindent}{0pt}
				%%%%%

				%%%%% Lists
				\usepackage{enumitem} % Custom lists
				\newcommand\Item[1][]{ % Add a custom list item that removes vertical space with math items
					% Use \Item instead of \item
					\ifx\relax#1\relax  \item \else \item[#1] \fi
					\abovedisplayskip=0pt\abovedisplayshortskip=0pt~\vspace*{-\baselineskip}}
				\renewcommand{\labelenumi}{\alph{enumi})}
				%%%%%

				%%%%% Custom title font sizes
				\usepackage{titlesec} % Changing title font size
				\titleformat*{\section}{\fontsize{14}{18}\selectfont}
				\titleformat*{\subsection}{\fontsize{10}{12}\selectfont}
				%%%%%

				%%%%%% Syntax highlighting with minted
				\iffalse
				% Add this to the beginning when using minted: %! TEX program = pdf_escaped
				\usepackage{minted, tcolorbox} % Code blocks and making them look good
				\definecolor{bg}{HTML}{282828}
				\usemintedstyle{monokai}
				\setminted{bgcolor=bg}
				\newtcolorbox{mintedbox}{
					arc=5mm,
					colframe = bg,
					colback = bg,
				}
				\fi
				%%%%%

				%%%%% Document commands
				\usepackage{xparse} % More advanced document commands
				%%%%%

				%%%%% Tikzpicture
				% \usepackage{tikz} % Tikzpicture to draw pictures

				%%% Pgfplots for plotting graphs
				\iffalse
				\usepackage{pgfplots}
				\pgfplotsset{compat=1.18,width=10cm}
				\usepgfplotslibrary{external}
				\tikzexternalize
				\fi

				% \usepackage[siunitx]{circuitikz} % Circuit diagrams
				%%%%%

				%%%%% Document start
				\title{\vspace{-2cm}<>}
				\author{<>}
				\date{<>}

				\pagestyle{empty}
				\pagenumbering{gobble} % Remove page numbers
				\begin{document}

				\maketitle

				<>

				\end{document}
			]],
			{ i(1, ""), i(2, ""), i(3, ""), i(4) }
		), { condition = line_begin }),
	-------------------
	-- Math Snippets --
	-------------------
	s({ trig = "mm", descr = "Inline Math", snippetType = "autosnippet", wordTrig = false },
		fmta(
			[[<>$ <> $]],
			{ f( function(_, snip) return snip.captures[1] end ), i(1) }
		), { condition = tex_utils.in_text_wsnl }),
	s({ trig = "ml", descr = "Multiline Math", snippetType = "autosnippet", wordTrig = false },
		fmta(
			[[
				\begin{flalign*}
					& <> & <>
				\end{flalign*}
			]],
			{ i(1), i(0) }
		), { condition = tex_utils.in_text_lnstart }),
	s({ trig = "(%s)ll", descr = "Left-aligned newline", snippetType = "autosnippet", wordTrig = false, regTrig = true },
		fmta(
			[[
				<> \\[5pt]
				& <> &
			]],
			{ f( function(_, snip) return snip.captures[1] end ), i(1) }
		), { condition = tex_utils.in_flalign }),
	s({ trig = "me", descr = "Unnumbered equation" },
		fmta(
			[[
				\begin{equation*}
					<>
				\end{equation*}
			]],
			{ i(1) }
		), { condition = tex_utils.in_text_lnstart }),
	---------------------
	s({ trig = "^", descr = "Exponent", snippetType = "autosnippet", wordTrig = false},
		fmta(
			[[^{<>}]],
			{ i(1) }
		), { condition = tex_utils.in_mathzone }),
	s({ trig = "[%s]pp", descr = "Parenthesis", snippetType = "autosnippet", wordTrig = false, regTrig = true },
		fmta(
			[[<>\left(<>\right)]],
			{ f( function(_, snip) return snip.captures[1] end ), i(1) }
		), { condition = tex_utils.in_mathzone }),
	s({ trig = "ff", descr = "Fraction", snippetType = "autosnippet", wordTrig = false },
		fmta(
			[[\frac{<>}{<>}]],
			{ i(1), i(2) }
		), { condition = tex_utils.in_mathzone }),
	s({ trig = "([%s])*", descr = "Multiplication sign", snippetType = "autosnippet", regTrig = true, wordTrig = false },
		fmta(
			[[<>\cdot]],
			{ f( function(_, snip) return snip.captures[1] end ) }
		),
		-- { t([[\cdot]]) },
		{ condition = tex_utils.in_mathzone }),
	s({ trig = "([%s])aa", descr = "Answer (Double underline)", snippetType = "autosnippet", wordTrig = false, regTrig = true },
		fmta(
			[[
				<>\underline{\underline{<>}}
			]],
			{ f( function(_, snip) return snip.captures[1] end ), d(1, get_visual) }
		), { condition = tex_utils.in_mathzone }),
	s({ trig = "und", descr = "Underset text (below other text)", wordTrig = false },
		fmta(
			[[\underset{<>}{<>}]],
			{ i(1, "Under"), d(2, get_visual) }
		), { condition = tex_utils.in_mathzone }),
	s({ trig = "ss", descr = "Square root", wordTrig = false, snippetType="autosnippet" },
		fmta(
			[[\sqrt{<>}]],
			{ i(1) }
		), { condition = tex_utils.in_mathzone }),
	s({ trig = "rr", descr = "Nth root", wordTrig = false, snippetType="autosnippet" },
		fmta(
			[[\sqrt[<>]{<>}]],
			{ i(1), i(2) }
		), { condition = tex_utils.in_mathzone }),
	----------
	-- Text --
	----------
	s({ trig = "(%s)ll", deescr = "Newline with more spacing", snippetType = "autosnippet", regTrig = true, wordTrig = false },
		fmta(
			"<>\\\\[5pt]",
			{ f( function(_, snip) return snip.captures[1] end ) }
		), { condition = tex_utils.in_text }),
	s({ trig = "(%s)nn", deescr = "Newline", snippetType = "autosnippet", regTrig = true, wordTrig = false },
		fmta(
			"<>\\\\",
			{ f( function(_, snip) return snip.captures[1] end ) }
		), { condition = tex_utils.in_text }),
	s({ trig = "pr", descr = "New paragraph", snippetType = "autosnippet", wordTrig = false },
		{ t([[\par]]) },
		{ condition = line_begin }),
	s({ trig = "bold", descr = "Bold text", wordTrig = false },
		fmta(
			[[\textbf{<>}]], -- Get visual does not work here
			{ d(1, get_visual) }
		), { condition = tex_utils.in_text }),
	s({ trig = "ital", descr = "Italic text", wordTrig = false },
		fmta(
			[[\textit{<>}]],
			{ d(1, get_visual) }
		), { condition = tex_utils.in_text }),
	-- These sections use *, and will NOT be shown in the \tableofcontents
	s({ trig = "sec", descr = "Section", wordTrig = false, snippetType = "autosnippet" },
		fmta(
			[[\section*{<>}]],
			{ i(1, "Section") }
		), { condition = tex_utils.in_text_lnstart }),
	s({ trig = "subs", descr = "Subsection", wordTrig = false, snippetType = "autosnippet" },
		fmta(
			[[\subsection*{<>}]],
			{ i("Subsection") }
		), { condition = tex_utils.in_text_lnstart }),
	------------
	-- Images --
	------------
	s({ trig = "img", descr = "Image", regTrig = true, wordTrig = false },
		fmta( -- Can replace \textwidth with \linewidth -- All images are stored in ./images
			[[<>\includegraphics[width=<>\textwidth]{<>}]],
			{ f( function(_, snip) return snip.captures[1] end ), i(1, "0.9"), i(2) }
		), { condition = tex_utils.in_text }),
	s({ trig = "cc", descr = "Inline centered", snippetType = "autosnippet", wordTrig = false },
		fmta(
			[[<>\centerline{<>}]],
			{ f( function(_, snip) return snip.captures[1] end ), d(1, get_visual) }
		), { condition = tex_utils.in_text_lnstart }),
	----------
	-- Tikz --
	----------
	s({ trig = "tt", descr = "Tikz picture", snippetType = "autosnippet", wordTrig = false },
		fmta(
			[[
				\begin{tikzpicture}[scale=<>]
					<>
				\end{tikzpicture}
			]],
			{ i(1, "1.0"), i(2) }
		), { condition = tex_utils.in_text_lnstart }),
	s({ trig = "tc", descr = "Centered tikzpictura", snippetType = "autosnippet", wordTrig = false },
		fmta(
			[[
				\begin{center}
					\begin{tikzpicture}[scale=<>]
						<>
					\end{tikzpicture}
				\end{center}
			]],
			{ i(1, "1.0"), i(2) }
		), { condition = tex_utils.in_text_lnstart }),
	---------- Generic
	s({ trig = "dd", descr = "Generic draw", snippetType = "autosnippet", wordTrig = false },
		fmta(
			[[\draw[<>] ]],
			{ i(1) }
		), { condition = tex_utils.in_tikz_lnstart }),
	---------- Lines
	s({ trig = "dl", descr = "Draw lines", snippetType = "autosnippet", wordTrig = false },
		fmta(
			[[\draw[<>] (<>,<>)]],
			{ i(1), i(2), i(3) }
		), { condition = tex_utils.in_tikz_lnstart }),
	s({ trig = "(%s)dl", descr = "Draw new coordinate", snippetType = "autosnippet", regTrig = true, wordTrig = false },
		fmta(
			[[<>-- (<>,<>)]],
			{ f( function(_, snip) return snip.captures[1] end ), i(1), i(2) }
		), { condition = tex_utils.in_tikz_nlnstart }),
	s({ trig = "(%s)de", descr = "Cycle draw", snippetType = "autosnippet", regTrig = true, wordTrig = false },
		fmta(
			[[<>-- cycle;]],
			{ f( function(_, snip) return snip.captures[1] end ) }
		), { condition = tex_utils.in_tikz_nlnstart }),
	---------- Shapes
	s({ trig = "rr", descr = "Draw rectangle", snippetType = "autosnippet", wordTrig = false },
		fmta(
			[[(<>,<>) rectangle (<>,<>);]],
			{ i(1), i(2), i(3), i(4) }
		), { condition = tex_utils.in_tikz_nlnstart }),
	s({ trig = "ci", descr = "Draw circle", snippetType = "autosnippet", wordTrig = false },
		fmta(
			[[(<>,<>) circle (<>cm);]],
			{ i(1), i(2), i(3) }
		), { condition = tex_utils.in_tikz_nlnstart }),
	s({ trig = "ee", descr = "Draw ellipse", snippetType = "autosnippet", wordTrig = false },
		fmta(
			[[(<>,<>) ellipse (<>cm and <>cm);]],
			{ i(1), i(2), i(3), i(4) }
		), { condition = tex_utils.in_tikz_nlnstart }),
	---------- Grids
	s({ trig = "gg", descr = "Draw grid", snippetType = "autosnippet", wordTrig = false },
		fmta(
			[[\draw[step=<>cm,gray,very thin] (<>,<>) grid (<>,<>);]],
			{ i(1, "1"), i(2, "Bottom"), i(3, "Left"), i(4, "Top"), i(5, "Right") }
		), { condition = tex_utils.in_tikz_lnstart }),
	s({ trig = "ff", descr = "Fill color", snippetType = "autosnippet", wordTrig = false },
		fmta(
			[[\fill[<>!50!white] ]],
			{ i(1, "blue") }
		), { condition = tex_utils.in_tikz_lnstart }),
	s({ trig = "fb", descr = "Fill with border", snippetType = "autosnippet", wordTrig = false},
		fmta(
			[[\filldraw[fill=<>!50!white, draw=black] ]],
			{ i(1, "blue") }
		), { condition = tex_utils.in_tikz_lnstart }),
	s({ trig = "aa", descr = "Draw axes", snippetType = "autosnippet", wordTrig = false },
		fmta(
			[[
				\draw[very thick,-<>] (0,0) -- (<>,0) node[anchor=north west] {<>};
				\draw[very thick,-<>] (0,0) -- (0,<>) node[anchor=south east] {<>};
			]],
			{ t(">"), i(1, "8.5"), i(2, "x-akse"), t(">"), i(3, "8.5"), i(4, "y-akse") }
		), { condition = tex_utils.in_tikz_lnstart }),
	s({ trig = "an", descr = "Axes numbers", snippetType = "autosnippet", wordTrig = false },
		fmta(
			[[
				\foreach \x in {<>,<>,...,<>}
					\draw (\x cm,1pt) -- (\x cm,-1pt) node[anchor=north] {$\x$};
				\foreach \y in {<>,<>,...,<>}
					\draw (1pt, \y cm) -- (-1pt, \y cm) node[anchor=east] {$\y$};
			]],
			{ i(1, "0"), i(2, "Step"), i(3, "8"), i(4, "0"), i(5, "Step"), i(6, "8") }
		), { condition = tex_utils.in_tikz_lnstart }),
	----------
	-- List --
	----------
	s({ trig = "ls", descr = "List a) b) c)", wordTrig = false, snippetType = "autosnippet" },
		fmta(
			[[
				\begin{enumerate}
					<>
				\end{enumerate}
			]],
			{ i(1) }
		), { condition = tex_utils.in_text_lnstart }),
	s({ trig = "lr", descr = "Resume list", wordTrig = false, snippetType = "autosnippet" },
		fmta(
			[[
				\begin{enumerate}[resume]
					<>
				\end{enumerate}
			]],
			{ i(1) }
		), { condition = tex_utils.in_text_lnstart }),
	s({ trig = "li", descr = "List item", snippetType = "autosnippet", wordTrig = false },
		fmta(
			[[<>\item <>]],
			{ f( function(_, snip) return snip.captures[1] end ), i(1) }
		), { condition = tex_utils.in_list_lnstart }),
	s({ trig = "(%s)lm", descr = "List multiline math", snippetType = "autosnippet", wordTrig = false, regTrig = true },
		fmta(
			[[
				<>
					\begin{flalign*}
						& <> & <>
					\end{flalign*}
			]],
			{ f( function(_, snip) return snip.captures[1] end ), i(1), i(2) }
		), { condition = tex_utils.in_list_nlnstart }),
	s({ trig = "(%s)ll", descr = "List math line", snippetType = "autosnippet", wordTrig = false, regTrig = true },
		fmta(
			[[
				<>\\[5pt]
				& <> &
			]],
			{ f( function(_, snip) return snip.captures[1] end ), i(1) }
		), { condition = tex_utils.in_list_nlnstart_math }),
	-----------
	-- Other --
	-----------
	s({ trig = "nc", descr = "New document command", snippetType = "autosnippet", wordTrig = false, regTrig = false },
		fmta(
			[[
				\NewDocumentCommand{\<>}{ <> }{
					<>
				}
			]],
			{ i(1, "name"), i(2, "m 0{0}  (m for mandatory var and 0{default_val} for optional)"), i(3, "Variables with #1 and #2 etc.") }
		), {condition = tex_utils.in_text_lnstart }),
	s({ trig = "bb", descr = "Code block", snippetType = "autosnippet", wordTrig = false, regTrig = false },
		fmta(
			[[
				\begin{mintedbox}
				\begin{minted}{<>}
				<>
				\end{minted}
				\end{mintedbox}
			]],
			{ i(1, "python"), i(2) }
		), { condition = tex_utils.in_text_lnstart }),
	s({ trig = "bi", descr = "Code block import", snippetType = "autosnippet", wordTrig = false, regTrig = false },
		fmta(
			[[
				\begin{mintedbox}
					\inputminted{<>}{<>}
				\end{mintedbox}
			]],
			{ i(1, "python"), i(2, "main.py") }
		), { condition = tex_utils.in_text_lnstart }),


	s({ trig = "env", descr = "Generic environment", snippetTYpe = "autosnippet", wordTrig = false },
		fmta(
			[[
				\begin{<>}
					<>
				\end{<>}
			]],
			{ i(1), i(2), rep(1) }
		), { condition = tex_utils.in_text_lnstart }),
	s({ trig = "cc", descr = "Command with one argument", snippetType = "autosnippet", wordTrig = false },
		fmta(
			[[\<>{<>}]],
			{ i(1), i(2) }
		)),

	---------------------------
	-- Mathematical formulas --
	---------------------------
	-- These should not be autosnippets, and can have longer and more descriptive triggers
	-- Non-autosnippets are triggered with tab, or whichever key is set to trigger them
	s({ trig = "abc", descr = "ABC-formel", wordTrig = false },
		fmta(
			[[<>]],
			{i(1)}
		), { condition = tex_utils.in_mathzone }),
}
