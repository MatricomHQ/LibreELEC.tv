# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2018-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="iwd"
PKG_VERSION="1.5"
PKG_SHA256="13d36dcec625ae8ef54e4be5fb0b65db598c68ab0b4d70ff6c557f7954d259aa"
PKG_LICENSE="GPL"
PKG_SITE="https://git.kernel.org/cgit/network/wireless/iwd.git/about/"
PKG_URL="https://www.kernel.org/pub/linux/network/wireless/iwd-${PKG_VERSION}.tar.xz"
PKG_DEPENDS_TARGET="toolchain readline dbus"
PKG_LONGDESC="Wireless daemon for Linux"
PKG_TOOLCHAIN="autotools"

PKG_CONFIGURE_OPTS_TARGET="--enable-client \
                           --enable-monitor \
                           --enable-systemd-service \
                           --enable-dbus-policy \
                           --disable-docs"

pre_configure_target() {
  export LIBS="-lncurses"
}

post_makeinstall_target() {
  # ProtectSystem et al seems to break the service when systemd isn't built with seccomp.
  # investigate this more as it might be a systemd problem or kernel problem
  sed -e 's|^\(PrivateTmp=.*\)$|#\1|g' \
      -e 's|^\(NoNewPrivileges=.*\)$|#\1|g' \
      -e 's|^\(PrivateDevices=.*\)$|#\1|g' \
      -e 's|^\(ProtectHome=.*\)$|#\1|g' \
      -e 's|^\(ProtectSystem=.*\)$|#\1|g' \
      -e 's|^\(ReadWritePaths=.*\)$|#\1|g' \
      -e 's|^\(ProtectControlGroups=.*\)$|#\1|g' \
      -e 's|^\(ProtectKernelModules=.*\)$|#\1|g' \
      -i $INSTALL/usr/lib/systemd/system/iwd.service
}

post_install() {
  enable_service iwd.service
}

