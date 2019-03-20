#include "favoritehosts.h"

#include <QDebug>
#include <QDir>
#include <QStandardPaths>

FavoriteHosts::FavoriteHosts(QObject *parent) : QObject(parent)
{
    connect(this, &FavoriteHosts::favoritesChanged, this, [=]() {
        qDebug() << this->m_favorites;
    });
    const QString fileDir =
            QStandardPaths::writableLocation(QStandardPaths::DataLocation)
            + QDir::separator();
    {
        QDir favoritesDir(fileDir);
        if (!favoritesDir.exists(fileDir)) {
            favoritesDir.mkpath(fileDir);
        }
    }
    const QString filePath = fileDir + "favorites.txt";
    qWarning() << "file path" << filePath;
    this->m_favFile = new QFile(filePath, this);
    readFromFile();
}

void FavoriteHosts::readFromFile()
{
    if (this->m_favFile->isOpen())
        this->m_favFile->close();

    const bool open = this->m_favFile->open(QFile::ReadOnly);
    if (!open) {
        qWarning() << "Failed to open favorites in ReadOnly";
        return;
    }

    QTextStream readStream(this->m_favFile);
    while (!readStream.atEnd()) {
        const QString ip_str = readStream.readLine();
        if (ip_str.isEmpty())
            continue;

        QVariantMap host;
        host.insert("ip_str", ip_str);
        this->m_favorites.push_back(host);
    }

    this->m_favFile->close();
    emit favoritesChanged();
}

void FavoriteHosts::writeToFile()
{
    if (this->m_favFile->isOpen())
        this->m_favFile->close();

    const bool open = this->m_favFile->open(QFile::ReadWrite);
    if (!open) {
        qWarning() << "Failed to open favorites in ReadWrite mode";
        return;
    }

    QTextStream fileStream(this->m_favFile);
    for (QVariant value : this->m_favorites) {
        QVariantMap host = value.toMap();
        const QString ip_str = host.value("ip_str").toString();
        if (ip_str.isEmpty())
            continue;

        fileStream << ip_str << endl;
    }
    this->m_favFile->close();
}

QVariantList FavoriteHosts::favorites()
{
    return this->m_favorites;
}

void FavoriteHosts::add(const QString& ip)
{
    if (contains(ip)) {
        qInfo() << "IP address" << ip << "already in the favorites";
        return;
    }

    QVariantMap host;
    host.insert("ip_str", ip);
    this->m_favorites.push_back(host);
    writeToFile();
    emit favoritesChanged();
}

void FavoriteHosts::remove(const QString& ip)
{
    if (!contains(ip)) {
        qWarning() << "IP address" << ip << "not in the favorites";
        return;
    }

    QVariantList newFavorites;
    for (QVariant value : this->m_favorites) {
        const QVariantMap host = value.toMap();
        const QString ip_str = host.value("ip_str").toString();
        if (ip_str == ip)
            continue;

        newFavorites.push_back(host);
    }

    this->m_favorites = newFavorites;
    writeToFile();
    emit favoritesChanged();
}

bool FavoriteHosts::contains(const QString& ip) {
    for (QVariant host : this->m_favorites) {
        QVariantMap hostMap = host.toMap();
        if (!hostMap.contains("ip_str")) {
            continue;
        }

        if (hostMap.value("ip_str") == ip) {
            return true;
        }
    }
    return false;
}
