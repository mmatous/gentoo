# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby26 ruby27 ruby30"

# NOTE: this package contains precompiled code. It appears that all
# source code can be found at https://code.google.com/p/selenium/ but the
# repository is not organized in a way so that we can easily rebuild the
# suited shared object. We'll just try our luck with the precompiled
# objects for now.

RUBY_FAKEGEM_RECIPE_DOC="none"
RUBY_FAKEGEM_EXTRADOC="CHANGES README.md"

RUBY_FAKEGEM_TASK_TEST=""

RUBY_FAKEGEM_GEMSPEC="selenium-webdriver.gemspec"

RUBY_QA_ALLOWED_LIBS="x_ignore_nofocus.so"
QA_PREBUILT="*/x_ignore_nofocus.so"

inherit ruby-fakegem

DESCRIPTION="This gem provides Ruby bindings for WebDriver"
HOMEPAGE="https://github.com/seleniumhq/selenium"

LICENSE="Apache-2.0"
SLOT="$(ver_cut 1)"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~riscv ~x86"
IUSE=""

ruby_add_rdepend ">=dev-ruby/childprocess-0.5:2
	>=dev-ruby/rexml-3.2.5:3
	>=dev-ruby/rubyzip-1.2.2:*"
