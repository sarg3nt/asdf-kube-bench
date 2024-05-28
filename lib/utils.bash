#!/usr/bin/env bash

set -euo pipefail

# TODO: Ensure this is the correct GitHub homepage where releases can be downloaded for kube-bench.
GH_REPO="https://github.com/aquasecurity/kube-bench"
TOOL_NAME="kube-bench"
TOOL_TEST="kube-bench version"

fail() {
	echo -e "asdf-$TOOL_NAME: $*"
	exit 1
}

curl_opts=(-fsSL)

# NOTE: You might want to remove this if kube-bench is not hosted on GitHub releases.
if [ -n "${GITHUB_API_TOKEN:-}" ]; then
	curl_opts=("${curl_opts[@]}" -H "Authorization: token $GITHUB_API_TOKEN")
fi

sort_versions() {
	sed 'h; s/[+-]/./g; s/.p\([[:digit:]]\)/.z\1/; s/$/.z/; G; s/\n/ /' |
		LC_ALL=C sort -t. -k 1,1 -k 2,2n -k 3,3n -k 4,4n -k 5,5n | awk '{print $2}'
}

list_github_tags() {
	git ls-remote --tags --refs "$GH_REPO" |
		grep -o 'refs/tags/.*' | cut -d/ -f3- |
		sed 's/^v//' # NOTE: You might want to adapt this sed to remove non-version strings from tags
}

list_all_versions() {
	# TODO: Adapt this. By default we simply list the tag names from GitHub releases.
	# Change this function if kube-bench has other means of determining installable versions.
	list_github_tags
}

get_platform() {
	local -r kernel="$(uname -s)"
	if [[ ${kernel} == "Darwin" ]]; then
		echo macos
	else
		uname | tr '[:upper:]' '[:lower:]'
	fi
}

get_arch() {
	local -r machine="$(uname -m)"
	if [[ ${machine} == "arm64" ]] || [[ ${machine} == "aarch64" ]]; then
		echo "arm64"
	elif [[ ${machine} == "arm" ]]; then
		echo "armv7"
	elif [[ ${machine} == *"armv"* ]] || [[ ${machine} == *"aarch"* ]]; then
		echo "arm6"
	else
		echo "amd64"
	fi
}

download_release() {
	local version filename url
	version="$1"
	filename="$2"
	local -r platform="$(get_platform)"
	local -r arch="$(get_arch)"
	# kube-bench_0.7.3_linux_amd64.tar.gz 
	# kube-bench_0.7.3_linux_arm64.tar.gz 
	# kube-bench_0.7.3_linux_armv6.tar.gz
	# kube-bench_0.7.3_linux_armv7.tar.gz
	# kube-bench_0.7.3_darwin_arm64.tar.gz 
	# kube-bench_0.7.3_darwin_amd64.tar.gz 
	# https://github.com/aquasecurity/kube-bench/releases/download/v0.7.3/kube-bench_0.7.3_linux_armv7.tar.gz

	# TODO: Adapt the release URL convention for kube-bench
	url="$GH_REPO/releases/download/v${version}kube-bench_${version}_${platform}_${arch}.tar.gz"
	echo "* URL: ${url}"

	echo "* Downloading $TOOL_NAME release $version..."
	curl "${curl_opts[@]}" -o "$filename" -C - "$url" || fail "Could not download $url"
}

install_version() {
	local install_type="$1"
	local version="$2"
	local install_path="${3%/bin}/bin"

	if [ "$install_type" != "version" ]; then
		fail "asdf-$TOOL_NAME supports release installs only"
	fi

	(
		mkdir -p "$install_path"
		cp -r "$ASDF_DOWNLOAD_PATH"/* "$install_path"

		# TODO: Assert kube-bench executable exists.
		local tool_cmd
		tool_cmd="$(echo "$TOOL_TEST" | cut -d' ' -f1)"
		test -x "$install_path/$tool_cmd" || fail "Expected $install_path/$tool_cmd to be executable."

		echo "$TOOL_NAME $version installation was successful!"
	) || (
		rm -rf "$install_path"
		fail "An error occurred while installing $TOOL_NAME $version."
	)
}
