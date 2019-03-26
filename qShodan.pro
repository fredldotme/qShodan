TEMPLATE = subdirs
SUBDIRS += src

contains(CONFIG,click) {
    SUBDIRS += click
}
