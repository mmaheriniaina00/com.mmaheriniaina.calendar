import QtQuick
import org.kde.plasma.configuration

ConfigModel {
    ConfigCategory {
        name: i18n("Style")
        icon: "preferences-desktop-color"
        source: "configAppearance.qml"
    }
    ConfigCategory {
        name: i18n("Arrière-plan")
        icon: "preferences-desktop-wallpaper"
        source: "configBackground.qml"
    }
    ConfigCategory {
        name: i18n("Taille et position")
        icon: "transform-move"
        source: "configLayout.qml"
    }
}
