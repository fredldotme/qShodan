import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Controls.Material 2.2
import QtQuick.Layouts 1.0
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
    ShodanTools {
        id: shodanTools
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
        modal: true
        x: (parent.width - width) / 2
        y: (parent.height - height) / 2

        Label {
            anchors.fill: parent
            id: textItem
            width: parent.width
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

    header: ToolBar {
        id: toolBar
        width: parent.width
        background: Rectangle {
            color: "transparent"
        }

        readonly property bool enableMainToolBar :
            searchContainerView.searchContainer.currentIndex < 1 &&
            selfCheckContainerView.selfCheckContainerContainer.currentIndex < 1 &&
            favoritesContainerView.favoritesContainer.currentIndex < 1

        visible: shodanSettings.apiKey !== ""
        enabled: enableMainToolBar

        RowLayout {
            anchors.fill: parent
            Label {
                color: Material.accent
                text: swipeView.currentItem.title
                font.pixelSize: Qt.application.font.pixelSize * 2
                padding: 10
                Layout.fillWidth: true
            }

            ToolButton {
                text: "☰"
                visible: toolBar.enableMainToolBar
                onClicked: {
                    menu.open()
                }
            }
        }
        Menu {
            id: menu
            x: parent.width - width
            y: toolBar.height

            property color highlightColor : Material.accent

            MenuItem {
                text: "Search"
                onClicked: swipeView.currentIndex = 0
                background: Rectangle {
                    color: menu.highlightColor
                    visible: swipeView.currentIndex == 0
                }
            }
            MenuItem {
                text: "Self-check"
                onClicked: swipeView.currentIndex = 1
                background: Rectangle {
                    color: menu.highlightColor
                    visible: swipeView.currentIndex == 1
                }
            }
            MenuItem {
                text: "Favorites"
                onClicked: swipeView.currentIndex = 2
                background: Rectangle {
                    color: menu.highlightColor
                    visible: swipeView.currentIndex == 2
                }
            }
            MenuItem {
                text: "Settings"
                onClicked: swipeView.currentIndex = 3
                background: Rectangle {
                    color: menu.highlightColor
                    visible: swipeView.currentIndex == 3
                }
            }
            MenuItem {
                text: "About"
                onClicked: swipeView.currentIndex = 4
                background: Rectangle {
                    color: menu.highlightColor
                    visible: swipeView.currentIndex == 4
                }
            }
        }
    }

    // SwipeView in case API key exists
    SwipeView {
        id: swipeView
        anchors.fill: parent
        visible: hasApiKey
        interactive: toolBar.enabled

        SearchContainerView {
            id: searchContainerView
        }
        SelfCheckContainer {
            id: selfCheckContainerView
        }
        FavoritesContainer {
            id: favoritesContainerView
        }
        SettingsForm {
            settings: shodanSettings
            onClearApiKey: {
                shodanSettings.apiKey = ""
            }
        }
        AboutForm {}
    }
}
