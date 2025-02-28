# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="Library to parse, pretty print, and evaluate CUDF documents"
HOMEPAGE="http://www.mancoosi.org/cudf/"
SRC_URI="https://gforge.inria.fr/frs/download.php/file/36602/${P}.tar.gz"

LICENSE="LGPL-3"
SLOT="0/${PV}"
KEYWORDS="amd64 arm arm64 ~ppc ppc64 x86"
IUSE="+ocamlopt llvm-libunwind test"
RESTRICT="!test? ( test )"

RDEPEND="
	>=dev-lang/ocaml-3.12:=[ocamlopt?]
	dev-ml/extlib:=
	dev-ml/findlib:=
	dev-libs/glib:2
	llvm-libunwind? ( sys-libs/llvm-libunwind:= )
	!llvm-libunwind? ( sys-libs/libunwind:= )
	sys-libs/ncurses:=
"
DEPEND="${RDEPEND}
	test? ( dev-ml/ounit2 )
	dev-ml/ocamlbuild
	dev-lang/perl
"
BDEPEND="virtual/pkgconfig"

PATCHES=( "${FILESDIR}/ounit2.patch" )

QA_FLAGS_IGNORED='.*'

src_prepare() {
	default

	sed -i \
		-e 's|make|$(MAKE)|g' \
		Makefile || die
	sed -i \
		-e 's|-lncurses|$(shell ${PKG_CONFIG} --libs ncurses glib-2.0) -lunwind|g' \
		-e "s|ar r|$(tc-getAR) r|g" \
		c-lib/Makefile || die
	sed -i \
		-e 's|-lcurses|$(shell ${PKG_CONFIG} --libs ncurses glib-2.0) -lunwind|g' \
		c-lib/Makefile.variants || die

	tc-export CC PKG_CONFIG

	sed -i \
		-e "s|-lncurses|$( $(tc-getPKG_CONFIG) --libs ncurses)|g" \
		c-lib/cudf.pc.in || die
}

src_compile() {
	emake OCAMLBUILD="ocamlbuild -classic-display" -j1 all
	emake OCAMLBUILD="ocamlbuild -classic-display" c-lib
	if use ocamlopt ; then
		emake OCAMLBUILD="ocamlbuild -classic-display" -j1 opt
		emake OCAMLBUILD="ocamlbuild -classic-display" c-lib-opt
	fi
}

src_test() {
	emake OCAMLBUILD="ocamlbuild -classic-display" test
	emake OCAMLBUILD="ocamlbuild -classic-display" c-lib-test
}

src_install() {
	emake DESTDIR="${ED}" LIBDIR="/usr/$(get_libdir)" install
	dodoc BUGS ChangeLog README TODO
}
