import QtQuick
import QtQuick.Controls as QQC2
import QtQuick.Effects
import QtQuick.Layouts
import org.kde.plasma.plasmoid
import org.kde.plasma.core as PlasmaCore
import org.kde.kirigami as Kirigami

PlasmoidItem {
    id: root
    preferredRepresentation: fullRepresentation
    // fond dessiné par le widget (transparence/flou configurables)
    Plasmoid.backgroundHints: PlasmaCore.Types.NoBackground

    readonly property var cfg: Plasmoid.configuration

    // alignement du texte dans les cases ; col = colonne 0..6
    // cfg.textAlign : 0 centré, 1 aux bords (1re colonne à gauche, dernière à droite), 2 gauche, 3 droite
    function textHAlign(col) {
        switch (cfg.textAlign) {
        case 1: return col === 0 ? Text.AlignLeft : col === 6 ? Text.AlignRight : Text.AlignHCenter;
        case 2: return Text.AlignLeft;
        case 3: return Text.AlignRight;
        default: return Text.AlignHCenter;
        }
    }
    property date now: new Date()

    // rafraîchit à minuit (vérifie chaque minute)
    Timer {
        interval: 60000
        running: true
        repeat: true
        onTriggered: root.now = new Date()
    }

    fullRepresentation: Item {
        id: full

        readonly property real cell: root.cfg.cellSize
        readonly property real contentWidth: cell * 7
        readonly property real contentHeight: cell * 7.8 // titre + jours de semaine (0.8) + 6 lignes

        Layout.minimumWidth: contentWidth + root.cfg.padding * 2
        Layout.minimumHeight: contentHeight + root.cfg.padding * 2
        Layout.preferredWidth: Layout.minimumWidth
        Layout.preferredHeight: Layout.minimumHeight

        // --- fond ---
        readonly property color bgBase: root.cfg.useSystemBackground ? Kirigami.Theme.backgroundColor
                                                                      : root.cfg.backgroundColor

        // Fond d'écran du bureau, trouvé en remontant vers le ContainmentItem.
        // null hors bureau Plasma (ex. plasmoidviewer) → pas de flou.
        readonly property var wallpaperItem: {
            let p = root.parent;
            while (p) {
                if (p.wallpaper) {
                    return p.wallpaper;
                }
                p = p.parent;
            }
            return null;
        }
        readonly property bool blurActive: root.cfg.blurEnabled && wallpaperItem !== null

        Rectangle {
            id: bgMask
            anchors.fill: parent
            radius: root.cfg.cornerRadius
            visible: false
            layer.enabled: true
        }

        ShaderEffectSource {
            id: wallpaperSource
            anchors.fill: parent
            visible: false
            live: full.blurActive
            sourceItem: full.blurActive ? full.wallpaperItem : null
            sourceRect: Qt.rect(0, 0, 0, 0)

            function updateRect() {
                if (full.blurActive) {
                    const p = full.mapToItem(full.wallpaperItem, 0, 0);
                    sourceRect = Qt.rect(p.x, p.y, full.width, full.height);
                }
            }
            Component.onCompleted: updateRect()
        }
        // le widget peut être déplacé sans notification simple → on relit la position
        Timer {
            interval: 300
            running: full.blurActive
            repeat: true
            onTriggered: wallpaperSource.updateRect()
        }

        MultiEffect {
            anchors.fill: parent
            visible: full.blurActive
            source: wallpaperSource
            blurEnabled: true
            blurMax: 64
            blur: root.cfg.blurRadius / 64
            maskEnabled: true
            maskSource: bgMask
        }

        Rectangle {
            anchors.fill: parent
            radius: root.cfg.cornerRadius
            color: Qt.rgba(full.bgBase.r, full.bgBase.g, full.bgBase.b, root.cfg.backgroundOpacity / 100)
        }

        // --- contenu ---
        Item {
            id: content
            // fillWidget: le calendrier occupe tout le widget (moins la marge), sans espace perdu
            readonly property bool fill: root.cfg.fillWidget
            width: fill ? Math.max(0, full.width - root.cfg.padding * 2) : full.contentWidth
            height: fill ? Math.max(0, full.height - root.cfg.padding * 2) : full.contentHeight
            // hauteur d'une "ligne" (le contenu fait 7.8 lignes)
            readonly property real unit: height / 7.8

            x: {
                const pad = root.cfg.padding;
                if (fill) {
                    return pad + root.cfg.offsetX;
                }
                switch (root.cfg.alignH) {
                case 0: return pad + root.cfg.offsetX;
                case 2: return full.width - width - pad + root.cfg.offsetX;
                default: return (full.width - width) / 2 + root.cfg.offsetX;
                }
            }
            y: {
                const pad = root.cfg.padding;
                if (fill) {
                    return pad + root.cfg.offsetY;
                }
                switch (root.cfg.alignV) {
                case 0: return pad + root.cfg.offsetY;
                case 2: return full.height - height - pad + root.cfg.offsetY;
                default: return (full.height - height) / 2 + root.cfg.offsetY;
                }
            }

            readonly property color textColor: root.cfg.useSystemText ? Kirigami.Theme.textColor
                                                                       : root.cfg.textColor
            readonly property color markerColor: root.cfg.useSystemAccent ? Kirigami.Theme.highlightColor
                                                                          : root.cfg.markerColor
            // texte lisible sur marque pleine : noir ou blanc selon la luminance
            readonly property color onMarkerColor: (0.299 * markerColor.r + 0.587 * markerColor.g + 0.114 * markerColor.b) > 0.6
                                                   ? "black" : "white"

            ColumnLayout {
                anchors.fill: parent
                spacing: 0

                QQC2.Label {
                    Layout.alignment: Qt.AlignHCenter
                    Layout.preferredHeight: content.unit
                    verticalAlignment: Text.AlignVCenter
                    font.pointSize: root.cfg.fontSize * 1.3
                    font.bold: true
                    color: content.textColor
                    text: {
                        const m = Qt.locale().monthName(root.now.getMonth());
                        return m.charAt(0).toUpperCase() + m.slice(1) + " " + root.now.getFullYear();
                    }
                }

                QQC2.DayOfWeekRow {
                    Layout.fillWidth: true
                    Layout.preferredHeight: content.unit * 0.8
                    locale: Qt.locale()
                    spacing: 0
                    padding: 0
                    leftPadding: 0
                    rightPadding: 0
                    topPadding: 0
                    bottomPadding: 0
                    delegate: QQC2.Label {
                        text: model.shortName.substring(0, 2)
                        font.pointSize: root.cfg.fontSize * 0.85
                        color: content.textColor
                        opacity: 0.6
                        horizontalAlignment: root.textHAlign(model.index)
                        verticalAlignment: Text.AlignVCenter
                    }
                }

                QQC2.MonthGrid {
                    id: grid
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    padding: 0
                    leftPadding: 0
                    rightPadding: 0
                    topPadding: 0
                    bottomPadding: 0
                    spacing: 0
                    month: root.now.getMonth()
                    year: root.now.getFullYear()
                    locale: Qt.locale()

                    delegate: Item {
                        id: dayCell
                        readonly property bool inMonth: model.month === grid.month
                        readonly property bool isToday: inMonth && model.day === root.now.getDate()
                        readonly property int style: root.cfg.markerStyle
                        readonly property bool filled: style === 0 || style === 1
                        readonly property real markSize: Math.min(width, height) * 0.9
                        readonly property bool hasBox: isToday && style !== 2
                        // centre horizontal souhaité du texte selon l'alignement
                        readonly property real wantedCenter: {
                            const half = dayLabel.implicitWidth / 2;
                            switch (root.textHAlign(model.index)) {
                            case Text.AlignLeft: return half;
                            case Text.AlignRight: return width - half;
                            default: return width / 2;
                            }
                        }
                        // la marque pleine/anneau reste dans la case et le texte suit son centre
                        readonly property real centerX: hasBox
                            ? Math.max(markSize / 2, Math.min(width - markSize / 2, wantedCenter))
                            : wantedCenter

                        // cercle plein / carré arrondi / anneau
                        Rectangle {
                            x: dayCell.centerX - width / 2
                            anchors.verticalCenter: parent.verticalCenter
                            visible: dayCell.hasBox
                            width: dayCell.markSize
                            height: width
                            radius: dayCell.style === 1 ? width * 0.22 : width / 2
                            color: dayCell.filled ? content.markerColor : "transparent"
                            border.width: dayCell.style === 3 ? Math.max(2, width * 0.07) : 0
                            border.color: content.markerColor
                        }
                        // soulignement
                        Rectangle {
                            visible: dayCell.isToday && dayCell.style === 2
                            x: dayCell.centerX - width / 2
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.verticalCenterOffset: dayLabel.implicitHeight / 2 + 1
                            width: dayLabel.implicitWidth + 4
                            height: Math.max(2, dayCell.height * 0.07)
                            radius: height / 2
                            color: content.markerColor
                        }
                        QQC2.Label {
                            id: dayLabel
                            x: dayCell.centerX - width / 2
                            anchors.verticalCenter: parent.verticalCenter
                            text: model.day
                            font.pointSize: root.cfg.fontSize
                            font.bold: dayCell.isToday && root.cfg.boldToday
                            opacity: dayCell.inMonth ? 1 : 0.3
                            color: dayCell.isToday && dayCell.filled ? content.onMarkerColor
                                                                    : content.textColor
                        }
                    }
                }
            }
        }
    }
}
