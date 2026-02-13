# corry-escort

A escort script that adds RP-esk functionality preventing it from being powerfull.

Feel free to star the repository and check out my portfolio and discord @ Discord: https://discord.gg/H7MVAeejPt & Portfolio: https://corry.io 
For support inquires please create a post in the support-forum channel on discord or create an issue here on Github.


### Video Preview
https://youtu.be/M0ULN0ho0lI

## Dependencies
1. ox_lib - https://github.com/overextended/ox_lib

## Installation

1. Clone or download this resource.
2. Place it in the server's resource directory.
3. Add the resource to your server config, if needed.
4. Make sure all dependencies are installed.

## Usage

### Exports
Export(s) can be used only on the Client side

**Client**
- `escortPlayer()`

### Example Usage

Utilizing Exports
```lua
exports['corry-escort']:escortPlayer()
```

### Contextual Example
```lua
RegisterCommand('Escort', function()
    exports['corry-escort']:escortPlayer()
end)

-- Sent from client
```

There are no proofs other than a distance check on the initial client function and a check to read of the player is escorting/being escorted already. Would be good to add other authentication to prevent exploiting.

## Credit

Credit to Ox Community Dev for creating ox_lib.
