import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import QtMultimedia 5.9
import QZXing 2.3

Page {
    id: pageRoot

    onVisibleChanged: {
        if (!visible) {
            camera.stop()
        } else {
            camera.start()
            keyField.forceActiveFocus()
        }
    }

    function assertFoundKey(key) {
        if (key.length !== 32)
            return

        keyFound(key)
    }

    Timer {
        id: decodeTriggerTimer
        onTriggered: {
            videoOutput.grabToImage(function(result) {
                qrDecoder.decodeImage(result.image)
            })
        }
        repeat: true
        running: visible
        interval: 100
    }

    signal keyFound(string key);

    Flickable {
        anchors.fill: parent

        Camera {
            id: camera
            position: Camera.BackFace
            focus {
                focusMode: CameraFocus.FocusContinuous
                focusPointMode: CameraFocus.FocusPointAuto
            }
        }

        QZXing {
            id: qrDecoder
            enabledDecoders: QZXing.DecoderFormat_QR_CODE
            onTagFound: {
                assertFoundKey(tag);
            }
        }

        ColumnLayout {
            anchors.fill: parent
            spacing: 16

            Label {
                text: qsTr("Enter your Shodan.io API key...")
                width: parent.width
                wrapMode: Label.WrapAtWordBoundaryOrAnywhere
                font.pixelSize: Qt.application.font.pixelSize * 1.5
                padding: 10
            }

            RowLayout {
                Layout.alignment: Qt.AlignCenter
                width: parent.width

                TextField {
                    id: keyField
                    placeholderText: qsTr("API key")
                    width: (parent.width/3) * 2
                    Keys.onReturnPressed: {
                        assertFoundKey(keyField.text)
                    }
                }

                Button {
                    text: qsTr("Ok")
                    width: (parent.width/3)
                    enabled: keyField.text.length == 32
                    onClicked: assertFoundKey(keyField.text)
                }
            }

            Label {
                text: qsTr("... or scan it")
                width: parent.width
                wrapMode: Label.WrapAtWordBoundaryOrAnywhere
                font.pixelSize: Qt.application.font.pixelSize * 1.5
                padding: 10
            }

            VideoOutput {
                id: videoOutput
                Layout.maximumHeight: parent.height / 2
                Layout.maximumWidth: height
                Layout.alignment: Qt.AlignCenter
                source: camera
                fillMode: VideoOutput.PreserveAspectFit
                rotation : {
                    if (camera.orientation === 0)
                        return 0
                    else
                        return 90
                }
                transformOrigin: Item.Center
                enabled: pageRoot.visible
                visible: enabled
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        camera.focus.customFocusPoint = Qt.point(mouse.x / width,  mouse.y / height);
                        camera.focus.focusMode = CameraFocus.FocusMacro;
                        camera.focus.focusPointMode = CameraFocus.FocusPointCustom;
                    }
                }
            }
        }
    }
}
