import QtQuick 2.6
import QtQuick.Window 2.2
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.2

ApplicationWindow {
    visible: true
    width: 1280
    height: 720
    title: qsTr("Socket Helper")
    color: "whitesmoke"

    RowLayout {
        anchors.fill: parent
        anchors.margins: 5

        GridLayout {
            Layout.fillHeight: true
            Layout.preferredWidth:  1
            Layout.alignment: Qt.AlignTop

            Selector {
                id: protocol
                Layout.row: 0
                Layout.column: 0
                Layout.columnSpan: 2
                Layout.fillWidth: true
                leftRatio: 1
                rightRatio: 2

                title: qsTr("Protocol")
                currentIndex: 0
                model: ["TCP", "UDP"]
            }

            LineInput {
                id: ip
                Layout.row: 1
                Layout.column: 0
                Layout.columnSpan: 2
                Layout.fillWidth: true
                leftRatio: 1
                rightRatio: 2

                title: qsTr("IP")
                hint: "IPv4/IPv6/domain"
            }

            LineInput {
                id: port
                Layout.row: 2
                Layout.column: 0
                Layout.columnSpan: 2
                Layout.fillWidth: true
                leftRatio: 1
                rightRatio: 2

                title: qsTr("Port")
                hint: "1~65535, 0 listen auto"
            }

            PushButton {
                id: bind
                Layout.row: 3
                Layout.column: 0
                Layout.fillWidth: true

                text: qsTr("BIND")

                onClicked: {
                    if (protocol.currentIndex == 0) {
                        manager.listen(ip.value, Number(port.value))
                    } else {
                        manager.bindUdp(ip.value, Number(port.value))
                    }
                }
            }

            PushButton {
                id: connect
                Layout.row: 3
                Layout.column: 1
                Layout.fillWidth: true

                text: qsTr("CONNECT")

                onClicked: {
                    if (protocol.currentIndex == 0) {
                        manager.connectTcp(ip.value, Number(port.value))
                    } else {
                        manager.connectUdp(ip.value, Number(port.value))
                    }
                }
            }

            Panel {
                Layout.row: 4
                Layout.column: 0
                Layout.columnSpan: 2
                Layout.fillWidth: true

                title: qsTr("Display Configure")

                Flow {
                    width: parent.width
                    height: childrenRect.height

                    CheckBox {
                        id: displayHex
                        text: qsTr("HEX")
                    }

                    CheckBox {
                        id: state
                        text: qsTr("Event")
                    }

                    CheckBox {
                        id: showTime
                        text: qsTr("Time")
                    }

                    CheckBox {
                        id: showDate
                        text: qsTr("Date")
                    }
                }
            }

            Panel {
                Layout.row: 5
                Layout.column: 0
                Layout.columnSpan: 2
                Layout.fillWidth: true

                title: qsTr("Send Configure")

                Flow {
                    width: parent.width

                    CheckBox {
                        id: sendHex
                        text: qsTr("HEX")
                    }
                }
            }

            Panel {
                Layout.row: 6
                Layout.column: 0
                Layout.columnSpan: 2
                Layout.fillWidth: true
                enabled: server.count > 0

                title: qsTr("TCP Server Configure")

                ColumnLayout {
                    width: parent.width

                    Selector {
                        id: server
                        title: qsTr("TCP")
                        width: parent.width
                        rightRatio: 0
                        Layout.fillWidth: true

                        model: manager.tcpServersModel()

                        Connections {
                            target: manager

                            function onTcpServerAdded(ip, port) {
                                let index = server.currentIndex
                                server.model = manager.tcpServersModel()
                                server.currentIndex = index
                            }

                            function onTcpServerRemoved(index) {
                                let current = server.currentIndex
                                server.model = manager.tcpServersModel()
                                if (index > current)
                                    server.currentIndex = current
                                else
                                    server.currentIndex = current - 1
                            }
                        }
                    }

                    PushButton {
                        id: close
                        Layout.fillWidth: true
                        text: qsTr("CLOSE")
                        width: parent.width
                        enabled: server.enabled

                        onClicked: {
                            manager.closeTcpServer(server.currentIndex)
                        }
                    }

                }
            }

        }

        ColumnLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.preferredWidth: 4

            RowLayout {
                Selector {
                    id: connection
                    Layout.fillWidth: true
                    rightRatio: 0

                    title: qsTr("Connection")
                    model: manager.connectionModel()

                    Connections {
                        target: manager

                        function onSocketRefreshed() {
                            let index = connection.currentIndex
                            connection.model = manager.connectionModel()
                            connection.currentIndex = index
                        }

                        function onSocketAdded(localIp, localPort, peerIp, peerPort) {
                            let index = connection.currentIndex
                            connection.model = manager.connectionModel()
                            connection.currentIndex = index
                        }

                        function onSocketRemoved(index) {
                            let current = connection.currentIndex
                            connection.model = manager.connectionModel()

                            if (index > current)
                                connection.currentIndex = current
                            else
                                connection.currentIndex = current - 1
                        }
                    }
                }

                PushButton {
                    id: disconnect
                    text: qsTr("DISCONNECT")
                    enabled: connection.enabled

                    onClicked: {
                        manager.disconnectTcpSocket(connection.currentIndex)
                    }
                }
            }

            TextArea {
                id: displayArea
                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.preferredWidth: 4
                Layout.preferredHeight: 3
                readOnly: true
                selectByMouse: true

                background: Rectangle {
                    color: "white"
                    border.color: "lightsteelblue"
                }
            }

            RowLayout {
                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.preferredWidth: 4
                Layout.preferredHeight: 1

                TextArea {
                    id: sendArea
                    Layout.fillWidth: true
                    Layout.fillHeight: true

                    background: Rectangle {
                        color: "white"
                        border.color: sendArea.focus ? "cornflowerblue" : "lightsteelblue"
                    }
                }

                PushButton {
                    id: send
                    Layout.fillHeight: true
                    text: qsTr("SEND")
                }

            }
        }
    }
}
