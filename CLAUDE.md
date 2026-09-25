# Month Calendar

KDE Plasma 6 plasmoid (widget bureau). Affiche calendrier du mois courant, cercle sur la date du jour (rafraîchi à minuit). Pas de navigation. QML pur, pas de C++.

Nom affiché: "Month Calendar". Dossier = Id du plugin (renommé depuis `year-calendar`).

- Plugin ID: `com.mmaheriniaina.calendar`
- Plasma API min: 6.0 (Qt 6, `org.kde.kirigami`, `org.kde.plasma.plasmoid`)
- OS dev: Arch Linux, shell fish

## Structure

```
package/                        # racine du plasmoid (ce que kpackagetool6 installe)
├── metadata.json               # KPlugin id, nom, version, KPackageStructure=Plasma/Applet
└── contents/
    ├── config/
    │   ├── main.xml            # schéma kcfg: toutes les options (défauts inclus)
    │   └── config.qml          # ConfigModel: 3 pages (Style, Arrière-plan, Taille et position)
    └── ui/
        ├── main.qml            # PlasmoidItem, fond + flou + calendrier
        ├── configAppearance.qml
        ├── configBackground.qml
        └── configLayout.qml
Makefile                        # raccourcis dev
```

## Configuration

Chaque option: entrée dans `main.xml` + `property alias cfg_<nom>` dans la page de config + lecture via `Plasmoid.configuration.<nom>` (`root.cfg` dans main.qml). Ajouter une option = toucher ces 3 endroits.

- Style: marque du jour (cercle/carré/soulignement/anneau), couleurs, taille police, gras, alignement du texte dans les cases (centré / aux bords / gauche / droite; "aux bords" = 1re colonne à gauche, dernière à droite → aucun espace).
- Arrière-plan: couleur, opacité, arrondi, flou. `backgroundHints = NoBackground`, le fond est dessiné par le widget.
- Taille/position: mode "remplir le widget" (défaut, calendrier étiré sur tout le widget moins la marge) ou taille fixe (cellSize) + alignement H/V, décalage. Positionne le calendrier DANS le widget. Position/taille du widget sur le bureau = mode édition Plasma.
- Flou: `ShaderEffectSource` sur le `wallpaper` du ContainmentItem (trouvé en remontant `parent`) + `MultiEffect`. Flou du fond d'écran seulement, pas des fenêtres. Inactif dans plasmoidviewer (pas de wallpaper).

## Commandes

```fish
make run        # test dans plasmoidviewer (paquet plasma-sdk requis)
make install    # première install
make upgrade    # après modif du code
make uninstall
make reload     # relance plasmashell si widget pas rafraîchi
```

Widget ajouté au bureau: clic droit bureau → Ajouter des composants graphiques → "Month Calendar".

Test: `QT_QPA_PLATFORM=offscreen plasmoidviewer` n'affiche AUCUNE erreur QML (même pour un import inexistant) → inutile. Vérifier avec `qmllint -I /usr/lib/qt6/qml <fichier>` (ignorer les `[unqualified]`) + lancer `make run` sur la vraie session et capturer avec `spectacle -b -n -a -o out.png`. Pour tester une autre config, copier `package/` ailleurs et changer les `<default>` de `contents/config/main.xml`.

Logs QML: `journalctl -f | grep -i plasma` ou sortie de `plasmoidviewer`.

## Conventions

- Imports Qt 6 sans version (`import QtQuick`, pas `2.15`).
- Utiliser `Kirigami.Units` / `Kirigami.Theme` pour tailles et couleurs. Pas de valeurs en dur (pixels, hex) → suit le thème et le DPI.
- `Qt.locale()` pour noms de mois/jours et 1er jour de semaine.
- Changer `metadata.json` (Id, version) → `make upgrade` puis `make reload`.
- Ne pas renommer le plugin Id après install sans `make uninstall` d'abord.

## Idées à venir

- Config: numéros de semaine, 1er jour de semaine.
- Événements via `org.kde.plasma.workspace.calendar`.
- Mode compact (représentation panneau).
