# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac


##############################################################################
# COLORS
##############################################################################

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;
esac

# uncomment for a colored prompt, if the terminal has the capability
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

##############################################################################
# END COLORS
##############################################################################


# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

function setups
{
	SYSCONF=`pwd`
	export PATH=$SYSCONF/bin:$SYSCONF/sbin:$PATH
	export MANPATH=$SYSCONF/share/man:$MANPATH
	source ../slurm/contribs/slurm_completion_help/slurm_completion.sh
	export SLURM_CONF=$SYSCONF/etc/slurm.conf
	export SACCT_FORMAT="cluster,jobid,jobname%20,state,exitcode,submit,start,end,elapsed,eligible"
	export SPRIO_FORMAT="%.15i %9r %.10Y %.10S %.10A %.10B %.10F %.10J %.10P %.10Q %30T"
}
export -f setups

# My tools directory contains some useful scripts.
export PATH=/home/marshall/tools:$PATH

# ccache - will replace all clang/gcc calls with the ccache ones.
export PATH=/usr/lib/ccache:$PATH

# Slurm installation paths in environment variables so it's easier to use them.
#export SLURM_1808="/home/marshall/slurm-local/18.08/install"
#export SLURM_1905="/home/marshall/slurm-local/19.05/install"
#export SLURM_MASTER="/home/marshall/slurm-local/master/install"

def_mpi_path="/home/marshall/mpi/openmpi/version_sym/install/bin"
function load_openmpi()
{
	if [ ! -d "${def_mpi_path}" ]; then
		echo "Did not find openmpi: ${def_mpi_path}"
		return 1
	fi
	# Clear the existing mpi path from the PATH
	# Trick learned from https://unix.stackexchange.com/a/496050/244332
	export PATH=`echo $PATH | tr ":" "\n" | grep -v "mpi" | tr "\n" ":"`
	# Point this to whichever version of mpi I want to use.
	#export PATH=/home/marshall/mpi/openmpi/4.0.7/install/bin:$PATH
	#export PATH=/home/marshall/mpi/openmpi/5.0.x/install/bin:$PATH
	export PATH="${def_mpi_path}:$PATH"
	# Part of my configure line was --enable-mpirun-prefix-by-default.
	# Without that, I would need to export LD_LIBRARY_PATH=$prefix/lib.
}

function load_intelmpi()
{
	intelmpi_path="/home/marshall/intel/oneapi/mpi/latest/bin"
	if [ ! -d "${intelmpi_path}" ]; then
		echo "Did not find intelmpi: ${intelmpi_path}"
		return 1
	fi
	# Clear the existing mpi path from the PATH
	# Trick learned from https://unix.stackexchange.com/a/496050/244332
	export PATH=`echo $PATH | tr ":" "\n" | grep -v "mpi" | tr "\n" ":"`
	export PATH="${intelmpi_path}:$PATH"
}

# Use openmpi by default
if [ -d "${def_mpi_path}" ]; then
	load_openmpi
fi

function chpwd()
{
	if [ -f ../slurm/contribs/slurm_completion_help/slurm_completion.sh ]
	then
		source ../slurm/contribs/slurm_completion_help/slurm_completion.sh
	fi
}

function cd()
{
	builtin cd $@
	chpwd
}
# Now cd to the current directory to force the custom cd function to happen
# when a new shell is created.
cd .

# Hook direnv to bash
eval "$(direnv hook bash)"

# Port forward the port for jenkins testsuite in the office to my
# localhost port 8080.
# The old command was:
# alias knl2-web='ssh -p 22253 marshall@lehi.schedmd.com -L 8080:192.168.1.252:80'
# I modified it since we moved jenkins it has a new ip address.
# To use it, first run this command (jenkins-web).
# Then go to http://localhost:8080/qa/
alias jenkins-web='echo "Open http://localhost:8080/qa/ in a browser after ssh connects to smd-server."; ssh smd-server -L 8080:192.168.1.211:80;'

function rest()
{
	local OPTIND d h p r s u v
	local data data_file port request url unix_sock usage verbose

	usage=\
"Usage: rest -r request_type -u url_endpoint <-p host:port | -s /path/to/slurmrestd/unix/socket> [-d data_file]

-r, -u, and one of -p or -s are required.

-r request_type - GET, POST, etc.
-u url_endpoint - path to end point
-p host:port - host and port where slurmrestd is listening. This is mutually exclusive with -s.
-s - path to the slurmrestd unix socket. This is mutually exclusive with -p.
-d data_file - if set, add --data-binary @<data_file> to the curl command

Examples:
rest -r GET -p localhost:8080 -u slurm/v0.0.40/jobs
rest -r POST -p localhost:8080 -u slurm/v0.0.40/job/submit -d /path/to/job/submission.json
rest -r GET -s \$(pwd)/slurmrestd.sock -u slurm/v0.0.40/diag
# Generate the openapi spec
rest -r GET -s \$(pwd)/slurmrestd.sock -u openapi
"
	# Example job submission json file:
	#{
	#	"job":
	#	{
	#		"account": "acct1",
	#		"argv": [],
	#		"cpus_per_task": 1,
	#		"current_working_directory": "/home/marshall/slurm/23.11/install/c1",
	#		"environment":["PATH=/bin:/usr/bin/:/usr/local/bin/:/home/marshall/slurm/23.11/install/c1/bin"],
	#		"memory_per_node": { "set": true , "number" : 128 },
	#		"name":"restd-test",
	#		"partition": "debug",
	#		"time_limit": { "set" : true , "number" : 100 }
	#	},
	#	"script":"#!/bin/sh\n sleep 60"
	#}

	# How to use getopts in a bash function:
	# https://stackoverflow.com/a/16655341/4880288
	while getopts 'd:hp:r:s:u:v' flag
	do
		case "${flag}" in
			d) data_file="${OPTARG}" ;;
			h) echo "${usage}"; return 1 ;;
			p) port="${OPTARG}" ;;
			r) request="${OPTARG}" ;;
			s) unix_sock="${OPTARG}" ;;
			u) url="${OPTARG}" ;;
			v) verbose=1 ;;
		esac
	done
	shift $((OPTIND-1))

	if [ -n "${verbose}" ]
	then
		echo "type=${request} url=${url} port=${port} sock=${unix_sock} data=${data}"
	fi

	if [ -z "${request}" ] || [ -z "${url}" ]
	then
		echo "${usage}"
		return 1
	fi

	if [ -n "${unix_sock}" ] && [ -n "${port}" ]
	then
		echo "Cannot specify both unix socket and port"
		echo "${usage}"
		return 1
	elif [ -z "${unix_sock}" ] && [ -z "${port}" ]
	then
		echo "Must specify either unix socket or port"
		echo "${usage}"
		return 1
	fi

	if [ -n "${data_file}" ]
	then
		data="--data-binary @${data_file}"
	fi

	if [ -n "${verbose}" ]
	then
		set -x
	fi

	unset SLURM_JWT
	export $(scontrol token)

	if [ -n "${port}" ]
	then
		curl -k -s \
			--request "${request}" \
			${data} \
			-H X-SLURM-USER-NAME:$(whoami) \
			-H X-SLURM-USER-TOKEN:$SLURM_JWT \
			-H "Content-Type: application/json" \
			--url "${port}/${url}"
	else
		curl -k -s \
			--request "${request}" \
			${data} \
			-H X-SLURM-USER-NAME:$(whoami) \
			-H X-SLURM-USER-TOKEN:$SLURM_JWT \
			-H "Content-Type: application/json" \
			--unix-socket "${unix_sock}" \
			--url "http://local/${url}"
	fi

	if [ -n "${verbose}" ]
	then
		set +x
	fi
	unset SLURM_JWT
}

function run_slurmrestd()
{
	local slurmrestd=$(which slurmrestd)
	local OPTIND h usage help

	help=0
	usage=\
"
# Usage: run_slurmrestd [slurmrestd options]
# This function starts slurmrestd. It needs to be set in the path.
# See the slurmrestd man page for a full description of the options to
# slurmrestd.
# This function sets SLURMRESTD_SECURITY=disable_user_check and SLURM_JWT=1,
# automatically passes -a rest_auth/jwt,
# then passes all arguments directly to slurmrestd.
#
# Why -a rest_auth/jwt? Because loading all plugins doesn't work when slurmrestd
# is listening on a local unix socket.
#
# To start slurmrestd listening on port 8080 on all network interfaces:
# run_slurmrestd :8080
#
# To start slurmrestd listening on a local unix socket:
# run_slurmrestd unix:/path/to/socket/file
#
# I like to pass one or two v's to slurmrestd: -vv
"
	while getopts 'h' flag
	do
		case "${flag}" in
			h) echo "${usage}" ; help=1 ;;
		esac
	done

	if [ -z "${slurmrestd}" ]
	then
		echo "Cannot find slurmrestd. Add it to the path."
		return -1
	fi
	echo "Running slurmrestd: $(${slurmrestd} -V)"

	if [ ${help} -eq 1 ]
	then
		"${slurmrestd}" -h
		return
	fi
	set -x
	export SLURMRESTD_SECURITY=disable_user_check
	export SLURM_JWT=1
	"${slurmrestd}" -a rest_auth/jwt $@
	unset SLURM_JWT
	unset SLURMRESTD_SECURITY
	set +x
}

# This is a function instead of an alias because I want to get fancier with it
# like allow passing args to make.py but have make.py not be the last thing
# that this does. Here is the old alias:
#alias makepy="date && time make.py"
function makepy()
{
	# If there is a make.py in the current directory, use that.
	# Otherwise use the one in the path.
	if test -f "./make.py"; then
		m="$(pwd)/make.py"
	else
		m=$(which make.py)
	fi
	#echo "makepy=$m"
	date
	time $m $@
	alert
}
alias makej="make -j install>/dev/null"
alias maketags="find . -name \*.c -o -name \*.h -o -name slurm.h.in > cscope.files && ctags-exuberant -R && ctags -R --language-force=Tcl --append=yes testsuite/expect/* && cscope -i cscope.files -b && alert"
# maketags2 excludes Slurm-specific testsuite stuff. It can be used for any
# directory I create that is just .c and .h files.
alias maketags2='find . -name \*.c -o -name \*.h > cscope.files && ctags-exuberant -R && cscope -i cscope.files -b'
alias stop_slurm='/home/marshall/tools/stop_slurm.sh'
alias start_slurmd='/home/marshall/tools/start_slurm.sh'
alias cleanbuild='/home/marshall/tools/cleanbuild.sh'
alias drainednodes="sinfo --state=drain --noheader --Format=nodelist"
alias downednodes="sinfo --state=down --noheader --Format=nodelist"

# git aliases
alias gpl="git pull"
alias gck="git checkout"
alias gckm="git checkout master"
alias glg="git log"
alias glgo="git log --oneline --graph"
alias gst="git status"
alias gdf="git diff"

# Attach a timestamp to commands
export HISTTIMEFORMAT="%y-%m-%d %T "

# Make less more :)
# See https://stackoverflow.com/questions/16828/how-do-you-do-a-case-insensitive-search-using-a-pattern-modifier-using-less/26069#26069
# -R Maintains ANSI color sequences.
# -I sets case-insensitive searches.
# -i sets smart-casing searches: if all search letters are lower case, then the
# search is case-insensitive. If any letter is capitalized, then the search is
# case-sensitive.
# Start less with +F (or press SHIFT+F while in less) to cause it to follow the
# file I've opened - very useful for following logs. This is a nice alternative
# to tail -f.
# I can also use the .lesskey file instead of .bashrc.
#export LESS="-Ri --use-color"
export LESS="-Ri"


##############################################################################
# Address Sanitizer environment variables.
##############################################################################
# References:
# https://stackoverflow.com/q/45997178/4880288
# https://github.com/google/sanitizers/wiki/SanitizerCommonFlags
#
# The following are values for ASAN_OPTIONS. Separate them with a colon ':'
# * detect_odr_violation=0
#   Disable Address Sanitizer's One Definition Rule. The way Slurm uses plugins
#   means that we redefine variables in the plugins so they can be used when a
#   plugin is linked by something other than slurmctld. When a plugin is linked
#   by slurmctld, the variables used will be the ones defined by slurmctld, not
#   the plugin.
#
# * abort_on_error=1
#   This enables address sanitizer to produce a core dump of the application
#   when it errors.
#
# * unmap_shadow_on_exit=1
#   This means address sanitizer's memory won't be in the core dump.
#
# * disable_coredump=0
#   On 64-bit systems, disable_coredump=1 is the default because address
#   sanitizer reserves a lot of virtual memory and could dump a 16T+ core file
#   (see the link above for SanitizerCommonFlags).
#export ASAN_OPTIONS='detect_odr_violation=0:abort_on_error=1:disable_coredump=0:unmap_shadow_on_exit=1'

# Terraform autocomplete - installed by following these instructions:
# https://learn.hashicorp.com/tutorials/terraform/install-cli?in=terraform/gcp-get-started
complete -C /usr/bin/terraform terraform
