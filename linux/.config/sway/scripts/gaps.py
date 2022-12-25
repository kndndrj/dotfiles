#!/usr/bin/python3

import getopt
import sys
import os
import signal

from i3ipc import Connection, Event  # https://github.com/acrisci/i3ipc-python
from screeninfo import get_monitors


class LayoutManager:
    def __init__(self, **kwargs):
        # Diagonals cache
        self.__diagonals = {}
        self.sway = Connection()
        self.config = {}
        self.config["default_gaps_cmd"] = (
            kwargs["default_gaps_cmd"] or "gaps outer current set 10"
        )
        self.config["large_gaps_cmd"] = (
            kwargs["large_gaps_cmd"] or "gaps outer current set 80"
        )
        self.config["screen_size_limit"] = kwargs["screen_size_limit"] or 16.0
        self.config["disabled_workspaces"] = kwargs["disabled_workspaces"] or []
        self.config["window_number_limit"] = kwargs["window_number_limit"] or 1

    # update global map of outputs with monitor sizes
    def __get_diagonal(self, output_name):

        # Only refresh the diagonals map
        if output_name not in self.__diagonals:
            outputs = self.sway.get_outputs()
            sizes = get_monitors()
            # Match properties from sway and from screeninfo
            # and update the map with sizes
            for o in outputs:
                o_match = (
                    str(o.rect.x)
                    + str(o.rect.y)
                    + str(o.rect.width)
                    + str(o.rect.height)
                )
                for s in sizes:
                    s_match = str(s.x) + str(s.y) + str(s.width) + str(s.height)
                    if s_match == o_match:
                        self.__diagonals[o.name] = round(
                            (s.width_mm**2 + s.height_mm**2) ** 0.5 / 25.4, 1
                        )

        return self.__diagonals[output_name]

    def __default_gaps(self):
        self.sway.command(self.config["default_gaps_cmd"])

    def __large_gaps(self):
        self.sway.command(self.config["large_gaps_cmd"])

    def __find_all_nodes(self, nodes):
        for n in nodes:
            if len(n.nodes) == 0:
                yield n.id
            else:
                for id_val in self.__find_all_nodes(n.nodes):
                    yield id_val

    def __handle_gaps(self, con, _):

        focused = con.get_tree().find_focused()
        workspace = focused.workspace()
        monitor = workspace.ipc_data["output"]

        # Don't do anything disabled workspaces
        if workspace.num in self.config["disabled_workspaces"]:
            self.__default_gaps()
            return

        # Don't do anything for smaller screens
        diagonal_inches = self.__get_diagonal(monitor)
        if diagonal_inches < self.config["screen_size_limit"]:
            self.__default_gaps()
            return

        # Default gaps if there is more than one tiled node
        # tiled_nodes = [val for val in workspace.nodes if "floating" not in val]
        num_of_windows = len(list(self.__find_all_nodes(workspace.nodes)))
        if num_of_windows > self.config["window_number_limit"]:
            self.__default_gaps()
            return

        # Center the window if it's the only one present
        self.__large_gaps()

    def __handle_binding(self, con, e):
        command = e.binding.command
        if "gaps:" not in command:
            return

        current_workspace_num = con.get_tree().find_focused().workspace().num

        if "disable_current" in command:
            if current_workspace_num not in self.config["disabled_workspaces"]:
                self.config["disabled_workspaces"].append(current_workspace_num)
        elif "enable_current" in command:
            if current_workspace_num in self.config["disabled_workspaces"]:
                self.config["disabled_workspaces"].remove(current_workspace_num)
        elif "toggle_current" in command:
            if current_workspace_num not in self.config["disabled_workspaces"]:
                self.config["disabled_workspaces"].append(current_workspace_num)
            else:
                self.config["disabled_workspaces"].remove(current_workspace_num)

        # Apply configs
        self.__handle_gaps(con, None)

    def run(self):
        # Subscribe to all events
        self.sway.on(Event.WINDOW_NEW, self.__handle_gaps)
        self.sway.on(Event.WINDOW_CLOSE, self.__handle_gaps)
        self.sway.on(Event.WINDOW_MOVE, self.__handle_gaps)
        self.sway.on(Event.WINDOW_FOCUS, self.__handle_gaps)
        self.sway.on(Event.WORKSPACE_EMPTY, self.__handle_gaps)
        self.sway.on(Event.WORKSPACE_INIT, self.__handle_gaps)
        self.sway.on(Event.BINDING, self.__handle_binding)
        # Entry
        self.sway.main()


def main():
    default_gaps_cmd = None
    large_gaps_cmd = None
    screen_size_limit = None
    disabled_workspaces = None
    window_number_limit = None

    try:
        opts, args = getopt.getopt(
            sys.argv[1:],
            "d:l:s:w:",
            [
                "default_gaps_cmd=",
                "large_gaps_cmd=",
                "screen_size_limit=",
                "disabled_workspaces=",
                "window_number_limit=",
            ],
        )
    except getopt.GetoptError as err:
        print("Error: ", err)
        sys.exit(2)
    for opt, arg in opts:
        if opt in ("-d", "--default_gaps_cmd"):
            default_gaps_cmd = str(arg)
        elif opt in ("-l", "--large_gaps_cmd"):
            large_gaps_cmd = str(arg)
        elif opt in ("-s", "--screen_size_limit"):
            screen_size_limit = float(arg)
        elif opt in ("-w", "--disabled_workspaces"):
            disabled_workspaces = list(map(int, arg.split(",")))
        elif opt in ("--window_number_limit"):
            window_number_limit = int(arg)

    lm = LayoutManager(
        default_gaps_cmd=default_gaps_cmd,
        large_gaps_cmd=large_gaps_cmd,
        screen_size_limit=screen_size_limit,
        disabled_workspaces=disabled_workspaces,
        window_number_limit=window_number_limit,
    )
    lm.run()


if __name__ == "__main__":
    pid = str(os.getpid())
    pidfile = "/tmp/sway_gaps.pid"

    if os.path.isfile(pidfile):
        print(f"{pidfile} already exists, exiting")
        sys.exit()

    with open(pidfile, 'w', encoding='utf-8') as f:
        f.write(pid)

    def graceful_shutdown(_signo, _stack_frame):
        sys.exit(2)

    signal.signal(signal.SIGTERM, graceful_shutdown)
    signal.signal(signal.SIGINT, graceful_shutdown)

    try:
        main()
    finally:
        os.unlink(pidfile)
