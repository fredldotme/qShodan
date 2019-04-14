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
    Q_PROPERTY(bool explore READ explore WRITE setExplore NOTIFY exploreChanged)

    explicit ShodanSettings(QObject *parent = nullptr);

    QString apiKey();
    void setApiKey(const QString& key);

    bool darkMode();
    void setDarkMode(const bool& value);

    bool explore();
    void setExplore(const bool& value);

private:
    void refreshSettings();
    void applyToSettings();

    QString m_apiKey;
    bool m_darkMode;
    bool m_explore;
    QSettings m_settings;

signals:
    void apiKeyChanged();
    void darkModeChanged();
    void exploreChanged();
};

#endif // SHODANSETTINGS_H
