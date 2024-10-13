---
title: Presets
description: Type description of care.presets
---

# Presets

In this module some presets for the format_entry function are available. They can be accessed like this
```lua
format_entry = function(entry, data)
    return require("care.presets").<preset_name>(entry, data)
end
```
You could also just use the shorter form
```lua
format_entry = require("care.presets").<preset_name>
```
# `care.presets`

# Methods

## Default
`presets.Default`
The default preset. Just includes the label and a simple icon.
![image](https://github.com/user-attachments/assets/962a3bc3-72d8-413b-9b02-90e43e7bced8)

## Atom
`presets.Atom`
The atom preset is an atom-like configuration. It displays the kind icon with a blended colored background and
the label.
![image](https://github.com/user-attachments/assets/cb653979-ca57-49c8-ae23-510be1496a5c)