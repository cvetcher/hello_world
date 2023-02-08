#!/bin/sh

log() {
	echo "$*" >&2
}

die() {
	[ -n "$1" ] && log "$1"
	exit ${2:-1}
}

e() {
	local _e_command="$*"
	"$@"
	local _e_status=$?
	[ $_e_status -eq 0 ] && return
	die "For: $_e_command" "$_e_status"
}

if [ $# -lt 2 ]; then
	die "\
Usage: $0 docker_repo git_ref [docker_build_options...]

KEEP_DOCKERFILE=${KEEP_DOCKERFILE}
"
fi

docker_repo=$1
git_ref=$2
shift 2

dir=`pwd`



# try tag
if [ -n "$(git tag -l $git_ref)" ]; then
	build_ref=$git_ref
	git_ref=$(git rev-parse --short "$git_ref")
else
	if [ -n "$(git branch --list $git_ref 2>/dev/null)" ]; then
	        commit=$(git rev-parse --short "$git_ref" 2>/dev/null)
	        build_ref="local/$git_ref-$commit"
	        git_ref=$commit
	elif [ -n "$(git branch -a --list $git_ref 2>/dev/null)" ]; then
	        commit=$(git rev-parse --short "$git_ref" 2>/dev/null)
	        build_ref="$git_ref-$commit"
	        git_ref=$commit
	else
	        commit=$(git rev-parse --short "$git_ref" 2>/dev/null)
	        [ -n "$commit" ] || die "cannot resolve git_ref $git_ref"
	        build_ref=$commit
	fi
fi

cd "$dir"

docker_tag=$(echo "$build_ref" | sed -e 's#/#--#g')

e docker build -t "$docker_repo:$docker_tag" -f Dockerfile --build-arg git_ref="$git_ref" --build-arg build_ref="$build_ref" "$@" 1>&2 .

echo "$docker_tag"
