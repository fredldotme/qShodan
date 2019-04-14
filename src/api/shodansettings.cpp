#include "shodansettings.h"

ShodanSettings::ShodanSettings(QObject *parent) :
    QObject(parent),
    m_darkMode(false),
    m_explore(false)
{
    refreshSettings();
    connect(this, &ShodanSettings::apiKeyChanged, this, &ShodanSettings::applyToSettings);
    connect(this, &ShodanSettings::darkModeChanged, this, &ShodanSettings::applyToSettings);
}

QString ShodanSettings::apiKey()
{
    return this->m_apiKey;
}

void ShodanSettings::setApiKey(const QString &key)
{
    if (this->m_apiKey == key)
        return;

    this->m_apiKey = key;
    emit apiKeyChanged();
}

bool ShodanSettings::darkMode()
{
    return this->m_darkMode;
}

void ShodanSettings::setDarkMode(const bool &value)
{
    if (this->m_darkMode == value)
        return;

    this->m_darkMode = value;
    emit darkModeChanged();
}

bool ShodanSettings::explore()
{
    return this->m_explore;
}

void ShodanSettings::setExplore(const bool &value)
{
    if (this->m_explore == value)
        return;

    this->m_explore = value;
    emit exploreChanged();
}

void ShodanSettings::refreshSettings()
{
    this->m_settings.beginGroup("BaseSettings");
    const QString key = this->m_settings.value("apiKey").toString();
    const bool colorMode = this->m_settings.value("darkMode").toBool();
    const bool explore = this->m_settings.value("explore").toBool();
    this->setApiKey(key);
    this->setDarkMode(colorMode);
    this->setExplore(explore);
    this->m_settings.endGroup();
}

void ShodanSettings::applyToSettings()
{
    this->m_settings.beginGroup("BaseSettings");
    this->m_settings.setValue("apiKey", this->apiKey());
    this->m_settings.setValue("darkMode", this->darkMode());
    this->m_settings.setValue("explore", this->explore());
    this->m_settings.endGroup();
}
