# Month Calendar

Desktop widget for **KDE Plasma 6**: a calendar of the current month with a marker on today's date.

## Features

- Calendar of the current month, refreshed automatically at midnight
- Choice of today's marker: filled circle, rounded square, underline or ring
- Text, marker and background colors: system theme or custom color
- Font size, bold for today's date
- Text alignment inside the cells, including "edge to edge" for no spacing at all
- Background with adjustable opacity, rounded corners and wallpaper blur
- "Fill the widget" mode, or fixed size with alignment and offset
- Follows the system language (month and day names, first day of the week)

## Requirements

- KDE Plasma 6.0 or newer
- `kpackagetool6` (ships with Plasma)
- For development: `plasma-sdk` (provides `plasmoidviewer`)

## Installation

```sh
git clone git@github.com:mmaheriniaina00/com.mmaheriniaina.calendar.git
cd com.mmaheriniaina.calendar
make install
```

Then right-click the desktop → **Add Widgets** → **Month Calendar**.

If the widget does not show up in the list, restart Plasma with `make reload`.

### From a `.plasmoid` file

```sh
kpackagetool6 --type Plasma/Applet --install com.mmaheriniaina.calendar.plasmoid
```

To build that file:

```sh
cd package
zip -r ../com.mmaheriniaina.calendar.plasmoid .
```

## Configuration

Right-click the widget → **Configure**. Three pages (the interface is currently in French):

| Page | Settings |
| --- | --- |
| **Style** | today's marker shape, colors, font size, bold, text alignment |
| **Arrière-plan** (Background) | color, opacity, corner radius, blur |
| **Taille et position** (Size and position) | fill the widget or fixed size, inner padding, alignment, offset |

For a calendar with no spacing at all on the edges: set the inner padding to 0, check "Remplir tout le widget" (fill the whole widget) and set the text alignment to "Aux bords" (edge to edge).

The blur applies to the desktop wallpaper behind the widget, not to windows. It does not show in `plasmoidviewer`. The widget's own position and size on the desktop are set with Plasma's edit mode.

## Development

```sh
make run        # test in plasmoidviewer
make upgrade    # reinstall after a change
make reload     # restart plasmashell
make uninstall  # uninstall
```

See [CLAUDE.md](CLAUDE.md) for the project structure and conventions (written in French).

## License

This project is licensed under the [PolyForm Noncommercial License 1.0.0](LICENSE).

- **Allowed**: personal use, study, modification and sharing for **noncommercial** purposes, as long as the license and the `Required Notice` line from the `LICENSE` file are kept.
- **Not allowed**: any commercial use (selling it, including it in a paid product or service, etc.).

The software is provided "as is", without warranty of any kind. The author is not liable for any damages arising from its use, nor for what third parties do with copies, forks or modified versions of the project.

This is not an "open source" license as defined by the OSI, because it excludes commercial use.
