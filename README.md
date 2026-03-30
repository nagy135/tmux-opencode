# tmux-opencode

Open a single [OpenCode](https://github.com/sst/opencode) window inside tmux and
reuse it across the current tmux session.

## Installation

### Manual installation

Clone this folder wherever you keep your tmux plugins, then add this line to
your `tmux.conf`:

```bash
run-shell <clone-path>/tmux-opencode.tmux
```

Reload tmux:

```bash
tmux source-file <tmux.conf-path>
```

## Behavior

Opening OpenCode reuses a single window per tmux session. The plugin stores the
tracked window id directly in tmux session memory using a session-scoped user
option. If that window already exists, it focuses it instead of creating a new
one.

## Configuration options

### `@open-opencode`

**Default: a (prefix+a)**

Key used to open OpenCode.

```bash
set -g @open-opencode 'a'
```

### `@opencode-window-position`

**Default: unset**

Preferred tmux window index for a newly created OpenCode window. If that index is
already occupied, the plugin uses the next free index. Leave it unset to keep the
default tmux placement behavior.

```bash
set -g @opencode-window-position '3'
```
