#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QFont>
#include <QZXing.h>

#include "api/endpoints/shodanhostsearch.h"
#include "api/endpoints/shodanip.h"
#include "api/endpoints/shodantools.h"
#include "api/endpoints/shodanrequest.h"
#include "api/shodansettings.h"
#include "api/shodan.h"
#include "favoritehosts.h"

int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

    QZXing::registerQMLTypes();
    qmlRegisterType<ShodanSettings>("me.fredl.shodan", 1, 0, "ShodanSettings");
    qmlRegisterType<ShodanRequest>("me.fredl.shodan", 1, 0, "ShodanRequest");
    qmlRegisterType<ShodanHostSearch>("me.fredl.shodan", 1, 0, "ShodanHostSearch");
    qmlRegisterType<ShodanIp>("me.fredl.shodan", 1, 0, "ShodanIp");
    qmlRegisterType<ShodanTools>("me.fredl.shodan", 1, 0, "ShodanTools");
    qmlRegisterType<Shodan>("me.fredl.shodan", 1, 0, "Shodan");
    qmlRegisterType<FavoriteHosts>("me.fredl.shodan", 1, 0, "FavoriteHosts");

    QGuiApplication app(argc, argv);
    QFont newFont = app.font();
    newFont.setPixelSize(12);
    app.setFont(newFont);

    QQmlApplicationEngine engine;
    engine.load(QUrl(QStringLiteral("qrc:/qml/main.qml")));
    if (engine.rootObjects().isEmpty())
        return -1;

    return app.exec();
}
