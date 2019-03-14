import QtQuick 2.9
import QtQuick.Controls 2.2
import me.fredl.shodan 1.0

ApplicationWindow {
    visible: true
    width: 400
    minimumWidth: 350
    height: 600
    minimumHeight: 500

    title: qsTr("qShodan")

    readonly property bool hasApiKey :
        loginCredentials.apiKey !== ""

    ShodanLogin {
        id: loginCredentials
    }
    ShodanHostSearch {
        id: shodanHostApi
        apiKey: loginCredentials.apiKey
    }
    ShodanIp {
        id: shodanIpApi
        apiKey: loginCredentials.apiKey
    }

    // Main views
    // "Login" screen using QRCode key reader
    LoginScreen {
        id: loginPage
        visible: !hasApiKey
        enabled: visible
        anchors.fill: parent
        onKeyFound: {
            loginCredentials.apiKey = key
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
            onClearApiKey: {
                loginCredentials.apiKey = ""
            }
        }
    }

    footer: TabBar {
        id: tabBar
        visible: loginCredentials.apiKey !== ""
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
