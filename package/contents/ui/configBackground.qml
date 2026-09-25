import QtQuick
import QtQuick.Controls as QQC2
import QtQuick.Layouts
import org.kde.kirigami as Kirigami
import org.kde.kcmutils as KCMUtils
import org.kde.kquickcontrols as KQuickControls

KCMUtils.SimpleKCM {
    property alias cfg_useSystemBackground: useBg.checked
    property alias cfg_backgroundColor: bgColorButton.color
    property alias cfg_backgroundOpacity: opacitySlider.value
    property alias cfg_cornerRadius: radiusSpin.value
    property alias cfg_blurEnabled: blurCheck.checked
    property alias cfg_blurRadius: blurSlider.value

    Kirigami.FormLayout {
        QQC2.CheckBox {
            id: useBg
            text: i18n("Couleur de fond du thème")
            Kirigami.FormData.label: i18n("Couleur de fond :")
        }
        KQuickControls.ColorButton {
            id: bgColorButton
            Kirigami.FormData.label: i18n("Couleur personnalisée :")
            enabled: !useBg.checked
            showAlphaChannel: false
        }

        RowLayout {
            Kirigami.FormData.label: i18n("Opacité :")
            QQC2.Slider {
                id: opacitySlider
                from: 0
                to: 100
                stepSize: 1
                Layout.preferredWidth: Kirigami.Units.gridUnit * 12
            }
            QQC2.Label {
                text: i18n("%1 %", Math.round(opacitySlider.value))
                Layout.preferredWidth: Kirigami.Units.gridUnit * 3
            }
        }

        QQC2.SpinBox {
            id: radiusSpin
            Kirigami.FormData.label: i18n("Arrondi des coins (px) :")
            from: 0
            to: 100
        }

        Item { Kirigami.FormData.isSection: true }

        QQC2.CheckBox {
            id: blurCheck
            text: i18n("Flouter le fond d'écran derrière le widget")
            Kirigami.FormData.label: i18n("Flou :")
        }
        RowLayout {
            Kirigami.FormData.label: i18n("Intensité du flou :")
            enabled: blurCheck.checked
            QQC2.Slider {
                id: blurSlider
                from: 1
                to: 64
                stepSize: 1
                Layout.preferredWidth: Kirigami.Units.gridUnit * 12
            }
            QQC2.Label {
                text: Math.round(blurSlider.value)
                Layout.preferredWidth: Kirigami.Units.gridUnit * 3
            }
        }
        QQC2.Label {
            Layout.maximumWidth: Kirigami.Units.gridUnit * 20
            wrapMode: Text.Wrap
            opacity: 0.7
            font: Kirigami.Theme.smallFont
            text: i18n("Le flou est appliqué au fond d'écran du bureau, pas aux fenêtres. Il n'apparaît pas dans plasmoidviewer.")
        }
    }
}
