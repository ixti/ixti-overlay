# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CRATES="
	adler-1.0.2
	ansi_term-0.12.1
	assert_cmd-2.0.2
	atty-0.2.14
	autocfg-1.0.1
	base64-0.13.0
	bitflags-1.3.2
	bstr-0.2.17
	bumpalo-3.8.0
	cast-0.2.7
	cc-1.0.72
	cfg-if-1.0.0
	chunked_transfer-1.4.0
	clap-2.34.0
	colored-2.0.0
	crc32fast-1.3.0
	criterion-0.3.5
	criterion-plot-0.4.4
	crossbeam-channel-0.5.1
	crossbeam-deque-0.8.1
	crossbeam-epoch-0.9.5
	crossbeam-utils-0.8.5
	csv-1.1.6
	csv-core-0.1.10
	difflib-0.4.0
	doc-comment-0.3.3
	dunce-1.0.2
	either-1.6.1
	filedescriptor-0.8.1
	flate2-1.0.22
	form_urlencoded-1.0.1
	gag-1.0.0
	getrandom-0.2.3
	half-1.8.2
	hermit-abi-0.1.19
	idna-0.2.3
	itertools-0.10.3
	itoa-0.4.8
	itoa-1.0.1
	js-sys-0.3.55
	lazy_static-1.4.0
	libc-0.2.112
	log-0.4.14
	matches-0.1.9
	memchr-2.4.1
	memoffset-0.6.5
	miniz_oxide-0.4.4
	num-traits-0.2.14
	num_cpus-1.13.1
	once_cell-1.9.0
	oorandom-11.1.3
	percent-encoding-2.1.0
	plotters-0.3.1
	plotters-backend-0.3.2
	plotters-svg-0.3.1
	ppv-lite86-0.2.16
	predicates-2.1.0
	predicates-core-1.0.2
	predicates-tree-1.0.4
	proc-macro2-1.0.36
	quote-1.0.14
	rand-0.8.4
	rand_chacha-0.3.1
	rand_core-0.6.3
	rand_hc-0.3.1
	rayon-1.5.1
	rayon-core-1.9.1
	redox_syscall-0.2.10
	regex-1.5.4
	regex-automata-0.1.10
	regex-syntax-0.6.25
	remove_dir_all-0.5.3
	ring-0.16.20
	rustc_version-0.4.0
	rustls-0.20.2
	ryu-1.0.9
	same-file-1.0.6
	scopeguard-1.1.0
	sct-0.7.0
	semver-1.0.4
	serde-1.0.133
	serde_cbor-0.11.2
	serde_derive-1.0.133
	serde_json-1.0.74
	spin-0.5.2
	strsim-0.8.0
	syn-1.0.84
	tempfile-3.2.0
	termtree-0.2.3
	textwrap-0.11.0
	thiserror-1.0.30
	thiserror-impl-1.0.30
	tinytemplate-1.2.1
	tinyvec-1.5.1
	tinyvec_macros-0.1.0
	unicode-bidi-0.3.7
	unicode-normalization-0.1.19
	unicode-width-0.1.9
	unicode-xid-0.2.2
	untrusted-0.7.1
	update-informer-0.2.0
	ureq-2.4.0
	url-2.2.2
	vec_map-0.8.2
	wait-timeout-0.2.0
	walkdir-2.3.2
	wasi-0.10.2+wasi-snapshot-preview1
	wasm-bindgen-0.2.78
	wasm-bindgen-backend-0.2.78
	wasm-bindgen-macro-0.2.78
	wasm-bindgen-macro-support-0.2.78
	wasm-bindgen-shared-0.2.78
	web-sys-0.3.55
	webpki-0.22.0
	webpki-roots-0.22.2
	winapi-0.3.9
	winapi-i686-pc-windows-gnu-0.4.0
	winapi-util-0.1.5
	winapi-x86_64-pc-windows-gnu-0.4.0
"

inherit cargo

DESCRIPTION="Lightning-fast linter for .env files"
HOMEPAGE="https://dotenv-linter.github.io https://github.com/dotenv-linter/dotenv-linter"
SRC_URI="
	$(cargo_crate_uris)
	https://github.com/dotenv-linter/dotenv-linter/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz
"

LICENSE="Apache-2.0 CC0-1.0 ISC MIT MPL-2.0"
SLOT="0"
KEYWORDS="~amd64"

QA_FLAGS_IGNORED="usr/bin/${PN}"

src_install() {
	cargo_src_install
	dodoc CHANGELOG.md README.md
}
