---
title: Design
description: Design of care.nvim
author:
    - max397574
categories:
    - docs
---

# General

There is the [care.nvim](https://github.com/max397574/care.nvim) plugin. This is
the main module of the whole completion architecture. Then there are also
sources, which is where the core gets it's completions from.

## Care.nvim

This is the core of the autocompletion. From here the sources are used to get
completions which are then displayed in the [Completion Menu](#completion-menu)

### Completion Menu

The completion menu displays the current completions. Features that it should
have:

-   Completely customizable display for every entry (with **text-highlight
    chunks** like extmark-api)
-   Customizable scrollbar
-   Customizable window properties
    -   Border
    -   Max height
-   Docview
    -   Customizable
    -   Try to get nicely concealed like in core or noice.nvim
    -   Allow to send to e.g. quickfix or copy

# Terms

## Offset

Offset always describes the distance between e.g. the start of an entry from the
beginning of the line.

# Architecture

autocompletion:

1. `TextChangedI` or `CursorMovedI`
2. get the context (line before, cursor position etc)
3. Check if context changed
4. Check if character was a trigger character or completion was triggered
   manually
5. Depending on ^^ decide what to do _for every source_:
    - Get new completions
        1. get completions from source based on context
    - sort completions
        1. Use characters found with `keyword_pattern` to fuzzy match and sort
           completions
6. Collect all the completions
7. Open menu to display thing
    1. if there is a selected one:
        - highlight selected one
        - show preview of selected completion
        - show docs

When completing (e.g. `<cr>`):

1. check if menu is open
2. check if anything is selected (or autoselect option)
3. complete
    1. insert text
    2. additional text edits (check core functions)
    3. snippet expansion (core or luasnip)
4. close menu

# Motivation

## Nvim-cmp

These days nvim-cmp is the most popular completion-engine for neovim. There are
some mayor issues me and also other people in the community have with cmp.

### Bad code/Documentation

The code of nvim-cmp is often quite unreadable. Sometimes this might be due to
optimizations and surely some of it has just grown historically. Also there are
nearly no docs on how the whole completion engine works. The api for new sources
is quite unclear and far from optimal. While this doesn't really matter to a
user it definitely does to a potential contributor and developers of sources.

### Legacy code/features

There are a lot of things which grew just historically. The author of nvim-cmp
is (understandable to a certain degree) afraid of making breaking changes and
fixing them or just doesn't think changes are necessary.

#### Configuration of item display

One such example is the configuration of how items are displayed in the menu.
This works with a function `formatting` which takes a completion item and is
allowed to return an item where the three fields `menu`, `kind` and `abbr` and
three more fields for highlights for those can be set. So apart from the
background and border color of the menu you're limited to have three different
fields and colors in your menu E.g. source name, kind name, kind icon and text
isn't possible. It's also not possible to have round or half blocks around icons
because you don't have enough colors. An example of an issue can be found
[here](https://github.com/hrsh7th/nvim-cmp/issues/1599). You also can't add
padding wherever you want and you can't align the fields as you want.

#### Legacy code

There is e.g. the whole "native menu" thing laying around in the codebase.
Nowadays this isn't really needed anymore. Everything of it can be accomplished
with the "custom menu". There is a lot of duplicate code because of that.

### Mapping system

The mapping system is quite confusing. It's a table in the config with keys to
be mapped as keys and a call to `cmp.mapping()` with a callback to the actual
functionality as value. Users should able to just use normal mappings or
functions with `vim.keymap.set`.

### Custom solutions for builtin functionality

An example for this is the [Mapping system](#mapping-system). Another example
would be the `cmp.event.on` which could just be done with User autocmds.

### Why not contribute?

The maintainer is in general quite conservative. There were pull-requests for
many features open which were liked by the community (seen by reactions and
comments). But they were abandoned because the maintainer saw no reason to add
it. There was for example a pull-request to fix the issue with the limited
fields in the configuration
[here](https://github.com/hrsh7th/nvim-cmp/pull/1238). This pull request was
closed because _No specific use cases have emerged at this stage._ according to
the author. Even though there was clearly a problem described and what the pr
would allow (this pr allowed custom fields which still isn't nice but fixed the
obvious problems). There were also some features (in particular the custom
scrollbars) removed because there were some issues with it which apparently
weren't worth fixing for the feature. So it's not really motivating to try to
contribute new things. It's also quite hard because of the messy code with lots
of legacy code.

# Goals

## Use nvim-cmp sources

We should be able to use nvim-cmp sources. This should be possible by adding a
`package.loaders` where we can redirect calls to `cmp.register_source` (which
happens in most sources auto- matically) to our own plugin. We **don't want to
adapt to cmp's apis** for this though. We won't extend our own formats e.g. for
entries or sources to match cmps. Even when it's complicated we will just
convert between the different formats.

## Native things

Use as many native things as possible. This includes setting mappings with
`vim.keymap.set` or add events as user autocmd events.

# Non-Goals

## Different views

Nvim-cmp has different views. At the moment wild-menu, native menu and custom
menu. There is a lot of code duplication because of this. We'd like to avoid
having multiple views. The native one isn't needed anyway (it likely is just in
cmp for historical reasons). In the future we'd like to allow injecting custom
views via config where you just get the entries and do things with them
yourself. This is mostly to avoid code duplication in core.

## Commandline completion

At the moment no command line completion is planned. This is because the author
thinks it's not really needed because builtin completion is already quite good
and there is little value added by adding commandline completion. Also it
doesn't really make sense in my opinion to combine commandline completion and
autocompletion for buffer contents in the same plugin. Especially if you try to
share things in between like nvim-cmp does.

# Types used

The types should minimally be the lsp things (for the context passed to source,
for response and for entries). Everything additionally is mostly optional.
