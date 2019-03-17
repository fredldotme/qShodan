import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Controls.Material 2.2
import me.fredl.shodan 1.0

ApplicationWindow {
    visible: true
    width: 400
    minimumWidth: 350
    height: 600
    minimumHeight: 500

    Material.theme: shodanSettings.darkMode ?
                        Material.Dark :
                        Material.Light
    Material.accent: shodanSettings.darkMode ?
                         Material.Red :
                         Material.Blue

    title: qsTr("qShodan")

    readonly property bool hasApiKey :
        shodanSettings.apiKey !== ""

    ShodanSettings {
        id: shodanSettings
    }
    ShodanHostSearch {
        id: shodanHostApi
        apiKey: shodanSettings.apiKey
        onError: {
            dialog.text = qsTr(errorString)
            dialog.open()
        }
    }
    ShodanIp {
        id: shodanIpApi
        apiKey: shodanSettings.apiKey
        onError: {
            dialog.text = qsTr(errorString)
            dialog.open()
        }
    }
    Dialog {
        id: dialog
        title: qsTr("An error occured")
        property alias text : textItem.text
        standardButtons: Dialog.Ok
        x: (parent.width - width) / 2
        y: (parent.height - height) / 2

        Label {
            anchors.fill: parent
            id: textItem
        }
    }

    // Main views
    // "Login" screen using QRCode key reader
    LoginScreen {
        id: loginPage
        visible: !hasApiKey
        enabled: visible
        anchors.fill: parent
        onKeyFound: {
            shodanSettings.apiKey = key
            swipeView.currentIndex = 0
        }
    }

    // SwipeView in case API key exists
    SwipeView {
        id: swipeView
        anchors.fill: parent
        visible: hasApiKey
        currentIndex: tabBar.currentIndex

        SearchContainerView {}

        //FavoritesForm {}
        SettingsForm {
            settings: shodanSettings
            onClearApiKey: {
                shodanSettings.apiKey = ""
            }
        }
    }

    footer: TabBar {
        id: tabBar
        visible: shodanSettings.apiKey !== ""
        currentIndex: swipeView.currentIndex

        TabButton {
            text: qsTr("Search")
        }
        /*TabButton {
            text: qsTr("Favorites")
        }*/
        TabButton {
            text: qsTr("Settings")
        }
    }
}
