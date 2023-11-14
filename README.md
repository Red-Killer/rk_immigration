# Immigration System

## Description
This resource adds an immigration system to your FiveM server. Players can interact with an NPC to call an admin and request permits. Admins can manage permits and player states.

## Installation
1. Download the repository.
2. Place the `rk_immigration` folder into your server's resources directory.
3. Add `start rk_immigration` to your server.cfg file.

## Requirements
- [es_extended](https://github.com/esx-framework/es_extended)
- [mysql-async](https://github.com/brouznouf/fivem-mysql-async)
- [ox_lib](https://github.com/oxDeparo/ox_lib)

## Usage
1. Interact with the NPC to call an admin.
2. Admins can manage permits and player states through the provided commands.

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
For issues or questions, visit the [GitHub repository](https://github.com/Red-Killer/immigration-system).
