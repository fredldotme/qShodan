function getTitle(obj) {
    // HTTP(S)
    if (obj.http !== undefined && obj.http !== null) {
        if (obj.http.title)
            return obj.http.title
    }
    // SSH
    else if (obj.ssh !== undefined && obj.ssh !== null) {
        if (obj.ssh.fingerprint)
            return obj.ssh.fingerprint
    }
    // Print for adding support later on
    else {
        console.log(JSON.stringify(obj))
    }

    return qsTr("Untitled")
}

function getInfo(service) {
    var info = {
        "title" : "",
        "address" : "",
    }
}
