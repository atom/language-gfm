describe "GitHub Flavored Markdown grammar", ->
  grammar = null

  beforeEach ->
    waitsForPromise ->
      atom.packages.activatePackage("language-gfm")

    runs ->
      grammar = atom.syntax.grammarForScopeName("source.gfm")

  it "parses the grammar", ->
    expect(grammar).toBeDefined()
    expect(grammar.scopeName).toBe "source.gfm"

  it "tokenizes horizontal rules", ->
    {tokens} = grammar.tokenizeLine("***")
    expect(tokens[0]).toEqual value: "***", scopes: ["source.gfm", "comment.hr.gfm"]

    {tokens} = grammar.tokenizeLine("---")
    expect(tokens[0]).toEqual value: "---", scopes: ["source.gfm", "comment.hr.gfm"]

  it "tokenizes ***bold italic*** text", ->
    {tokens} = grammar.tokenizeLine("this is ***bold italic*** text")
    expect(tokens[0]).toEqual value: "this is ", scopes: ["source.gfm"]
    expect(tokens[1]).toEqual value: "***bold italic***", scopes: ["source.gfm", "markup.bold.italic.gfm"]
    expect(tokens[2]).toEqual value: " text", scopes: ["source.gfm"]

  it "tokenizes ___bold italic__ text", ->
    {tokens} = grammar.tokenizeLine("this is ___bold italic___ text")
    expect(tokens[0]).toEqual value: "this is ", scopes: ["source.gfm"]
    expect(tokens[1]).toEqual value: "___bold italic___", scopes: ["source.gfm", "markup.bold.italic.gfm"]
    expect(tokens[2]).toEqual value: " text", scopes: ["source.gfm"]

  it "tokenizes **bold** text", ->
    {tokens} = grammar.tokenizeLine("this is **bold** text")
    expect(tokens[0]).toEqual value: "this is ", scopes: ["source.gfm"]
    expect(tokens[1]).toEqual value: "**bold**", scopes: ["source.gfm", "markup.bold.gfm"]
    expect(tokens[2]).toEqual value: " text", scopes: ["source.gfm"]

    {tokens} = grammar.tokenizeLine("not**bold**")
    expect(tokens[0]).toEqual value: "not**bold**", scopes: ["source.gfm"]

  it "tokenizes spaces", ->
    {tokens} = grammar.tokenizeLine(" ")
    expect(tokens[0]).toEqual value: " ", scopes: ["source.gfm"]

  it "tokenizes __bold__ text", ->
    {tokens} = grammar.tokenizeLine("____")
    expect(tokens[0]).toEqual value: "____", scopes: ["source.gfm"]

    {tokens} = grammar.tokenizeLine("this is __bold__ text")
    expect(tokens[0]).toEqual value: "this is ", scopes: ["source.gfm"]
    expect(tokens[1]).toEqual value: "__bold__", scopes: ["source.gfm", "markup.bold.gfm"]
    expect(tokens[2]).toEqual value: " text", scopes: ["source.gfm"]

    {tokens} = grammar.tokenizeLine("not__bold__")
    expect(tokens[0]).toEqual value: "not__bold__", scopes: ["source.gfm"]

  it "tokenizes *italic* text", ->
    {tokens} = grammar.tokenizeLine("**")
    expect(tokens[0]).toEqual value: "**", scopes: ["source.gfm"]

    {tokens} = grammar.tokenizeLine("this is *italic* text")
    expect(tokens[0]).toEqual value: "this is ", scopes: ["source.gfm"]
    expect(tokens[1]).toEqual value: "*italic*", scopes: ["source.gfm", "markup.italic.gfm"]
    expect(tokens[2]).toEqual value: " text", scopes: ["source.gfm"]

    {tokens} = grammar.tokenizeLine("not*italic*")
    expect(tokens[0]).toEqual value: "not*italic*", scopes: ["source.gfm"]

  it "tokenizes _italic_ text", ->
    {tokens} = grammar.tokenizeLine("__")
    expect(tokens[0]).toEqual value: "__", scopes: ["source.gfm"]

    {tokens} = grammar.tokenizeLine("this is _italic_ text")
    expect(tokens[0]).toEqual value: "this is ", scopes: ["source.gfm"]
    expect(tokens[1]).toEqual value: "_italic_", scopes: ["source.gfm", "markup.italic.gfm"]
    expect(tokens[2]).toEqual value: " text", scopes: ["source.gfm"]

    {tokens} = grammar.tokenizeLine("not_italic_")
    expect(tokens[0]).toEqual value: "not_italic_", scopes: ["source.gfm"]

  it "tokenizes headings", ->
    {tokens} = grammar.tokenizeLine("# Heading 1")
    expect(tokens[0]).toEqual value: "# ", scopes: ["source.gfm", "markup.heading.heading-1.gfm"]
    expect(tokens[1]).toEqual value: "Heading 1", scopes: ["source.gfm", "markup.heading.heading-1.gfm"]

    {tokens} = grammar.tokenizeLine("## Heading 2")
    expect(tokens[0]).toEqual value: "## ", scopes: ["source.gfm", "markup.heading.heading-2.gfm"]
    expect(tokens[1]).toEqual value: "Heading 2", scopes: ["source.gfm", "markup.heading.heading-2.gfm"]

    {tokens} = grammar.tokenizeLine("### Heading 3")
    expect(tokens[0]).toEqual value: "### ", scopes: ["source.gfm", "markup.heading.heading-3.gfm"]
    expect(tokens[1]).toEqual value: "Heading 3", scopes: ["source.gfm", "markup.heading.heading-3.gfm"]

    {tokens} = grammar.tokenizeLine("#### Heading 4")
    expect(tokens[0]).toEqual value: "#### ", scopes: ["source.gfm", "markup.heading.heading-4.gfm"]
    expect(tokens[1]).toEqual value: "Heading 4", scopes: ["source.gfm", "markup.heading.heading-4.gfm"]

    {tokens} = grammar.tokenizeLine("##### Heading 5")
    expect(tokens[0]).toEqual value: "##### ", scopes: ["source.gfm", "markup.heading.heading-5.gfm"]
    expect(tokens[1]).toEqual value: "Heading 5", scopes: ["source.gfm", "markup.heading.heading-5.gfm"]

    {tokens} = grammar.tokenizeLine("###### Heading 6")
    expect(tokens[0]).toEqual value: "###### ", scopes: ["source.gfm", "markup.heading.heading-6.gfm"]
    expect(tokens[1]).toEqual value: "Heading 6", scopes: ["source.gfm", "markup.heading.heading-6.gfm"]

  it "tokenzies matches inside of headers", ->
    {tokens} = grammar.tokenizeLine("# Heading :one:")
    expect(tokens[0]).toEqual value: "# ", scopes: ["source.gfm", "markup.heading.heading-1.gfm"]
    expect(tokens[1]).toEqual value: "Heading ", scopes: ["source.gfm", "markup.heading.heading-1.gfm"]
    expect(tokens[2]).toEqual value: ":", scopes: ["source.gfm", "markup.heading.heading-1.gfm", "string.emoji.gfm", "string.emoji.start.gfm"]
    expect(tokens[3]).toEqual value: "one", scopes: ["source.gfm", "markup.heading.heading-1.gfm", "string.emoji.gfm", "string.emoji.word.gfm"]
    expect(tokens[4]).toEqual value: ":", scopes: ["source.gfm", "markup.heading.heading-1.gfm", "string.emoji.gfm", "string.emoji.end.gfm"]

  it "tokenizies an :emoji:", ->
    {tokens} = grammar.tokenizeLine("this is :no_good:")
    expect(tokens[0]).toEqual value: "this is ", scopes: ["source.gfm"]
    expect(tokens[1]).toEqual value: ":", scopes: ["source.gfm", "string.emoji.gfm", "string.emoji.start.gfm"]
    expect(tokens[2]).toEqual value: "no_good", scopes: ["source.gfm", "string.emoji.gfm", "string.emoji.word.gfm"]
    expect(tokens[3]).toEqual value: ":", scopes: ["source.gfm", "string.emoji.gfm", "string.emoji.end.gfm"]

    {tokens} = grammar.tokenizeLine("this is :no good:")
    expect(tokens[0]).toEqual value: "this is :no good:", scopes: ["source.gfm"]

    {tokens} = grammar.tokenizeLine("http://localhost:8080")
    expect(tokens[0]).toEqual value: "http://localhost:8080", scopes: ["source.gfm"]

  it "tokenizes a ``` code block```", ->
    {tokens, ruleStack} = grammar.tokenizeLine("```mylanguage")
    expect(tokens[0]).toEqual value: "```mylanguage", scopes: ["source.gfm", "markup.raw.gfm", "support.gfm"]
    {tokens, ruleStack} = grammar.tokenizeLine("-> 'hello'", ruleStack)
    expect(tokens[0]).toEqual value: "-> 'hello'", scopes: ["source.gfm", "markup.raw.gfm"]
    {tokens} = grammar.tokenizeLine("```", ruleStack)
    expect(tokens[0]).toEqual value: "```", scopes: ["source.gfm", "markup.raw.gfm", "support.gfm"]

  it "tokenizes a ``` code block with a language ```", ->
    {tokens, ruleStack} = grammar.tokenizeLine("```  bash")
    expect(tokens[0]).toEqual value: "```  bash", scopes: ["source.gfm", "markup.code.shell.gfm",  "support.gfm"]

    {tokens, ruleStack} = grammar.tokenizeLine("```js  ")
    expect(tokens[0]).toEqual value: "```js  ", scopes: ["source.gfm", "markup.code.js.gfm",  "support.gfm"]

  it "tokenizes inline `code` blocks", ->
    {tokens} = grammar.tokenizeLine("`this` is `code`")
    expect(tokens[0]).toEqual value: "`this`", scopes: ["source.gfm", "markup.raw.gfm"]
    expect(tokens[1]).toEqual value: " is ", scopes: ["source.gfm"]
    expect(tokens[2]).toEqual value: "`code`", scopes: ["source.gfm", "markup.raw.gfm"]

  it "tokenizes [links](links)", ->
    {tokens} = grammar.tokenizeLine("please click [this link](website)")
    expect(tokens[0]).toEqual value: "please click ", scopes: ["source.gfm"]
    expect(tokens[1]).toEqual value: "[", scopes: ["source.gfm", "link"]
    expect(tokens[2]).toEqual value: "this link", scopes: ["source.gfm", "link", "entity.gfm"]
    expect(tokens[3]).toEqual value: "](", scopes: ["source.gfm", "link"]
    expect(tokens[4]).toEqual value: "website", scopes: ["source.gfm", "link", "markup.underline.link.gfm"]
    expect(tokens[5]).toEqual value: ")", scopes: ["source.gfm", "link"]

  it "tokenizes [links][links]", ->
    {tokens} = grammar.tokenizeLine("please click [this link][website]")
    expect(tokens[0]).toEqual value: "please click ", scopes: ["source.gfm"]
    expect(tokens[1]).toEqual value: "[", scopes: ["source.gfm", "link"]
    expect(tokens[2]).toEqual value: "this link", scopes: ["source.gfm", "link", "entity.gfm"]
    expect(tokens[3]).toEqual value: "][", scopes: ["source.gfm", "link"]
    expect(tokens[4]).toEqual value: "website", scopes: ["source.gfm", "link", "markup.underline.link.gfm"]
    expect(tokens[5]).toEqual value: "]", scopes: ["source.gfm", "link"]

  it "tokenizes [link]: footers", ->
    {tokens} = grammar.tokenizeLine("[aLink]: http://website")
    expect(tokens[0]).toEqual value: "[", scopes: ["source.gfm", "link"]
    expect(tokens[1]).toEqual value: "aLink", scopes: ["source.gfm", "link", "entity.gfm"]
    expect(tokens[2]).toEqual value: "]: ", scopes: ["source.gfm", "link"]
    expect(tokens[3]).toEqual value: "http://website", scopes: ["source.gfm", "link", "markup.underline.link.gfm"]

  it "tokenizes [link]: <footers>", ->
    {tokens} = grammar.tokenizeLine("[aLink]: <http://website>")
    expect(tokens[0]).toEqual value: "[", scopes: ["source.gfm", "link"]
    expect(tokens[1]).toEqual value: "aLink", scopes: ["source.gfm", "link", "entity.gfm"]
    expect(tokens[2]).toEqual value: "]: <", scopes: ["source.gfm", "link"]
    expect(tokens[3]).toEqual value: "http://website", scopes: ["source.gfm", "link", "markup.underline.link.gfm"]
    expect(tokens[4]).toEqual value: ">", scopes: ["source.gfm", "link"]

  it "tokenizes unordered lists", ->
    {tokens} = grammar.tokenizeLine("*Item 1")
    expect(tokens[0]).toEqual value: "*Item 1", scopes: ["source.gfm"]

    {tokens} = grammar.tokenizeLine("  * Item 1")
    expect(tokens[0]).toEqual value: "  ", scopes: ["source.gfm"]
    expect(tokens[1]).toEqual value: "*", scopes: ["source.gfm", "variable.unordered.list.gfm"]
    expect(tokens[2]).toEqual value: " ", scopes: ["source.gfm"]
    expect(tokens[3]).toEqual value: "Item 1", scopes: ["source.gfm"]

    {tokens} = grammar.tokenizeLine("  + Item 2")
    expect(tokens[0]).toEqual value: "  ", scopes: ["source.gfm"]
    expect(tokens[1]).toEqual value: "+", scopes: ["source.gfm", "variable.unordered.list.gfm"]
    expect(tokens[2]).toEqual value: " ", scopes: ["source.gfm"]
    expect(tokens[3]).toEqual value: "Item 2", scopes: ["source.gfm"]

    {tokens} = grammar.tokenizeLine("  - Item 3")
    expect(tokens[0]).toEqual value: "  ", scopes: ["source.gfm"]
    expect(tokens[1]).toEqual value: "-", scopes: ["source.gfm", "variable.unordered.list.gfm"]
    expect(tokens[2]).toEqual value: " ", scopes: ["source.gfm"]
    expect(tokens[3]).toEqual value: "Item 3", scopes: ["source.gfm"]

  it "tokenizes ordered lists", ->
    {tokens} = grammar.tokenizeLine("1.First Item")
    expect(tokens[0]).toEqual value: "1.First Item", scopes: ["source.gfm"]

    {tokens} = grammar.tokenizeLine("  1. First Item")
    expect(tokens[0]).toEqual value: "  ", scopes: ["source.gfm"]
    expect(tokens[1]).toEqual value: "1.", scopes: ["source.gfm", "variable.ordered.list.gfm"]
    expect(tokens[2]).toEqual value: " ", scopes: ["source.gfm"]
    expect(tokens[3]).toEqual value: "First Item", scopes: ["source.gfm"]

    {tokens} = grammar.tokenizeLine("  10. Tenth Item")
    expect(tokens[0]).toEqual value: "  ", scopes: ["source.gfm"]
    expect(tokens[1]).toEqual value: "10.", scopes: ["source.gfm", "variable.ordered.list.gfm"]
    expect(tokens[2]).toEqual value: " ", scopes: ["source.gfm"]
    expect(tokens[3]).toEqual value: "Tenth Item", scopes: ["source.gfm"]

    {tokens} = grammar.tokenizeLine("  111. Hundred and eleventh item")
    expect(tokens[0]).toEqual value: "  ", scopes: ["source.gfm"]
    expect(tokens[1]).toEqual value: "111.", scopes: ["source.gfm", "variable.ordered.list.gfm"]
    expect(tokens[2]).toEqual value: " ", scopes: ["source.gfm"]
    expect(tokens[3]).toEqual value: "Hundred and eleventh item", scopes: ["source.gfm"]

  it "tokenizes > quoted text", ->
    {tokens} = grammar.tokenizeLine("> Quotation")
    expect(tokens[0]).toEqual value: ">", scopes: ["source.gfm", "support.quote.gfm"]
    expect(tokens[1]).toEqual value: " Quotation", scopes: ["source.gfm", "comment.quote.gfm"]

  it "tokenizes HTML entities", ->
    {tokens} = grammar.tokenizeLine("&trade; &#8482;")
    expect(tokens[0]).toEqual value: "&", scopes: ["source.gfm", "constant.character.entity.gfm", "punctuation.definition.entity.gfm"]
    expect(tokens[1]).toEqual value: "trade", scopes: ["source.gfm", "constant.character.entity.gfm"]
    expect(tokens[2]).toEqual value: ";", scopes: ["source.gfm", "constant.character.entity.gfm", "punctuation.definition.entity.gfm"]

    expect(tokens[3]).toEqual value: " ", scopes: ["source.gfm"]

    expect(tokens[4]).toEqual value: "&", scopes: ["source.gfm", "constant.character.entity.gfm", "punctuation.definition.entity.gfm"]
    expect(tokens[5]).toEqual value: "#8482", scopes: ["source.gfm", "constant.character.entity.gfm"]
    expect(tokens[6]).toEqual value: ";", scopes: ["source.gfm", "constant.character.entity.gfm", "punctuation.definition.entity.gfm"]
