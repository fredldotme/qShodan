#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QZXing.h>

#include "api/endpoints/shodanhost.h"
#include "api/endpoints/shodanrequest.h"
#include "api/shodanlogin.h"
#include "api/shodan.h"

int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

    QZXing::registerQMLTypes();
    qmlRegisterType<ShodanLogin>("me.fredl.shodan", 1, 0, "ShodanLogin");
    qmlRegisterType<ShodanRequest>("me.fredl.shodan", 1, 0, "ShodanRequest");
    qmlRegisterType<ShodanHost>("me.fredl.shodan", 1, 0, "ShodanHost");
    qmlRegisterType<Shodan>("me.fredl.shodan", 1, 0, "Shodan");

    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;
    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));
    if (engine.rootObjects().isEmpty())
        return -1;

    return app.exec();
}
