#!/bin/sh

# Function to show a pop-up message requiring manual dismissal
show_popup() {
  osascript <<EOF
    tell application "System Events"
        display dialog "$1" with title "Faster Than Light" buttons {"OK"} default button "OK"
    end tell
EOF
}

# Function to show a macOS notification
show_notification() {
  osascript -e "display notification \"$1\" with title \"Faster Than Light\""
}

# Function to display a dialog box and capture user selection
show_menu() {
  osascript <<EOF
    tell application "System Events"
        set userChoice to button returned of (display dialog "What would you like to do?" with title "Faster Than Light" buttons {"Disable Lightspeed", "Enable Lightspeed", "Exit"} default button "Disable Lightspeed")
    end tell
    return userChoice
EOF
}

# Show the main menu and capture the response
response=$(show_menu)

# Handle user selection
case $response in
  "Disable Lightspeed")
    show_notification "Disabling Lightspeed services..."
    /Applications/Lightspeed\ Agent.app/Contents/MacOS/Lightspeed\ Agent -h
    sleep 2
    show_notification "Stopping Lightspeed services..."
    launchctl unload /Library/LaunchDaemons/com.lightspeedsystems.*
    sleep 2
    show_popup "🔔✓ Lightspeed has been successfully disabled."
    ;;
  "Enable Lightspeed")
    show_notification "Starting Lightspeed services..."
    /Applications/Lightspeed\ Agent.app/Contents/MacOS/Lightspeed\ Agent & agent_pid="$!"
    sleep 3
    show_notification "Configuring Lightspeed services..."
    kill -9 $agent_pid
    launchctl start /Library/LaunchDaemons/com.lightspeedsystems.*
    sleep 2
    show_popup "🔔✓ Lightspeed has been enabled. Please restart for full effect."
    ;;
  "Exit")
    show_notification "Exiting program..."
    show_popup "Exiting program. No changes made."
    exit 0
    ;;
  *)
    show_notification "Invalid option selected. Exiting."
    exit 1
    ;;
esac
