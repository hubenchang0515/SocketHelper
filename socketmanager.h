#ifndef SOCKETMANAGER_H
#define SOCKETMANAGER_H

#include <QObject>
#include <QMap>
#include <QList>
#include <QTcpServer>
#include <QTcpSocket>
#include <QUdpSocket>

class SocketManager : public QObject
{
    Q_OBJECT
public:
    explicit SocketManager(QObject *parent = nullptr);

    Q_INVOKABLE QStringList tcpServersModel();
    Q_INVOKABLE QStringList connectionModel();

    void addSocket(QAbstractSocket* sock);
    void removeSocket(QAbstractSocket* sock);

public slots:
    void listen(const QString& ip, int port);
    void closeTcpServer(int index);

    void connectTcp(const QString& ip, int port);
    void disconnectTcpSocket(int index);

    void bindUdp(const QString& ip, int port);
    void connectUdp(const QString& ip, int port);

signals:
    void tcpServerAdded(const QString& ip, int port);
    void tcpServerRemoved(int index);

    void socketAdded(const QString& localIp, int localPort, const QString& peerIp, int peerPort);
    void socketRemoved(int index);
    void socketRefreshed();

private:
    QList<QTcpServer*> m_tcpServers;
    QList<QAbstractSocket*> m_sockets;
};

#endif // SOCKETMANAGER_H
