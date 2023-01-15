local line_begin = require("luasnip.extras.expand_conditions").line_begin
local tex_utils = {}
tex_utils.in_mathzone = function()  -- math context detection
    return vim.fn['vimtex#syntax#in_mathzone']() == 1
    -- return vim.eval('vimtex#syntax#in_mathzone()') == 1
end

tex_utils.in_text = function()
  return not tex_utils.in_mathzone()
end

tex_utils.in_comment = function()  -- comment detection
  return vim.fn['vimtex#syntax#in_comment']() == 1
end

tex_utils.in_env = function(name)  -- generic environment detection
    local is_inside = vim.fn['vimtex#env#is_inside'](name)
    return (is_inside[1] > 0 and is_inside[2] > 0)
end

-- A few concrete environments---adapt as needed
tex_utils.in_equation = function()  -- equation environment detection
    return tex_utils.in_env('equation')
end

tex_utils.in_itemize = function()  -- itemize environment detection
    return tex_utils.in_env('itemize')
end

tex_utils.in_tikz = function()  -- TikZ picture environment detection
    return tex_utils.in_env('tikzpicture')
end

local get_visual = function(args, parent)
  if (#parent.snippet.env.SELECT_RAW > 0) then
    return sn(nil, i(1, parent.snippet.env.SELECT_RAW))
  else  -- If SELECT_RAW is empty, return a blank insert node
    return sn(nil, i(1))
  end
end

-- ######################  actual snippets  ####################

return {
s({trig = "template", dscr="Basic template"},
    fmta(
        [[
            \documentclass[a4paper]{article}

            \usepackage[utf8]{inputenc}
            \usepackage[T1]{fontenc}
            \usepackage{textcomp}
            \usepackage[dutch]{babel}
            \usepackage{amsmath, amssymb}


            % figure support
            \usepackage{import}
            \usepackage{xifthen}
            \pdfminorversion=7
            \usepackage{pdfpages}
            \usepackage{transparent}
            \newcommand{\incfig}[1]{%
                \def\svgwidth{\columnwidth}
                \import{./figures/}{#1.pdf_tex}
            }

            \pdfsuppresswarningpagegroup=1

            \begin{document}
                <>
            \end{document}
        ]],
        {
            i(1),
        }
    ),
    {condition = line_begin}
),

s({
    trig="beg",
    dscr="begin{} / end{}",
    regTrig=false,
    priority=100,
    snippetType="autosnippet"
    },
    fmta(
        [[
            \begin{<>}
                <>
            \end{<>}
        ]],
        {
            i(1),
            i(2),
            rep(1),
        }
    ),
    {condition = line_begin}
),

s({trig="...", dscr="ldots", snippetType="autosnippet", priority = 100},
    { t("\\ldots") },
    { condition = tex_utils.in_mathzone }
),

s({trig="table", dscr="table environment"},
    fmta(
        [[
            \begin{table}[<>]
                \centering
                \caption{<>}
                \label{tab:<>}
                \begin{tabular}{<>}
                    <>
                \end{tabular}
            \end{table}
        ]],
        {
            i(1, "htpb"),
            i(2, "caption"),
            i(3, "label"),
            i(4, "c"),
            i(0),
        }
    ),
    { condition = line_begin }
),

s({trig="ltable", dscr="ltable environment"},
    fmta(
        [[
            \begin{longtable}{| p{<>} | <>}
                \hline
                \begin{center}
                   <>
                \end{center} <><>
                \hline
            \end{longtable}
        ]],
        {
            i(1, "0.25\\textwidth"),
            i(2, "p{.25\\textwidth} | p{.25\\textwidth} | p{.25\\textwidth} |"),
            i(3),
            i(4, " & "),
            i(0),
        }
    ),
    { condition = line_begin }
),

s({trig="arr", dscr="array environment"},
    fmta(
        [[
           \begin{array}{<>}
               <>
            \end{array}
        ]],
        {
            i(1, " c c "),
            i(2),
        }
    ),
    { condition = line_begin }
),

s({trig="fig", dscr="Figure environment"},
    fmta(
        [[
            \begin{figure}[<>]
                \centering
                <>
                \caption{<>}
                \label{fig:<>}
            \end{figure}
        ]],
        {
            i(1, "htpb"),
            sn(2, {
                t"\\includegraphics[width=0.8\\textwidth]{", i(1), t"}"
            }),
            i(3),
            i(4),
        }
    ),
    { condition = line_begin }
),

s({trig="enum", dscr="Enumerate"},
    fmta(
        [[
            \begin{enumerate}
                \item <>
            \end{enumerate}
        ]],
        {
            i(1),
        }
    ),
    { condition = line_begin }
),

s({trig="enum", dscr="Itemize"},
    fmta(
        [[
            \begin{itemize}
                \item <>
            \end{itemize}
        ]],
        {
            i(1),
        }
    ),
    { condition = line_begin }
),

s({trig="pack", dscr="Package", snippetType="autosnippet"},
    fmta(
        [[
            \usepackage[<>]{<>}<>
        ]],
        {
            i(1, "options"),
            i(2, "package"),
            i(0),
        }
    ),
    { condition = line_begin }
),

s({trig = "([^%a])mm", dscr='Inline math', wordTrig = false, regTrig = true, snippetType="autosnippet"},
  fmta(
    "<>$<>$",
    {
      f( function(_, snip) return snip.captures[1] end ),
      d(1, get_visual),
    }
  )
),

s({trig="dm",dscr='Math block',  snippetType='autosnippet'},
    fmta(
        [[
            \[
                <>
            .\] <>
        ]],
        {
            d(1, get_visual),
            i(0),
        }
    ),
    { condition = line_begin }
),

s({trig="ali", dscr='Align environment', snippetType='autosnippet'},
    fmta(
        [[
            \begin{align*}
                <>
            .\end{align*} <>
        ]],
        {
            d(1, get_visual),
            i(0),
        }
    ),
    { condition = line_begin }
),

s({trig="eqn", dscr='Align environment with label', snippetType='autosnippet'},
    fmta(
        [[
            \begin{align}
                <>
            .\end{align} <>
        ]],
        {
            d(1, get_visual),
            i(0),
        }
    ),
    { condition = line_begin }
),

s({trig="([^%a])ee", dscr='Exponent', regTrig=true, wordTrig=false, snippetType="autosnippet"},
    fmta(
        "<>e^{<>}",
        {
            f( function(_, snip) return snip.captures[1] end ),
            d(1, get_visual),
        }
    ),
    { condition = tex_utils.in_mathzone }
),

s({trig="([^%a])ff", dscr='Fraction', regTrig=true, wordTrig=false, snippetType="autosnippet"},
    fmta(
        [[<>\frac{<>}{<>}]],
        {
            f( function(_, snip) return snip.captures[1] end ),
            i(1),
            i(2),
        }
    ),
    { condition = tex_utils.in_mathzone }
),

s({trig="=>", dscr='Implies', snippetType="autosnippet"},
    { t("\\implies") },
    { condition = tex_utils.in_mathzone }
),

s({trig="=<", dscr='Implied by', snippetType="autosnippet"},
    { t("\\impliedby") },
    { condition = tex_utils.in_mathzone }
),

s({trig="iff", dscr='If and only if', snippetType="autosnippet"},
    { t("\\iff") },
    { condition = tex_utils.in_mathzone }
),

s({trig="neg", dscr='Negation', snippetType="autosnippet"},
    { t("\\neg") },
    { condition = tex_utils.in_mathzone }
),

s({trig="xor", dscr='XOR', snippetType="autosnippet"},
    { t("\\oplus") },
    { condition = tex_utils.in_mathzone }
),

s({trig='(%a)(%d)', dscr='Auto subscript', regTrig=true, wordTrig=false, snippetType='autosnippet'},
    fmta(
        "<>_<>",
        {
            f( function(_, snip) return snip.captures[1] end ),
            f( function(_, snip) return snip.captures[2] end ),
        }
    ),
    { condition = tex_utils.in_mathzone }
),

s({trig="([%a])_(%d%d)", dscr='Auto subscript2', regTrig=true, wordTrig=false, snippetType='autosnippet'},
    fmta(
        "<>_{<>}",
        {
            f( function(_, snip) return snip.captures[1] end ),
            f( function(_, snip) return snip.captures[2] end ),
        }
    ),
    { condition = tex_utils.in_mathzone }
),

s({trig='sympy', dscr='Sympy environment', snippetType='autosnippet'},
    fmta(
        "sympy <> sympy<>",
        {
            i(1),
            i(0),
        }
    ),
    { condition = line_begin }
),

s({trig="!=", dscr='Equals', snippetType="autosnippet"},
    { t("\\neq") },
    { condition = tex_utils.in_mathzone }
),

s({trig="()", dscr='Parentheses', snippetType="autosnippet"},
    fmta(
        [[ \left( <> \right) <> ]],
        {
            d(1, get_visual),
            i(0),
        }
    ),
    { condition = tex_utils.in_mathzone }
),

s({trig="lr", dscr='Parentheses', snippetType="autosnippet"},
    fmta(
        [[ \left( <> \right) <> ]],
        {
            d(1, get_visual),
            i(0),
        }
    ),
    { condition = tex_utils.in_mathzone }
),

s({trig="lr(", dscr='Parentheses', snippetType="autosnippet"},
    fmta(
        [[ \left( <> \right) <> ]],
        {
            d(1, get_visual),
            i(0),
        }
    ),
    { condition = tex_utils.in_mathzone }
),

s({trig="lr|", dscr='Parentheses', snippetType="autosnippet"},
    fmta(
        [[ \left| <> \right| <> ]],
        {
            d(1, get_visual),
            i(0),
        }
    ),
    { condition = tex_utils.in_mathzone }
),

s({trig="lr{", dscr='Parentheses', snippetType="autosnippet"},
    fmta(
        [[ \left\\{ <> \right\\} <> ]],
        {
            d(1, get_visual),
            i(0),
        }
    ),
    { condition = tex_utils.in_mathzone }
),

s({trig="lrb", dscr='Parentheses', snippetType="autosnippet"},
    fmta(
        [[ \left\\{ <> \right\\} <> ]],
        {
            d(1, get_visual),
            i(0),
        }
    ),
    { condition = tex_utils.in_mathzone }
),

s({trig="lr[", dscr='Parentheses', snippetType="autosnippet"},
    fmta(
        [[ \left[ <> \right] <> ]],
        {
            d(1, get_visual),
            i(0),
        }
    ),
    { condition = tex_utils.in_mathzone }
),

s({trig='conj', dscr='Conjugate', snippetType='autosnippet'},
    fmta(
        [[ \overline{<>}<> ]],
        {
            i(1),
            i(0),
        }
    ),
    { condition = tex_utils.in_mathzone }
),

s({trig='sum', dscr='Sum', snippetType='autosnippet'},
    fmta(
        [[ \sum_{n=<>}^{<>} <> ]],
        {
            i(1, '1'),
            i(2, '\\infty'),
            i(3, 'a_n z^n'),
        }
    ),
    { condition = tex_utils.in_mathzone }
),

s({trig='taylor', dscr='Taylor series', snippetType='autosnippet'},
    fmta(
        [[ \sum_{<>=<>}^{<>} <> (x-a)^<> <> ]],
        {
            i(1, 'k'),
            i(2, '0'),
            i(3, '\\infty'),
            sn(4, {
                t"c_", rep(1)
            }),
            rep(1),
            i(0),
        }
    ),
    { condition = tex_utils.in_mathzone }
),

s({trig='limit', dscr='Limit', snippetType='autosnippet'},
    fmta(
        [[ \lim_{<> \to <>} ]],
        {
            i(1, 'n'),
            i(2, '\\infty'),
        }
    ),
    { condition = tex_utils.in_mathzone }
),

s({trig='part', dscr='d/dx', snippetType='autosnippet'},
    fmta(
        [[ \frac{\partial <>}{\partial <>} <> ]],
        {
            i(1, 'V'),
            i(2, 'x'),
            i(0),
        }
    ),
    { condition = tex_utils.in_mathzone }
),

s({trig='sq', dscr='\\sqrt{}', snippetType='autosnippet'},
    fmta(
        [[ \sqrt{<>} <>]],
        {
            d(1, get_visual),
            i(0),
        }
    ),
    { condition = tex_utils.in_mathzone }
),

s({trig='sr', dscr='^2', snippetType='autosnippet'},
    t("^2"),
    { condition = tex_utils.in_mathzone }
),

s({trig='cb', dscr='^3', snippetType='autosnippet'},
    t("^3"),
    { condition = tex_utils.in_mathzone }
),

s({trig='td', dscr='to the ... power', snippetType='autosnippet'},
    fmta(
        [[ ^{<>}<> ]],
        {
            i(1),
            i(0),
        }
    ),
    { condition = tex_utils.in_mathzone }
),

s({trig='__', dscr='subscript', snippetType='autosnippet'},
    fmta(
        [[ _{<>}<> ]],
        {
            i(1),
            i(0),
        }
    ),
    { condition = tex_utils.in_mathzone }
),

s({trig='000', dscr='\\infty', snippetType='autosnippet'},
    t("\\infty"),
    { condition = tex_utils.in_mathzone }
),

s({trig='rij', dscr='mrij', snippetType='autosnippet'},
    fmta(
        [[ (<>_<>)_{<>\in<>}<>]],
        {
            i(1, 'x'),
            i(2, 'n'),
            rep(2),
            i(3, '\\N'),
            i(0),
        }
    ),
    { condition = tex_utils.in_mathzone }
),

s({trig='<=', dscr='leq', snippetType='autosnippet'},
    t("\\leq"),
    { condition = tex_utils.in_mathzone }
),

s({trig='>=', dscr='geq', snippetType='autosnippet'},
    t("\\geq"),
    { condition = tex_utils.in_mathzone }
),

s({trig='EE', dscr='Exists', snippetType='autosnippet'},
    t("\\exists"),
    { condition = tex_utils.in_mathzone }
),

s({trig='AA', dscr='For all', snippetType='autosnippet'},
    t("\\forall"),
    { condition = tex_utils.in_mathzone }
),

s({trig='xnn', dscr='x_n', snippetType='autosnippet'},
    t("x_{n}"),
    { condition = tex_utils.in_mathzone }
),

s({trig='ynn', dscr='y_n', snippetType='autosnippet'},
    t("y_{n}"),
    { condition = tex_utils.in_mathzone }
),

s({trig='xii', dscr='x_i', snippetType='autosnippet'},
    t("x_{i}"),
    { condition = tex_utils.in_mathzone }
),

s({trig='yii', dscr='y_i', snippetType='autosnippet'},
    t("y_{i}"),
    { condition = tex_utils.in_mathzone }
),

s({trig='xjj', dscr='x_j', snippetType='autosnippet'},
    t("x_{j}"),
    { condition = tex_utils.in_mathzone }
),

s({trig='yjj', dscr='y_j', snippetType='autosnippet'},
    t("y_{j}"),
    { condition = tex_utils.in_mathzone }
),

s({trig='xp1', dscr='x_{n+1}', snippetType='autosnippet'},
    t("x_{n+1)"),
    { condition = tex_utils.in_mathzone }
),

s({trig='xmm', dscr='x_m', snippetType='autosnippet'},
    t("x_{m}"),
    { condition = tex_utils.in_mathzone }
),

s({trig='R0+', dscr='R0+', snippetType='autosnippet'},
    t("\\R_0^+")
),

s({trig='plot', dscr='Plot', snippetType='autosnippet'},
    fmta(
        [[
            \begin{figure}[<>]
                \centering
                \begin{tikzpicture}
                    \begin{axis}[
                        xmin= <>, xmax= <>,
                        ymin= <>, ymax= <>,
                        axis lines = middle,
                    ]
                        \addplot[domain=<>:<>, sample=<>]{<>};
                    \end{axis}
                \end{tikzpicture}
                \caption{<>}
                \label{<>}
            \end{figure}
        ]],
        {
            i(1),
            i(2, "-10"),
            i(3, "10"),
            i(4, "-10"),
            i(5, "10"),
            rep(2),
            rep(3),
            i(6, "100"),
            i(7),
            i(8),
            i(9, rep(8)),
        }
    ),
    { condition = line_begin }
),

s({trig='mcal', dscr='mathcal', snippetType='autosnippet'},
    fmta(
        [[ \mathcal{<>}<> ]],
        {
            i(1),
            i(0),
        }
    ),
    { condition = tex_utils.in_mathzone }
),

s({trig='xx', dscr='cross', snippetType='autosnippet'},
    t("\\times"),
    { condition = tex_utils.in_mathzone }
),


s({trig='**', dscr='cdot', snippetType='autosnippet'},
    t("\\cdot"),
    { condition = tex_utils.in_mathzone }
),


s({trig='abs', dscr='norm', snippetType='autosnippet'},
    fmta(
        [[ \|<>\|<> ]],
        {
            i(1),
            i(0),
        }
    ),
    { condition = tex_utils.in_mathzone }
),

s({trig='sin', dscr='sin', snippetType='autosnippet'},
    t("\\sin"),
    { condition = tex_utils.in_mathzone }
),

s({trig='cos', dscr='cos', snippetType='autosnippet'},
    t("\\cos"),
    { condition = tex_utils.in_mathzone }
),

s({trig='arccot', dscr='arccot', snippetType='autosnippet'},
    t("\\arccot"),
    { condition = tex_utils.in_mathzone }
),

s({trig='cot', dscr='cot', snippetType='autosnippet'},
    t("\\cot"),
    { condition = tex_utils.in_mathzone }
),

s({trig='csc', dscr='csc', snippetType='autosnippet'},
    t("\\csc"),
    { condition = tex_utils.in_mathzone }
),

s({trig='ln', dscr='ln', snippetType='autosnippet'},
    t("\\ln"),
    { condition = tex_utils.in_mathzone }
),

s({trig='log', dscr='log', snippetType='autosnippet'},
    t("\\log"),
    { condition = tex_utils.in_mathzone }
),

s({trig='exp', dscr='exp', snippetType='autosnippet'},
    t("\\exp"),
    { condition = tex_utils.in_mathzone }
),

s({trig='pi', dscr='pi', snippetType='autosnippet'},
    t("\\pi"),
    { condition = tex_utils.in_mathzone }
),

s({trig='zeta', dscr='zeta', snippetType='autosnippet'},
    t("\\zeta"),
    { condition = tex_utils.in_mathzone }
),

s({trig='int', dscr='int', priority=100, snippetType='autosnippet'},
    t("\\int"),
    { condition = tex_utils.in_mathzone }
),

s({trig='dint', dscr='Definitive integral', snippetType='autosnippet'},
    fmta(
        [[ \int_{<>}^{<>} <> <> ]],
        {
            i(1, '-\\infty'),
            i(2, '\\infty'),
            d(3, get_visual),
            i(0),
        }
    ),
    { condition = tex_utils.in_mathzone }
),

s({trig='->', dscr='to', priority=100, snippetType='autosnippet'},
    t("\\to"),
    { condition = tex_utils.in_mathzone }
),

s({trig='<->', dscr='leftrightarrow', priority=100, snippetType='autosnippet'},
    t("\\leftrightarrow"),
    { condition = tex_utils.in_mathzone }
),

s({trig='!>', dscr='mapsto', priority=100, snippetType='autosnippet'},
    t("\\mapsto"),
    { condition = tex_utils.in_mathzone }
),

s({trig='^-1', dscr='inverse', priority=100, snippetType='autosnippet'},
    t("^{-1}"),
    { condition = tex_utils.in_mathzone }
),

s({trig='\\\\\\', dscr='setminus', priority=100, snippetType='autosnippet'},
    t("\\setminus"),
    { condition = tex_utils.in_mathzone }
),

s({trig='>>', dscr='>>', priority=100, snippetType='autosnippet'},
    t("\\gg"),
    { condition = tex_utils.in_mathzone }
),

s({trig='<<', dscr='<<', priority=100, snippetType='autosnippet'},
    t("\\ll"),
    { condition = tex_utils.in_mathzone }
),

s({trig='~~', dscr='~', priority=100, snippetType='autosnippet'},
    t("\\sim"),
    { condition = tex_utils.in_mathzone }
),

s({trig='set', dscr='set', priority=100, snippetType='autosnippet'},
    fmta(
        [[ \\{<>\\} <> ]],
        {
            i(1),
            i(0),
        }
    ),
    { condition = tex_utils.in_mathzone }
),

s({trig='||', dscr='mid', priority=100, snippetType='autosnippet'},
    t("\\mid"),
    { condition = tex_utils.in_mathzone }
),

s({trig='cc', dscr='subset', priority=100, snippetType='autosnippet'},
    t("\\subset"),
    { condition = tex_utils.in_mathzone }
),

s({trig='notin', dscr='not in', priority=100, snippetType='autosnippet'},
    t("\\not\\in"),
    { condition = tex_utils.in_mathzone }
),

s({trig='inn', dscr='in', priority=100, snippetType='autosnippet'},
    t("\\in"),
    { condition = tex_utils.in_mathzone }
),

s({trig='NN', dscr='n', priority=100, snippetType='autosnippet'},
    t("\\N"),
    { condition = tex_utils.in_mathzone }
),

s({trig='nn', dscr='Cap symbol', priority=100, snippetType='autosnippet'},
    t("\\cap"),
    { condition = tex_utils.in_mathzone }
),

s({trig='uu', dscr='Cup symbol', priority=100, snippetType='autosnippet'},
    t("\\cup"),
    { condition = tex_utils.in_mathzone }
),

s({trig='Nnn', dscr='Big cap symbol', priority=100, snippetType='autosnippet'},
    fmta(
        [[ \bigcap_{<>} <> ]],
        {
            sn(1, {
                i(1, 'i \\in '), i(2, "I")
            }),
            i(0),
        }
    ),
    { condition = tex_utils.in_mathzone }
),

s({trig='Uuu', dscr='Big cap symbol', priority=100, snippetType='autosnippet'},
    fmta(
        [[ \bigcup_{<>} <> ]],
        {
            sn(1, {
                i(1, 'i \\in '), i(2, "I")
            }),
            i(0),
        }
    ),
    { condition = tex_utils.in_mathzone }
),

s({trig='00', dscr='empty set', priority=100, snippetType='autosnippet'},
    t("\\0"),
    { condition = tex_utils.in_mathzone }
),

s({trig='RR', dscr='real numbers', priority=100, snippetType='autosnippet'},
    t("\\R"),
    { condition = tex_utils.in_mathzone }
),

s({trig='QQ', dscr='rational numbers', priority=100, snippetType='autosnippet'},
    t("\\Q"),
    { condition = tex_utils.in_mathzone }
),

s({trig='ZZ', dscr='positive integers', priority=100, snippetType='autosnippet'},
    t("\\Z"),
    { condition = tex_utils.in_mathzone }
),

s({trig='<!', dscr='normal', priority=100, snippetType='autosnippet'},
    t("\\triangleleft"),
    { condition = tex_utils.in_mathzone }
),

s({trig='<>', dscr='hokje', priority=100, snippetType='autosnippet'},
    t("\\diamond"),
    { condition = tex_utils.in_mathzone }
),

s({trig='tt', dscr='text', snippetType='autosnippet'},
    fmta(
        [[ \text{<>} <> ]],
        {
            i(1),
            i(0),
        }
    ),
    { condition = tex_utils.in_mathzone }
),

s({trig='case', dscr='cases', snippetType='autosnippet'},
    fmta(
        [[ 
            \begin{cases}
                <>
            \end{cases}
        ]],
        {
            i(1),
        }
    ),
    { condition = tex_utils.in_mathzone }
),

s({trig='cvec', dscr='column vector', snippetType='autosnippet'},
    fmta(
        [[ 
            \begin{pmatrix}
                <>_<>\\\\ \vdots\\\\ <>_<>
            \end{pmatrix}
        ]],
        {
            i(1, 'x'),
            i(2, '1'),
            rep(1),
            rep(2),
        }
    ),
    { condition = tex_utils.in_mathzone }
),

s({trig='bar', dscr='bar', priority=10, snippetType='autosnippet'},
    fmta(
        [[ \overline{<>}<> ]],
        {
            i(1),
            i(0),
        }
    ),
    { condition = tex_utils.in_mathzone }
),

s({trig='(%a)bar', dscr='bar', regTrig=true, wordTrig=false, priority=100, snippetType='autosnippet'},
    fmta(
        [[ \overline{<>} ]],
        {
            f( function(_, snip) return snip.captures[1] end ),
        }
    ),
    { condition = tex_utils.in_mathzone }
),

s({trig='hat', dscr='hat', priority=10, snippetType='autosnippet'},
    fmta(
        [[ \hat{<>}<> ]],
        {
            i(1),
            i(0),
        }
    ),
    { condition = tex_utils.in_mathzone }
),

s({trig='(%a)hat', dscr='hat', regTrig=true, wordTrig=false, priority=100, snippetType='autosnippet'},
    fmta(
        [[ \hat{<>} ]],
        {
            f( function(_, snip) return snip.captures[1] end ),
        }
    ),
    { condition = tex_utils.in_mathzone }
),


}
