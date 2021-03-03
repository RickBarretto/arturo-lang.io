######################################################
# Arturo
# Programming Language + Bytecode VM compiler
# (c) 2019-2021 Yanis Zafirópulos
#
# @file: arturo-lang.io/installer/stable.sh
######################################################

################################################
# CONSTANTS
################################################

REPO="arturo"

################################################
# HELPERS
################################################

RED='\e[0;31m'
GREEN='\e[1;32m'
BLUE='\e[0;34m'
MAGENTA='\e[1;35m'
CYAN='\e[1;36m'
GRAY='\e[0;90m'
CLEAR='\e[0m'

printColorized() {
    NC='\e[0m'
    printf "${1}${2}${NC}"
}

panic() {
    printf "$@\n" >&2
    exit 1
}

print() {
    printf "${1}"
}

eecho() {
    printf "$1\n"
}

showHeader() {
    eecho "======================================"
    eecho "${GREEN}"
    eecho "               _                    "
    eecho "              | |                   "
    eecho "     __ _ _ __| |_ _   _ _ __ ___   "
    eecho "    / _\` | '__| __| | | | '__/ _ \ "
    eecho "   | (_| | |  | |_| |_| | | | (_) | "
    eecho "    \__,_|_|   \__|\__,_|_|  \___/  "
    eecho "                                    "
    eecho "${CLEAR}"
    printf "     \e[1mArturo"
    printf " Programming Language\e[0m\n"
    eecho "      (c)2021 Yanis Zafirópulos"
    eecho ""

    eecho "======================================"
    eecho " ► $1"
    eecho "======================================"
    printf "${CLEAR}"
}

showFooter(){
    eecho ""
    printf "${GRAY}"
    eecho " :---------------------------------------------------------"
    eecho " : Arturo has been successfully installed!"
    eecho " :"
    eecho " : To be able to run it,"
    eecho " : first make sure its in your \$PATH:"
    eecho " :"
    eecho " :    export PATH=$HOME/.arturo/bin:\$PATH"
    eecho " :"
    eecho " : and add it to your ${shellRcFile},"
    eecho " : so that it's set automatically every time."
    eecho " :"
    eecho " : Rock on! :)"
    eecho " :---------------------------------------------------------"
    printf "${CLEAR}"
    eecho ""
}

section(){
    eecho ""
    printf " ${MAGENTA}●${CLEAR} ${1}"
}

info(){
    eecho "   ${GRAY}${1}${CLEAR}"
}

create_directory() {
    if [ ! -d "$1" ]; then
        if ! mkdir -p "$1" 2>/dev/null; then
            panic "Cannot create directory: $1."
        fi
    fi
}

create_tmp_directory() {
    ARTURO_TMP_DIR="$(mktemp -d 2>/dev/null || mktemp -d -t art)"
}

cleanup_tmp_directory() {
    if [ -n "$ARTURO_TEMP_DIR" ] ; then
        rm -rf "$ARTURO_TEMP_DIR"
        ARTURO_TEMP_DIR=""
    fi
}

command_exists(){
    type "$1" &> /dev/null
}

animate_progress(){
    pid=$! # Process Id of the previous running command

    spin='-\|/'

    i=0
    printf "${CYAN}"
    while kill -0 $pid 2>/dev/null
    do
        i=$(( (i+1) %4 ))
        printf "\r ${spin:$i:1}"
        sleep .1
    done
    printf "\b\b\b\b     \x1B[A\x1B[A"
    printf "${CLEAR}"
}

##-----------------------------------------------

verifyOS(){
    case "$OSTYPE" in
        linux*)   currentOS="Linux" ;;
        darwin*)  currentOS="macOS" ;; 
        cygwin*)  currentOS="windows" ;;
        msys*)    currentOS="windows" ;;
        solaris*) currentOS="solaris" ;;
        freebsd*) currentOS="freebsd" ;;
        bsd*)     currentOS="bsd" ;;
        *)        currentOS="unknown" ;;
    esac

    info "os: $currentOS"
}

verifyShell(){
    case "$SHELL" in
        "/bin/zsh")     
            currentShell="zsh" ;
            shellRcFile="~/.zshrc" ;;
        "/bin/bash")    
            currentShell="bash" ;
            shellRcFile="~/.bashrc or ~/.profile" ;;
        "/bin/sh")      
            currentSheel="sh" ;
            shellRcFile="~/.profile" ;;
        *)              
            currentShell="unrecognized" ;
            shellRcFile="~/.profile" ;;
    esac

    info "shell: $currentShell"
}

install_prerequisites() {
    case "$(uname)" in
        "Linux")
            sudo apt-fast update
            sudo apt-fast install -yq libgtk-3-dev libwebkit2gtk-4.0-dev
            ;;
        *)
            ;;
    esac
}

get_download_url() {
    downloadUrl=$(curl -s https://api.github.com/repos/arturo-lang/$REPO/releases | grep "browser_download_url.*${1}" | cut -d : -f 2,3 | tr -d \" | head -1)
}

download_arturo() {
    create_tmp_directory
    get_download_url $currentOS
    curl -sSL $downloadUrl --output "$ARTURO_TMP_DIR/arturo.tar.gz"
    tar -zxf "$ARTURO_TMP_DIR/arturo.tar.gz" -C $ARTURO_TMP_DIR
}

install_arturo() {
    create_directory "~/.arturo"
    create_directory "~/.arturo/bin"
    create_directory "~/.arturo/lib"

    cp $ARTURO_TMP_DIR/arturo ~/.arturo/bin
}

################################################
# MAIN
################################################

main() {
    showHeader "Installer"

    section "Checking environment..."
    eecho ""
    verifyOS
    verifyShell

    if [ "$currentOS" = "Linux" ] || [ "$currentOS" = "macOS" ]; then
        section "Checking prerequisites..."
        install_prerequisites
        
        section "Downloading..."
        download_arturo

        section "Installing..."
        install_arturo

        section "Cleaning up..."
        cleanup_tmp_directory

        eecho ""

        section "Done!"
        eecho ""
        showFooter
    else
        panic "Cannot continue. Unfortunately your OS is not supported by this auto-installer."
    fi
}



#echo $downloadUrl

main