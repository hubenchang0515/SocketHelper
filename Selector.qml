import QtQuick 2.0
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.2

Item {
    id: root
    property alias title: label.text
    property alias currentIndex: comboBox.currentIndex
    property alias currentText: comboBox.currentText
    property alias model: comboBox.model
    property alias count: comboBox.count

    property int leftRatio: -1
    property int rightRatio: -1

    property string titleColor: "white"
    property string underColor: "lightskyblue"

    implicitWidth: 200
    implicitHeight: 40

    enabled: count > 0

    onCurrentIndexChanged: {
        if (root.currentIndex < 0)
            root.currentIndex = 0
    }

    RowLayout {
        anchors.fill: parent
        spacing: 0

        Label {
            id: label
            Layout.fillWidth: root.leftRatio >= 0
            Layout.fillHeight: true
            leftPadding: 10
            rightPadding: 10
            Layout.preferredWidth: root.leftRatio

            text: "Title"
            color: root.titleColor
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter

            background: Rectangle {
                anchors.fill: parent
                color: root.enabled ? root.underColor : "gray"
            }
        }

        ComboBox {
            id: comboBox
            Layout.fillWidth: root.rightRatio >= 0
            Layout.fillHeight: true
            Layout.preferredWidth: root.rightRatio
            currentIndex: 0

            Component.onCompleted: {
                if (comboBox.currentIndex >= comboBox.containmentMask) {
                    comboBox.currentIndex = 0
                }
            }

            flat: true
            background: Rectangle {
                anchors.fill: parent
                color: "white"
                border.color: root.enabled ? root.underColor : "gray"
            }
        }
    }
}
