pkg_origin=core
pkg_name=icu
pkg_version=57.2
pkg_description="$(cat << EOF
  ICU is a mature, widely used set of C/C++ and Java libraries providing
  Unicode and Globalization support for software applications. ICU is widely
  portable and gives applications the same results on all platforms and
  between C/C++ and Java software.
EOF
)"
pkg_maintainer="The Habitat Maintainers <humans@habitat.sh>"
pkg_license=("Unicode-TOU")
# shellcheck disable=SC2059
pkg_source="https://github.com/unicode-org/icu/releases/download/release-${pkg_version//./-}/icu4c-${pkg_version//./_}-src.tgz"
pkg_shasum=d67a16e4b97173bab0e58a8b4a010c2a149fce20e0735d9c351570262a7c8172
pkg_upstream_url="http://site.icu-project.org/"
pkg_deps=(core/glibc core/gcc-libs)
pkg_build_deps=(core/gcc core/make)
pkg_bin_dirs=(bin)
pkg_include_dirs=(include)
pkg_lib_dirs=(lib)
pkg_dirname=icu/source
