# Immigration System

## Description
This resource adds an immigration system to your FiveM server. Players can interact with an NPC to call an admin and request permits. Admins can manage permits and player states.

## Features
- **NPC Interaction**: Players can call an admin NPC for assistance.
- **Permit System**: Admins can manage permits for players.
- **Discord Integration**: Admin calls and system logs can be sent to Discord.
- **Customizable Configuration**: Adjust parameters in `fxmanifest.lua` and `config.lua`.
- **Anti-Escape Mechanism**: Players attempting to escape certain areas will be teleported back.
- **Other Dimension Handling**: Admins can handle player locations in other dimensions.

## Screenshots


## Installation
1. Download the repository.
2. Place the `rk_immigration` folder into your server's resources directory.
3. Run the `esx.sql` in your database.
4. Add `start rk_immigration` to your server.cfg file.

## Requirements
- [es_extended](https://github.com/esx-framework/es_extended)
- [oxmysql](https://github.com/overextended/oxmysql)
- [ox_lib](https://github.com/oxDeparo/ox_lib)

## Configuration
- `fxmanifest.lua` contains the main configuration.
- Adjust `config.lua` to customize system parameters.
- Edit Discord webhook settings in `fxmanifest.lua` for admin calls and logs.

## Commands
- `/permitmenu`: Opens the permit menu.

## Discord Integration
- Admin calls and system logs are sent to Discord if enabled.

## Credits
- **Author**: Red Killer
- **Version**: 1.0.0

## Support
For issues or questions, visit the [Issues Page](https://github.com/Red-Killer/rk_immigration/issues).
