# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

USE_RUBY="ruby25 ruby26 ruby27 ruby30"

RUBY_FAKEGEM_EXTRAINSTALL="data"

RUBY_FAKEGEM_BINWRAP=""

inherit ruby-fakegem

DESCRIPTION="Parse and decompose a domain name into top level domain, domain and subdomains"
HOMEPAGE="https://simonecarletti.com/code/publicsuffix-ruby/"

KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~ppc ppc64 ~riscv ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x64-solaris ~x86-solaris"
LICENSE="MIT"
SLOT="$(ver_cut 1)"
IUSE=""

ruby_add_bdepend "test? ( dev-ruby/mocha:1.0 )"

all_ruby_prepare() {
	sed -i -e '/rubocop/I s:^:#:' \
		-e '/yardoc/,/CLOBBER.include/ s:^:#:' \
		-e '/bundler/ s:^:#:' Rakefile || die
	sed -i -e '/reporters/I s:^:#:' test/test_helper.rb || die
}
