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
    // Print for adding support later on
    else {
        console.log(JSON.stringify(obj))
    }

    return qsTr("Untitled")
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
        "data" : service.data
    }

    return info;
}
