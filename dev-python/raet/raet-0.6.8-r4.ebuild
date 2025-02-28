# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..10} )
inherit distutils-r1

DESCRIPTION="Reliable Asynchronous Event Transport Protocol"
HOMEPAGE="https://github.com/RaetProtocol/raet"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND=">=dev-python/six-1.6.1[${PYTHON_USEDEP}]
	>=dev-python/libnacl-1.4.3[${PYTHON_USEDEP}]
	>=dev-python/ioflo-2.0[${PYTHON_USEDEP}]"
BDEPEND="${RDEPEND}
	test? (
		>=dev-python/msgpack-1.0.0[${PYTHON_USEDEP}]
	)"

PATCHES=(
	"${FILESDIR}/raet-0.6.8-msgpack-1.0.patch"
	"${FILESDIR}/raet-0.6.8-py310.patch"
)

python_prepare_all() {
	distutils-r1_python_prepare_all
	sed -e "/setuptools_git/d" -i setup.py || die
}

python_test() {
	pushd "${BUILD_DIR}"/lib || die
	${EPYTHON} ${PN}/test/__init__.py || die "tests failed for ${EPYTHON}"
	popd || die
}
