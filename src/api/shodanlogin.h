#ifndef SHODANLOGIN_H
#define SHODANLOGIN_H

#include <QObject>
#include <QSettings>

class ShodanLogin : public QObject
{
    Q_OBJECT
public:
    Q_PROPERTY(QString apiKey READ apiKey WRITE setApiKey NOTIFY apiKeyChanged)

    explicit ShodanLogin(QObject *parent = nullptr);

    QString apiKey();
    void setApiKey(const QString& key);

private:
    void refreshSettings();
    void applyKeyToSettings();

    QString m_apiKey;
    QSettings m_settings;

signals:
    void apiKeyChanged();
};

#endif // SHODANLOGIN_H
