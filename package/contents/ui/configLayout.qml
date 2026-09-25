import QtQuick
import QtQuick.Controls as QQC2
import QtQuick.Layouts
import org.kde.kirigami as Kirigami
import org.kde.kcmutils as KCMUtils

KCMUtils.SimpleKCM {
    property alias cfg_fillWidget: fillCheck.checked
    property alias cfg_cellSize: cellSpin.value
    property alias cfg_padding: paddingSpin.value
    property alias cfg_alignH: alignHCombo.currentIndex
    property alias cfg_alignV: alignVCombo.currentIndex
    property alias cfg_offsetX: offsetXSpin.value
    property alias cfg_offsetY: offsetYSpin.value

    Kirigami.FormLayout {
        QQC2.CheckBox {
            id: fillCheck
            text: i18n("Remplir tout le widget")
            Kirigami.FormData.label: i18n("Mode :")
        }
        QQC2.SpinBox {
            id: cellSpin
            Kirigami.FormData.label: fillCheck.checked ? i18n("Taille minimale d'une case (px) :")
                                                       : i18n("Taille d'une case (px) :")
            from: 16
            to: 160
        }
        QQC2.SpinBox {
            id: paddingSpin
            Kirigami.FormData.label: i18n("Marge intérieure (px) :")
            from: 0
            to: 100
        }

        Item { Kirigami.FormData.isSection: true }

        QQC2.ComboBox {
            id: alignHCombo
            enabled: !fillCheck.checked
            Kirigami.FormData.label: i18n("Alignement horizontal :")
            model: [i18n("Gauche"), i18n("Centre"), i18n("Droite")]
        }
        QQC2.ComboBox {
            id: alignVCombo
            enabled: !fillCheck.checked
            Kirigami.FormData.label: i18n("Alignement vertical :")
            model: [i18n("Haut"), i18n("Centre"), i18n("Bas")]
        }
        QQC2.SpinBox {
            id: offsetXSpin
            Kirigami.FormData.label: i18n("Décalage horizontal (px) :")
            from: -1000
            to: 1000
        }
        QQC2.SpinBox {
            id: offsetYSpin
            Kirigami.FormData.label: i18n("Décalage vertical (px) :")
            from: -1000
            to: 1000
        }

        QQC2.Label {
            Layout.maximumWidth: Kirigami.Units.gridUnit * 20
            wrapMode: Text.Wrap
            opacity: 0.7
            font: Kirigami.Theme.smallFont
            text: i18n("Ces réglages placent le calendrier à l'intérieur du widget. Pour déplacer ou agrandir le widget lui-même sur le bureau, utilise le mode édition (clic droit sur le bureau → Modifier le bureau).")
        }
    }
}
