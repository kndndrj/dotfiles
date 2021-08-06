#!/bin/sh

cache_path="/tmp/"

icon_map=$( cat "$( dirname "$( readlink -f "$0" )" )/bspwm_window_titles_icon_map.txt" )

ignore_list="Left-Scratchpad Right-Scratchpad"

name_cut=15
total_cut=75
foreground_color="-"
background_color="#8bbaed"

# subscribe to events on which the window title list will get updated
bspc subscribe node_focus node_remove node_stack desktop_focus | while read -r _; do
    monitor=$(bspc query -M -d focused --names)
    # get windows from focused desktop on given monitor
    window_ids=$(bspc query -N -n .window -m .focused -d .active)
    window_focused_id=$(bspc query -N -n focused)

    for window_id in $window_ids; do
        window_name=$(xdotool getwindowname $window_id)

        if [ -z "$(echo "$ignore_list" | grep "$window_name")" ]; then
            window_class=$(xdotool getwindowclassname $window_id)
            # cut the window name
            window_name=$( echo "$window_name" | cut -c-"$name_cut" )
            # get icon for class name
            window_icon=$(echo "$icon_map" | grep "$window_class")
            # fallback icon if class not found
            if [ -z "$window_icon" ]; then
                window_icon=$(echo "$icon_map" | grep "Fallback")
            fi
            # color the active window differently and put it at the begining
            if [ "$window_id" = "$window_focused_id" ]; then
                curr_wins="%{F$foreground_color}%{B$background_color} ${window_icon#* } ${window_class} %{F-}%{B-}${curr_wins}"
            else
                curr_wins="${curr_wins} ${window_icon#* } ${window_class} "
            fi
        else
            num_of_windows=$((num_of_windows - 1))
        fi
    done
    [ -z "$curr_wins" ] && curr_wins="..."
    # print out the window names to files for use in a bar
    echo "$curr_wins" | cut -c-$total_cut > "${cache_path}/bspwm_windows.${monitor}"
    # Wake up polybar
    polybar-msg hook windowlist 1

    unset curr_wins
done
