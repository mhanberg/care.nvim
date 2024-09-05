--- The API for care. This should be used for most interactions with the plugins.
--- The api can be accessed with the following code
---
--- ```lua
--- local care_api = require("care").api
--- ```
---@class care.api
--- This function returns a boolean which indicates whether the
--- completion menu is currently open or not. This is especially useful for mappings
--- which should fallback to other actions if the menu isn't open.
---@field is_open fun(): boolean
--- Used to confirm the currently selected entry. Note that
--- there is also `<Plug>(CareConfirm)` which should preferably be used in mappings.
---@field confirm fun(): nil
--- This function is used to manually trigger completion
---@field complete fun(): nil
--- Closes the completion menu and documentation view if it is open.
--- For mappings `<Plug>(CareClose)` should be used.
---@field close fun(): nil
--- Select next entry in completion menu. If count is provided the selection
--- will move down `count` entries.
--- For mappings `<Plug>(CareSelectNext)` can be used where count defaults to 1.
---@field select_next fun(count: integer): nil
--- Select next entry in completion menu. If count is provided the selection
--- will move up `count` entries.
--- For mappings `<Plug>(CareSelectPrev)` can be used where count defaults to 1.
---@field select_prev fun(count: integer): nil
--- Indicates whether there is a documentation window open or not.
--- This is especially useful together with the
--- function to scroll docs to only trigger the mapping in certain cases.
--- 
--- ```lua
--- if require("care").api.doc_is_open() then
---     require("care").api.scroll_docs(4)
--- else
---     ...
--- end
--- ```
---@field doc_is_open fun(): boolean
--- Use `scroll_docs(delta)` to scroll docs by `delta` lines. When a negative
--- delta is provided the docs will be scrolled upwards.
---@field scroll_docs fun(delta: integer): nil
--- Allows the index which represents which entry is selected to be directly set.
--- This allows to jump anywhere in the completion menu.
---@field set_index fun(index: integer): nil
--- This function is used to select the entry at index `index` where `index`
--- indicates the visible position in the menu.
---
--- This is really useful to create shortcuts to certain entries like in the
--- [example in configuration recipes](/configuration_recipes#labels-and-shortcuts).
---@field select_visible fun(index: integer): nil
