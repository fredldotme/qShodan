#include "shodanlogin.h"

ShodanLogin::ShodanLogin(QObject *parent) : QObject(parent)
{
    refreshSettings();
    connect(this, &ShodanLogin::apiKeyChanged, this, &ShodanLogin::applyKeyToSettings);
}

QString ShodanLogin::apiKey()
{
    return this->m_apiKey;
}

void ShodanLogin::setApiKey(const QString &key)
{
    if (this->m_apiKey == key)
        return;

    this->m_apiKey = key;
    emit apiKeyChanged();
}

void ShodanLogin::refreshSettings()
{
    this->m_settings.beginGroup("BaseSettings");
    const QString key = this->m_settings.value("apiKey").toString();
    this->setApiKey(key);
    this->m_settings.endGroup();
}

void ShodanLogin::applyKeyToSettings()
{
    this->m_settings.beginGroup("BaseSettings");
    this->m_settings.setValue("apiKey", this->m_apiKey);
    this->m_settings.endGroup();
}
