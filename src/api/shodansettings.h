#ifndef SHODANSETTINGS_H
#define SHODANSETTINGS_H

#include <QObject>
#include <QSettings>

class ShodanSettings : public QObject
{
    Q_OBJECT
public:
    Q_PROPERTY(QString apiKey READ apiKey WRITE setApiKey NOTIFY apiKeyChanged)
    Q_PROPERTY(bool darkMode READ darkMode WRITE setDarkMode NOTIFY darkModeChanged)

    explicit ShodanSettings(QObject *parent = nullptr);

    QString apiKey();
    void setApiKey(const QString& key);

    bool darkMode();
    void setDarkMode(const bool& value);

private:
    void refreshSettings();
    void applyToSettings();

    QString m_apiKey;
    bool m_darkMode;
    QSettings m_settings;

signals:
    void apiKeyChanged();
    void darkModeChanged();
};

#endif // SHODANSETTINGS_H
