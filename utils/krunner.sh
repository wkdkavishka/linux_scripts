#!/bin/bash
# Remove the key mapping from the Application Launcher.
kwriteconfig5 --file kwinrc --group ModifierOnlyShortcuts --key Meta ""
# Open KRunner instead.
kwriteconfig5 --file kwinrc --group ModifierOnlyShortcuts --key Meta "org.kde.krunner,/App,,toggleDisplay"


killall plasmashell&&kstart5 plasmashell
