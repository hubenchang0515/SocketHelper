#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include "socketmanager.h"

int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

    QGuiApplication app(argc, argv);

    SocketManager socketManager;

    QQmlApplicationEngine engine;

    engine.rootContext()->setContextProperty("manager", &socketManager);

    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));
    if (engine.rootObjects().isEmpty())
        return -1;

    return app.exec();
}
