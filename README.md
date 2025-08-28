# DiscordScreen

A FiveM resource that allows admins to request player screenshots and sends detailed player info to a Discord webhook.  
**Note:** This script is in its early stages and may change at any time. Features may be added, removed, or optimized as development continues.

---

## To-Do List
- Refactor Webhook Logic For Security

## Features

- **Admin Screenshot Command:**  
  Use `/screen [playerId] [reason]` to request a screenshot from a specific player or all players.
- **Discord Webhook Integration:**  
  Sends screenshots and detailed player info (identifiers, health, armor, location, vehicle, etc.) to your Discord server.
- **Cooldown System:**  
  Prevents screenshot spam by enforcing a configurable cooldown per player.
- **Easy Configuration:**  
  All settings are managed in a single `config.lua` file.
- **Vehicle & Player Info:**  
  Captures vehicle details, coordinates, and more for context.
- **Modular & Open Source:**  
  MIT licensed and ready for community contributions.

---

## Installation

1. **Download or Clone the Repository**
   ```sh
   git clone https://github.com/officialsnaily/DiscordScreen.git
   ```

2. **Add to Your Server Resources**
   Place the `DiscordScreen` folder in your server's `resources` directory.

3. **Configure the Script**
   - Open `config.lua` and set your Discord webhook URL:
     ```lua
     Config.DISCORD_WEBHOOK = "https://discord.com/api/webhooks/....."
     ```
   - Adjust other settings as needed (embed title, cooldown, etc.).

4. **Ensure Dependency**
   - This script requires [screenshot-basic](https://github.com/citizenfx/screenshot-basic).  
     Make sure it is installed and started before this resource.

5. **Add to server.cfg**
   ```
   ensure screenshot-basic
   ensure DiscordScreen
   ```

---

## Usage

- **Command:**  
  `/screen [playerId] [reason]`
  - `playerId`: The server ID of the player to screenshot. Use `-1` to screenshot all players.
  - `reason`: (Optional) Reason for the screenshot, included in the Discord embed.

- **Permissions:**  
  The command requires the `command.screen` ace permission.

---

## Configuration

Edit `config.lua` to change webhook, embed title, and cooldown:

```lua
Config = {}

-- Discord webhook URL
Config.DISCORD_WEBHOOK = "https://discord.com/api/webhooks/your_webhook_url"

-- Title for the Discord embed
Config.EMBED_TITLE = "Player Screenshot"

-- Cooldown in seconds between screenshots per player
Config.SCREENSHOT_COOLDOWN = 10
```

---

## File Structure

- `fxmanifest.lua` – Resource manifest
- `config.lua` – Configuration file
- `server.lua` – Server-side logic (commands, Discord integration)
- `client.lua` – Client-side logic (gathering info, taking screenshots)

---

## Roadmap & Notice

> **This script is in its early stages.**  
> Functionality, structure, and performance may change at any time.  
> Features may be added, removed, or optimized as development continues.  
> Contributions and suggestions are welcome!

---

## License

MIT License

---

## Credits

- [Team Snaily](https://snai.ly/team) & [Anton's Workshop](https://discord.gg/hdjbqaazhg) – Original authors
- [screenshot-basic](https://github.com/citizenfx/screenshot-basic) – Screenshot utility

---

## Contributing

Pull requests and issues are welcome! Please open an issue to discuss any major changes before submitting a PR.





> **Tested:** This script has been tested on our live server with 30+ players.

