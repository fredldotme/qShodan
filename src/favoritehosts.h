#ifndef FAVORITEHOSTS_H
#define FAVORITEHOSTS_H

#include <QObject>

class FavoriteHosts : public QObject
{
    Q_OBJECT
public:
    explicit FavoriteHosts(QObject *parent = nullptr);

signals:

public slots:
};

#endif // FAVORITEHOSTS_H