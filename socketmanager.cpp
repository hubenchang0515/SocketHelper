#include "socketmanager.h"
#include <QHostAddress>
#include <QNetworkProxy>
#include <QNetworkDatagram>
#include <QDebug>

SocketManager::SocketManager(QObject *parent) : QObject(parent)
{

}

QStringList SocketManager::tcpServersModel()
{
    QStringList model;

    for (const auto& server : m_tcpServers)
    {
        auto name = QString("%1:%2").arg(server->serverAddress().toString()).arg(server->serverPort());
        model.push_back(name);
    }

    return model;
}

QStringList SocketManager::connectionModel()
{
    QStringList model;

    for (const auto& sock : m_sockets)
    {

        auto name = QString("%1 LOCAL(%2:%3) ===== PEER(%4:%5)").arg(sock->socketType() == QAbstractSocket::TcpSocket ? "TCP" : "UDP")
                                                                .arg(sock->localAddress().toString())
                                                                .arg(sock->localPort())
                                                                .arg(sock->peerName().length() == 0 ? sock->peerAddress().toString() : sock->peerName())
                                                                .arg(sock->peerPort());
        model.push_back(name);
    }

    return model;
}

void SocketManager::addSocket(QAbstractSocket* sock)
{
    QObject::connect(sock, &QAbstractSocket::disconnected, [this, sock]{
        this->removeSocket(sock);
    });

    this->m_sockets.push_back(sock);
    emit socketAdded(
                sock->peerAddress().toString(),
                sock->peerPort(),
                sock->peerAddress().toString(),
                sock->peerPort()
    );
}

void SocketManager::removeSocket(QAbstractSocket* sock)
{
    int index = this->m_sockets.indexOf(sock);
    if (this->m_sockets.removeOne(sock))
    {
        sock->close();
        sock->deleteLater();
        emit socketRemoved(index);
    }
}


void SocketManager::listen(const QString& ip, int port)
{
    auto server = new QTcpServer(this);
    server->setProxy(QNetworkProxy::NoProxy);
    if (server->listen(QHostAddress(ip), port))
    {
        m_tcpServers.push_back(server);
        QObject::connect(server, &QTcpServer::newConnection, [server, this]{
            auto sock = server->nextPendingConnection();
            this->addSocket(sock);
        });

        emit tcpServerAdded(server->serverAddress().toString(), server->serverPort());
    }
    else
    {
        qDebug() << server->errorString();
        server->deleteLater();
    }
}

void SocketManager::closeTcpServer(int index)
{
    if (index < m_tcpServers.length())
    {
        auto server = m_tcpServers[index];
        m_tcpServers.removeAt(index);
        server->close();
        server->deleteLater();
        emit tcpServerRemoved(index);
    }
}

void SocketManager::connectTcp(const QString& ip, int port)
{
    auto sock = new QTcpSocket(this);
    sock->connectToHost(ip, port);

    QObject::connect(sock, &QTcpSocket::connected, [this, sock]{
        this->addSocket(sock);
    });
}

void SocketManager::disconnectTcpSocket(int index)
{
    if (index <= m_sockets.length())
    {
        auto sock = m_sockets[index];
        this->removeSocket(sock);
    }
}

void SocketManager::bindUdp(const QString& ip, int port)
{
    auto sock = new QUdpSocket(this);
    auto addr = QHostAddress(ip);
    if (addr != QHostAddress::Null && sock->bind(addr, port))
    {
        this->addSocket(sock);
    }
    else
    {
        sock->deleteLater();
    }
}

void SocketManager::connectUdp(const QString& ip, int port)
{
    if (ip == "")
        return;

    auto sock = new QUdpSocket(this);
    sock->connectToHost(ip, port);
    this->addSocket(sock);

    QObject::connect(sock, &QAbstractSocket::connected, [this]{
        emit socketRefreshed();
    });
}
