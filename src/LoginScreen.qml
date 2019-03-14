import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import QtMultimedia 5.9
import QZXing 2.3

Page {
    id: pageRoot
    width: 400
    height: 600

    onVisibleChanged: {
        if (!visible)
            camera.stop()
        else
            camera.start()
    }

    header: Label {
        text: qsTr("Scan your shodan.io API key...")
        width: parent.width
        wrapMode: Label.WrapAtWordBoundaryOrAnywhere
        font.pixelSize: Qt.application.font.pixelSize * 1.5
        padding: 10
    }

    function assertFoundKey(key) {
        if (key.length !== 32)
            return

        keyFound(key)
    }

    signal keyFound(string key);

    Camera {
        id: camera
        focus {
            focusMode: CameraFocus.FocusContinuous
            focusPointMode: CameraFocus.FocusPointAuto
        }
    }

    QZXingFilter {
        id: zxingFilter
        active: pageRoot.visible
        decoder {
            id: qrcDecoder
            enabledDecoders: QZXing.DecoderFormat_QR_CODE
            onTagFound: {
                console.log(tag);
                assertFoundKey(tag);
            }
        }
    }

    ColumnLayout {
        anchors.fill: parent
        spacing: 64

        VideoOutput {
            id: videoOutput
            Layout.maximumHeight: parent.height / 2
            Layout.maximumWidth: height
            Layout.alignment: Qt.AlignCenter
            source: camera
            filters: [ zxingFilter ]
            fillMode: VideoOutput.PreserveAspectFit
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

        Label {
            text: qsTr("...or enter the key manually.")
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
    }
}
