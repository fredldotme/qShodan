function getTitle(service) {
    // HTTP(S)
    if (service.http !== undefined && service.http !== null) {
        if (service.http.title)
            return service.http.title
    }
    // SSH
    else if (service.ssh !== undefined && service.ssh !== null) {
        if (service.ssh.fingerprint)
            return service.ssh.fingerprint
    }
    // FTP
    else if (service.ftp !== undefined && service.ftp !== null) {
        return "FTP server"
    }
    // Print for adding support later on
    // Only do this with debug versions
    else {
        // console.log(JSON.stringify(service))
    }

    return service.ip_str
}

function getType(service) {
    // HTTP
    if (service.http !== undefined && service.http !== null) {
        return "HTTP"
    }
    // SSH
    else if (service.ssh !== undefined && service.ssh !== null) {
        return "SSH"
    }
    // SSH
    else if (service.ftp !== undefined && service.ftp !== null) {
        return "FTP"
    }

    return "Unknown"
}

function getAddress(service) {
    if (service.ip_str !== undefined && service.port !== undefined)
        return service.ip_str + ":" + service.port;

    return "Unknown"
}

function getInfo(service) {
    var info = {
        "type" : getType(service),
        "title" : getTitle(service),
        "address" : getAddress(service),
        "org" : service.org,
        "location" : service.location,
        "data" : service.data
    }

    return info;
}
