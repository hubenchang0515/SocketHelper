import QtQuick 2.0
import QtQuick.Controls 2.12

Button {
    id: root
    text: "BUTTON"

    contentItem: Text {
        text: root.text
        font: root.font
        opacity: enabled ? 1.0 : 0.3
        color: root.down ? "midnightblue" : "white"
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideRight
    }

    background: Rectangle {
        implicitWidth: 100
        implicitHeight: 40
        opacity: enabled ? 1 : 0.3
        color: root.down ? "lightsteelblue" : "midnightblue"
        radius: 2
    }
}
