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

    // Dirty hack to fix the DetailsForm
    // ToolBar button text colors
    Component.onCompleted: {
        var actualSetting = shodanSettings.darkMode
        shodanSettings.darkMode = !actualSetting
        shodanSettings.darkMode = actualSetting
    }

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
            dialog.text = errorString
            dialog.open()
        }
    }
    ShodanIp {
        id: shodanIpApi
        apiKey: shodanSettings.apiKey
        onError: {
            dialog.text = errorString
            dialog.open()
        }
    }
    FavoriteHosts {
        id: favorites
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
            wrapMode: Label.WrapAtWordBoundaryOrAnywhere
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
        //currentIndex: tabBar.currentIndex

        SearchContainerView {}
        FavoritesContainer {}
        SettingsForm {
            settings: shodanSettings
            onClearApiKey: {
                shodanSettings.apiKey = ""
            }
        }
        AboutForm {}
    }

    footer: TabBar {
        id: tabBar
        visible: shodanSettings.apiKey !== ""
        currentIndex: swipeView.currentIndex

        // Looking glass
        TabButton {
            text: "Search"
            //text: String.fromCharCode(0xF09F8C90)
            onClicked: swipeView.currentIndex = 0
        }
        // Favorites
        TabButton {
            text: "Favorites"
            //text: String.fromCharCode(0x2605)
            onClicked: swipeView.currentIndex = 1
        }
        // Settings
        TabButton {
            text: "Settings"
            //text: String.fromCharCode(0x2699)
            onClicked: swipeView.currentIndex = 2
        }
        // About
        TabButton {
            text: "About"
            //text: String.fromCharCode(0x2753)
            onClicked: swipeView.currentIndex = 3
        }
    }
}
