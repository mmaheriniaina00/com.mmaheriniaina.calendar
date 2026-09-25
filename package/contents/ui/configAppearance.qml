import QtQuick
import QtQuick.Controls as QQC2
import QtQuick.Layouts
import org.kde.kirigami as Kirigami
import org.kde.kcmutils as KCMUtils
import org.kde.kquickcontrols as KQuickControls

KCMUtils.SimpleKCM {
    property alias cfg_markerStyle: styleCombo.currentIndex
    property alias cfg_useSystemAccent: useAccent.checked
    property alias cfg_markerColor: markerColorButton.color
    property alias cfg_useSystemText: useText.checked
    property alias cfg_textColor: textColorButton.color
    property alias cfg_fontSize: fontSpin.value
    property alias cfg_textAlign: alignCombo.currentIndex
    property alias cfg_boldToday: boldCheck.checked

    Kirigami.FormLayout {
        QQC2.ComboBox {
            id: styleCombo
            Kirigami.FormData.label: i18n("Marque du jour :")
            model: [i18n("Cercle plein"), i18n("Carré arrondi"), i18n("Soulignement"), i18n("Anneau")]
        }
        QQC2.CheckBox {
            id: useAccent
            text: i18n("Couleur d'accent du système")
            Kirigami.FormData.label: i18n("Couleur de la marque :")
        }
        KQuickControls.ColorButton {
            id: markerColorButton
            Kirigami.FormData.label: i18n("Couleur personnalisée :")
            enabled: !useAccent.checked
            showAlphaChannel: false
        }

        Item { Kirigami.FormData.isSection: true }

        QQC2.CheckBox {
            id: useText
            text: i18n("Couleur de texte du thème")
            Kirigami.FormData.label: i18n("Couleur du texte :")
        }
        KQuickControls.ColorButton {
            id: textColorButton
            Kirigami.FormData.label: i18n("Couleur personnalisée :")
            enabled: !useText.checked
            showAlphaChannel: false
        }
        QQC2.SpinBox {
            id: fontSpin
            Kirigami.FormData.label: i18n("Taille de police (pt) :")
            from: 6
            to: 72
        }
        QQC2.ComboBox {
            id: alignCombo
            Kirigami.FormData.label: i18n("Alignement dans les cases :")
            model: [i18n("Centré"), i18n("Aux bords (sans espace)"), i18n("Gauche"), i18n("Droite")]
        }
        QQC2.CheckBox {
            id: boldCheck
            text: i18n("Jour du jour en gras")
        }
    }
}
