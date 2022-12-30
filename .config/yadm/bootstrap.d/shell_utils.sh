BLACK_CODE=0
RED_CODE=1
GREEN_CODE=2
YELLOW_CODE=3
BLUE_CODE=4
MAGENTA_CODE=5
CYAN_CODE=6
WHITE_CODE=7

RS=$(tput sgr0) # reset
BOLD=$(tput bold)
UL=$(tput smul) # underline
BLINK=$(tput blink) # blink
INV=$(tput rev) # inverse background and foreground
STANDOUT=$(tput smso) # standout mode

declare -ar COLOR_NAMES=( "BLACK" "RED" "GREEN" "YELLOW" "BLUE" "WHITE" "CYAN" "MAGENTA" )

declare -i LOG_NESTING_LEVEL=0

for c in "${COLOR_NAMES[@]}"; do
    color_code_name="${c}_CODE"
    color_code=${!color_code_name}
    declare -r ${c}=$(tput setaf $color_code)
    declare -r ${c}_BG=$(tput setab $color_code)
done

get_indent(){
    printf " "
    for ((i=0; i < $LOG_NESTING_LEVEL; ++i)); do
        printf "\t"
    done
}

increase_indent() {
    LOG_NESTING_LEVEL=$((LOG_NESTING_LEVEL+1))
}

decrease_indent() {
    LOG_NESTING_LEVEL=$((LOG_NESTING_LEVEL-1))
}

print_stderr() {
    echo "$@${RS}" >&2
}

ok () {
    print_stderr "${BOLD}${GREEN}[ OK ]${RS}$(get_indent)${@}"
}

inf(){
    print_stderr "${BOLD}${CYAN}[INFO]${RS}$(get_indent)${@}"
}

warn(){
    print_stderr "${BOLD}${YELLOW}[WARN]${RS}$(get_indent)${@}"
}

err() {
    print_stderr "${BOLD}${RED_BG}[ERROR]${RS}$(get_indent)${RED}${@}"
}

export -f ok inf warn err increase_indent decrease_indent
