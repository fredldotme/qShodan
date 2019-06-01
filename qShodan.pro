TEMPLATE = subdirs

contains(CONFIG,click) {
    SUBDIRS += click
}

SUBDIRS += src
