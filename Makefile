PKG := package
ID  := com.mmaheriniaina.calendar

.PHONY: run install upgrade uninstall reload

run:
	plasmoidviewer -a $(PKG)

install:
	kpackagetool6 --type Plasma/Applet --install $(PKG)

upgrade:
	kpackagetool6 --type Plasma/Applet --upgrade $(PKG)

uninstall:
	kpackagetool6 --type Plasma/Applet --remove $(ID)

reload:
	kquitapp6 plasmashell; kstart plasmashell
