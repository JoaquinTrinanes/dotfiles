---@meta
---@class SpawnCommand
---@field label string? 
-- An optional label.
-- The label is only used for SpawnCommands that are listed in
-- the `launch_menu` configuration section.
-- If the label is omitted, a default will be produced based
-- on the `args` field.
---@field args string[]?
-- The argument array specifying the command and its arguments.
-- If omitted, the default program for the target domain will be
-- spawned.
---@field cwd string?
-- The current working directory to set for the command.
-- If omitted, wezterm will infer a value based on the active pane
-- at the time this action is triggered.  If the active pane
-- matches the domain specified in this `SpawnCommand` instance
-- then the current working directory of the active pane will be
-- used.
-- If the current working directory cannot be inferred then it
-- will typically fall back to using the home directory of
-- the current user.
---@field set_environment_variables { [string]: string }?
-- Sets addditional environment variables in the environment for
-- this command invocation.
---@field domain { DomainName: string }
-- Specify a named multiplexer domain that should be used to spawn
-- this new command.
-- This is useful if you want to assign a hotkey to always start
-- a process in a remote multiplexer rather than based on the
-- current pane.
-- See the Multiplexing section of the docs for more on this topic.
---@field position { x: number, y: number, origin: "ScreenCoordinateSystem" | "MainScreen" | "ActiveScreen" | { Named: string } | nil }?
-- Since: 20230320-124340-559cb7b0
-- Specify the initial position for a GUI window when this command
-- is used in a context that will create a new window, such as with
-- wezterm.mux.spawn_window, SpawnCommandInNewWindow