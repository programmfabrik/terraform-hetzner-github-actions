#!/bin/sh

packages="$@"

# exit early if command reached exit-code != 0
set -e

get_user() {
	user="$(id -un 2>/dev/null || true)"
}

get_distribution() {
	lsb_dist=""
	# Every system that we officially support has /etc/os-release
	if [ -r /etc/os-release ]; then
		lsb_dist="$(. /etc/os-release && echo "$ID")"
	fi
	# Returning an empty string here should be alright since the
	# case statements don't act unless you provide an actual value
	echo "$lsb_dist"
}

command_exists() {
	command -v "$@" > /dev/null 2>&1
}

install_packages() {
    # identify currentl shell and check whether we have the necessary permissions to install packages
    sh_c='sh -c'
	if [ "$user" != 'root' ]; then
		if command_exists sudo; then
			sh_c='sudo -E sh -c'
		elif command_exists su; then
			sh_c='su -c'
		else
			cat >&2 <<-'EOF'
			Error: this installer needs the ability to run commands as root.
			We are unable to find either "sudo" or "su" available to make this happen.
			EOF
			exit 1
		fi
	fi

    case "$lsb_dist" in
		ubuntu|debian|raspbian)
			$sh_c 'apt-get update -qq >/dev/null'
            $sh_c "DEBIAN_FRONTEND=noninteractive apt-get install -y -qq $packages >/dev/null"
		;;
		centos|fedora|rhel)
			if [ "$lsb_dist" = "fedora" ]; then
				pkg_manager="dnf"
			else
				pkg_manager="yum"
			fi
            $sh_c "$pkg_manager install -y -q $packages"
		;;
        *)
			echo "Unsupported distro [ $lsb_dist ]"
			exit 1
		;;
	esac
}

# identify the user we are running with
get_user
# set necessary variables to identify the distro we are running on
get_distribution

echo "Installing packages: $packages"
install_packages
