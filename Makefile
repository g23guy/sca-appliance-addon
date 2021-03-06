OBSPACKAGE=sca-appliance-overlay
VERSION='1.0.6'
SRCDIR=$(OBSPACKAGE)-$(VERSION)
OVERLAY_FILE=$(OBSPACKAGE)-$(VERSION).tar.gz

default: overlay

overlay: install
	@echo overlay: Creating overlay tar ball
	@cd $(SRCDIR); tar zcf ../$(OVERLAY_FILE) *
	@echo; ls -l $$LS_OPTIONS; echo

install: uninstall
	@echo install: Creating overlay file directory structure
	@install -d -m 755 -o root -g root \
		$(SRCDIR)/etc/apache2/vhosts.d \
		$(SRCDIR)/etc/init.d \
		$(SRCDIR)/etc/sysconfig \
		$(SRCDIR)/srv/ftp \
		$(SRCDIR)/usr/lib/systemd/system
	@install -d -m 766 -o ftp -g ftp \
		$(SRCDIR)/srv/ftp/upload
	@install -d -m 700 -o root -g root \
		$(SRCDIR)/root
	@echo install: Installing files
	@install -m 600 -o root -g root overlay/vsftpd.conf $(SRCDIR)/etc/ 
	@install -m 644 -o root -g root overlay/bash.bashrc.local $(SRCDIR)/etc/
	@install -m 644 -o root -g root overlay/apache2 $(SRCDIR)/etc/sysconfig/
	@install -m 644 -o root -g root overlay/after-local.service $(SRCDIR)/usr/lib/systemd/system/
	@install -m 544 -o root -g root overlay/after.local $(SRCDIR)/etc/init.d/
	@install -m 644 -o root -g root overlay/sca.conf $(SRCDIR)/etc/apache2/vhosts.d/
	@install -m 644 -o root -g root \
		overlay/.first_boot_sca \
		overlay/.last_boot_sca \
		$(SRCDIR)/root/

uninstall:
	@echo uninstall: Uninstalling overlay file directory structure
	@rm -rf $(SRCDIR)

clean: uninstall
	@echo clean: Cleaning up make files
	@rm -f $(OBSPACKAGE)*
	@echo; ls -l $$LS_OPTIONS; echo

help:
	@clear
	@make -v
	@echo
	@echo Make options for file overlay: $(OBSPACKAGE)
	@echo make {overlay[default], install, uninstall, clean}
	@echo; ls -l $$LS_OPTIONS; echo

