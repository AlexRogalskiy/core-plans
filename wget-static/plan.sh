pkg_name=wget-static
_distname="wget"
pkg_origin=core
pkg_version=1.19.5
pkg_maintainer="The Habitat Maintainers <humans@habitat.sh>"
pkg_dirname=${_distname}-${pkg_version}
pkg_description="\
GNU Wget is a free software package for retrieving files using HTTP, HTTPS, \
FTP and FTPS the most widely-used Internet protocols.\
"
pkg_upstream_url="https://www.gnu.org/software/wget/"
pkg_license=('GPL-3.0+')
pkg_source="https://ftp.gnu.org/gnu/${_distname}/${_distname}-${pkg_version}.tar.gz"
pkg_shasum="b39212abe1a73f2b28f4c6cb223c738559caac91d6e416a6d91d4b9d55c9faee"

pkg_build_deps=(
  core/linux-headers-musl
  core/musl
  core/coreutils
  core/diffutils
  core/flex
  core/gcc
  core/gettext
  core/grep
  core/make
  core/patch
  core/perl
  core/pkg-config
  core/sed
  core/cacerts
  core/glibc
  core/libidn2
  core/openssl
  core/pcre
  core/zlib
)
pkg_bin_dirs=(bin)

do_prepare() {
  CFLAGS="-I$(pkg_path_for linux-headers-musl)/include -I$(pkg_path_for musl)/include"
  build_line "Setting CFLAGS=$CFLAGS"

  LDFLAGS="-static $LDFLAGS"
  build_line "Setting LDFLAGS=$LDFLAGS"

  export CC=musl-gcc
  build_line "Setting CC=$CC"

  _wget_common_prepare
}

do_build() {
  ./configure \
    --prefix="$pkg_prefix" \
    --with-ssl=openssl \
    --without-libuuid
  make
}

do_install() {
  do_default_install

  cat <<EOF >> "$pkg_prefix/etc/wgetrc"

# Default root CA certs location
ca_certificate=$(pkg_path_for core/cacerts)/ssl/certs/cacert.pem
EOF
}

do_check() {
  PERL_MM_USE_DEFAULT=1 cpan HTTP:Daemon
  make check
}

_wget_common_prepare() {
  # Purge the codebase (mostly tests & build Perl scripts) of the hardcoded
  # reliance on `/usr/bin/env`.
  grep -lr '/usr/bin/env' . | while read -r f; do
    sed -e "s,/usr/bin/env,$(pkg_path_for coreutils)/bin/env,g" -i "$f"
  done
}
