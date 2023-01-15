-- Place this in ${HOME}/.config/nvim/LuaSnip/all.lua
return {
  -- A snippet that expands the trigger "hi" into the string "Hello, world!".
  require("luasnip").snippet(
    { trig = "hi" },
    { t("Hello, world!") }
  ),

  -- To return multiple snippets, use one `return` statement per snippet file
  -- and return a table of Lua snippets.
  require("luasnip").snippet(
    { trig = "foo" },
    { t("Another snippet.") }
  ),

  s({trig="snip", dscr="a generic snippet"},
    fmta(
        [[
            s({trig="<>", dscr="<>"<>},
                {
                    t("<>")
                }
            ),<>
        ]],
        {
            i(1),
            i(2),
            i(3, ", snippetType=\"autosnippet\""),
            i(4),
            i(0),
        }
    )
),

  s({trig="snip_inp", dscr="a generic snippet template"},
    fmta(
        [[
            s({trig="<>", dscr="<>"<>},
                fmta(
                    [[
                        <>
                    <>,
                    {
                        <>
                    }<>
                )
            ),<>
        ]],
        {
            i(1),
            i(2),
            i(3, ", snippetType=\"autosnippet\""),
            i(4, "]]"),
            i(5),
            i(6),
            i(7),
            i(0),
        }
    )
),
}

