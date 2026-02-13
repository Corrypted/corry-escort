config = {}

config.maxDistance = 1.0

config.keybind = {
    useKeybind = true, -- Set to true if you want to use a keybind
    key = 'H', -- The key to press for escorting
}

config.command ={
    useCommand = true, -- Set to true if you want to use a command
    commandName = 'escort1', -- The command to type for escorting
}

config.prevent = { -- Enabling any of these will immediately stop the escort if the escorted player does any of these actions
    vehicle = true, -- Prevent players from entering vehicles while escorting
    running = true, -- Prevent players from running while while escorting
    ragdoll = true, -- Prevent players from ragdolling while escorting
}