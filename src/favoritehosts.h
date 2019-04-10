#ifndef FAVORITEHOSTS_H
#define FAVORITEHOSTS_H

#include <QObject>
#include <QFile>
#include <QString>
#include <QVariantList>

class FavoriteHosts : public QObject
{
    Q_OBJECT

public:
    Q_PROPERTY(QVariantList favorites READ favorites NOTIFY favoritesChanged)

    explicit FavoriteHosts(QObject *parent = nullptr);
    QVariantList favorites();

public slots:
    bool contains(const QString& ip);
    void add(const QString& ip, const QString& name = QStringLiteral(""));
    void rename(const QString& ip, const QString& name);
    void remove(const QString& ip);

private:
    void readFromFile();
    void writeToFile();

    QFile* m_favFile = nullptr;
    QVariantList m_favorites;

signals:
    void favoritesChanged();
};

#endif // FAVORITEHOSTS_H
