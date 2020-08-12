![Liro Banner](https://i.imgur.com/ZkyspAI.png)

![Liro Pull Requests](https://img.shields.io/github/issues-pr/Alydus/liro.svg)
![Liro Issues](https://img.shields.io/github/issues/Alydus/liro.svg)
![Liro Release Version](https://img.shields.io/badge/release-v2.0-blue.svg)
![Liro Upcoming Version](https://img.shields.io/badge/upcoming%20release-v2.1-blue.svg)
![Liro License](https://img.shields.io/badge/license-MIT-green.svg)

![Github Fork](https://img.shields.io/github/forks/Alydus/liro.svg?style=social)
![Github Stars](https://img.shields.io/github/stars/Alydus/liro.svg?style=social)

# What is Liro?
Liro is a modular Garry's Mod gamemode base. It has been designed from the ground up for code reusability and ease of use.

# Features
- A optimized recursive module loader and clean output load logs
- Global functions that can be reused from the Liro base files
- Module loading prioities, making code load earlier than other modules in order to best customise the loading of your gamemode
- No messing about with include() and AddCSLuaFile()
- Example module to help developers get started
- Configurable file prefixes (per module & global) for running files in different enviroments (e.g. sh_, sv_, cl_)
- Ability to disable/enable modules in the base config. (gamemode/liro/config.lua)
- Handling of registering network strings per module
- Modules able to be easily distributed
- Micro-optimised from the ground up, and full support for Lua Autorefresh in the entire gamemode, tested on both Windows & Linux environments

# Getting Started
Liro is designed to be renamed, not derived (this would be pointless), similar to how you'd rename DarkRP to StarwarsRP.
- Firstly, rename the gamemode folder to whatever you would like, e.g. 'darkrp, starwarsrp', this should be lowercase only for best practice
- Rename the liro.txt in the gamemode folder to the folder name you have chosen, and change this gamemode information to be accurate for your project
- Checkout the 'examplemodule' folder in /modules to learn how to get started. Each module requires a registermodule.lua file, the rest of the module is entirely up to you. Create as many folders, as deep as you wish, in as many different loading environments as you require, and place them into the module. Experiment with putting your gamemode into different modules and changing loading priorities in order to make your gamemode more modular and easily re-usable.
- Good luck!

# Contributing to Liro
At this current time, there is no formal contributing guidelines, however if you keep the code style consistent with the rest of the code, and use general best practice, there should be no issues. Please keep performance in mind when working on Liro, this is designed to be a light base that supports reloading of its core files very often through things like Lua Autorefresh.
