#!/bin/zsh

set -e
set -u
set -o pipefail

readonly SCRIPT_DIR="${0:A:h}"
readonly DEPENDENCY_DIR="${SCRIPT_DIR}/.macos-build-dependencies"
readonly FIXER_SCRIPT="${SCRIPT_DIR}/tools/macos_build/fix_xcode_project.rb"
readonly XCODEPROJ_VERSION="1.27.0"

pause_after_error() {
    local exit_code=$?
    if (( exit_code != 0 )); then
        echo
        echo "The macOS build fixer stopped with an error."
        if [[ -t 0 ]]; then
            read -r "?Press Return to close this window..."
        fi
    fi
    exit "${exit_code}"
}

trap pause_after_error EXIT

if [[ ! -f "${FIXER_SCRIPT}" ]]; then
    echo "Missing fixer script: ${FIXER_SCRIPT}" >&2
    exit 1
fi

if [[ ! -x /usr/bin/ruby ]] || [[ ! -x /usr/bin/gem ]]; then
    echo "This fixer needs the Ruby included with this version of macOS." >&2
    echo "Ruby was not found at /usr/bin/ruby." >&2
    exit 1
fi

mkdir -p "${DEPENDENCY_DIR}"

readonly DEFAULT_GEM_PATH="$(/usr/bin/ruby -rrubygems -e 'print Gem.default_path.join(":")')"
export GEM_HOME="${DEPENDENCY_DIR}"
export GEM_PATH="${DEPENDENCY_DIR}:${DEFAULT_GEM_PATH}"
export GEM_SPEC_CACHE="${DEPENDENCY_DIR}/spec-cache"
export NBS_XCODEPROJ_VERSION="${XCODEPROJ_VERSION}"

if ! /usr/bin/ruby -rrubygems -e 'gem "xcodeproj", ENV.fetch("NBS_XCODEPROJ_VERSION"); require "xcodeproj"' >/dev/null 2>&1; then
    echo "First run: installing xcodeproj ${XCODEPROJ_VERSION} locally..."
    echo "The installed files stay in .macos-build-dependencies and are ignored by Git."
    echo

    /usr/bin/gem install xcodeproj \
        --version "${XCODEPROJ_VERSION}" \
        --install-dir "${DEPENDENCY_DIR}" \
        --no-document

    echo
fi

/usr/bin/ruby "${FIXER_SCRIPT}" "$@"

trap - EXIT
