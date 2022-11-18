import QtQuick 2.0
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.2

Item {
    id: root
    property alias title: label.text
    default property alias children: sub.children

    property string titleColor: "white"
    property string underColor: "lightskyblue"

    implicitWidth: 200
    implicitHeight: view.height

    ColumnLayout {
        id: view
        width: parent.width

        Label {
            id: label
            Layout.fillWidth: true

            text: "Panel"
            color: "white"
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            padding: 10

            background: Rectangle {
                anchors.fill: parent
                color: root.enabled ? root.underColor : "gray"
            }
        }

        Item {
            id: sub
            implicitHeight: childrenRect.height

            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.leftMargin: 5
            Layout.rightMargin: 5
            Layout.bottomMargin: 5
        }
    }

    Rectangle {
        id: back
        anchors.fill: root
        border.color: root.enabled ? root.underColor : "gray"
        z: -1
    }
}
