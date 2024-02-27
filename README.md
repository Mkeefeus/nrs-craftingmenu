                    
.  . ,-.       ,-.  .         .           
|\ | |  )     (   ` |         | o         
| \| |-<  ---  `-.  |-  . . ,-| . ,-. ,-. 
|  | |  \     .   ) |   | | | | | | | `-. 
'  ' '  '      `-'  `-' `-` `-' ' `-' `-'
-----------------------------------------

# NR-CraftingMenu

This is a "all-in-one" crafting menu UI that can be infinately scaled simply by adding a new menu to a detailed configuration, making this your go-to crafting resource.

Check out the demo: https://mkeefeus.github.io/NRCM/

## INSTALLATION

1. Install ox_lib https://github.com/overextended/ox_lib.
2. Place this resource in your FiveM Server's resource folder.
3. Open the Config file in this resource's home directory.
4. Adjust the config accordingly, everything should be named appropriately.
   -- Key Points to Step 4: - Make sure the `Image Path` is set to your server's inventory image folder. This is set to QBCore by default. - You can recolor the entire application, you may use HEX or RGB. - Be sure to follow the `Crafting Locations` example to setup all of your menus. - Edit Lines `14` and `20` in the `fxmanifest.lua` to match the framework your using.

## CREDITS

Project Error - Typescript React Boilerplate  
Overextended - ox_lib  
QW-Scripts - QW-Crafting  
Mycroft Studios - ESX Support

## ISSUES & BUGS / FEATURE REQUEST

We will be maintaining all issues through our Discord. Please submit detailed reports on any issues you may encounter.  
https://discord.gg/TPBjecyr7n

## CUSTOM FRAMEWORKS

If you are using a custom framework, you will need to create your own client and server framework files. I recommend using the QBCore or ESX framework files as a template. Be sure to pay attention to the returns as some of them are returning data that needs to be used later. We recommend using ox_target as your target resource, but also support qb-target.
https://github.com/overextended/ox_target

You will also need to add your framework to the fxmanifest.lua file. If you need help, feel free to join our Discord and ask for assistance.

## EXAMPLE STORE

```lua
['example'] = {
	labels = {
		header = "Crafting Bench",
		costs = "Required Materials",
		crafting = "Items Made",
		submit = "Craft",
	},
	coords = vector3(-33.38, -1114.97, 26.0),
	emote = 'mechanic',
	-- OR
	-- scenario = 'WORLD_HUMAN_WELDING',
	-- OR
	-- animDict = "anim@amb@clubhouse@tutorial@bkr_tut_ig3@",
	-- anim = "machinic_loop_mechandplayer",
	-- animFlag = 16,
	-- job = 'mechanic', -- Can also use table like { ['mechanic'] = 0}
	-- gang = 'vagos', -- Can also use table like { ['vagos'] = 0}
	items = {
		{
			name = 'fixkit',
			label = 'fixkit',
			image = 'fixkit.png',
			-- craftedAmount = 2 -- use this is you want to yeild more than 1 item per craft
			requiredItems = {
				{
					name = 'water',
					label = 'water',
					image = 'water.png',
					amount = 3
				},
			}
		}
	}
}
```

## CONFGIURABLE STYLES

```lua
Config.Styles = {
	PrimaryColor = "#232833",
	SecondaryColor = "#374151",
	SecondaryColorHover = "4424e61",
	TextColor = "rgb(255, 255, 255)",
	InvalidTextColor = "#ff0000",
	SubmitColor = "#45d368",
	SubmitHoverColor = "#3ecf5f",
	SubmitTextColor = "#000000",
	CloseButtonColor = "#e74c3c",
	CloseButtonHoverColor = "#e43f2d"
}
```

## LOGGING EVENTS

Add or remove any of the following events to enable or disable logging for that event. You will also need to configure your frameworks Framework.Log function to your liking.

```lua
Config.Logs = {
    onOpen = true,
    onCraft = true,
    onCraftFail = true,
    onCraftCancel = true,
    onClose = true,
    onExploits = true
}
```

## CHANGELOG

Official Release - v1.0.0

Update README, add missing license for PE Boilerplate, remove private repo from fxmanifest - v1.0.1

Add logging events, update readme - v1.0.2

Fix job and gang support for qb-target - v1.0.3

added examples for scenario and anim to readme - v1.0.4

Fixed support for ESX and ox_inventory - v1.0.5

Add mulitple item crafting functionality - v1.1.0

Give all items at once for better durability support - v1.1.1

Fix an error with ox_inventory checks, update framework files to automatically select - v1.1.2

Fix an error with items not using the craftedAmount property - v1.1.3