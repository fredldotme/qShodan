#ifndef SHODAN_H
#define SHODAN_H

#include <QObject>

#include "shodansettings.h"
#include "endpoints/shodanhostsearch.h"

class Shodan : public QObject
{
    Q_OBJECT
public:
    Q_PROPERTY(ShodanHostSearch* host READ host FINAL)
    Q_PROPERTY(ShodanSettings* login READ shodanLogin WRITE setShodanLogin NOTIFY shodanLoginChanged)

    explicit Shodan(QObject *parent = nullptr,
                    ShodanSettings* login = nullptr);

    void setShodanLogin(ShodanSettings* login);
    ShodanSettings* shodanLogin();

public slots:
    ShodanHostSearch* host();

private:
    ShodanSettings* m_login = nullptr;
    ShodanHostSearch m_host;

signals:
    void shodanLoginChanged();
};

#endif // SHODAN_H
