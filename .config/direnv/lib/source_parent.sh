find_all_up() {
    local -a FILES=()
    local TARGET=${1:-.envrc}
    cd ..
    while true; do
        if [[ -f $TARGET ]]; then
            FILES+=("$PWD/$TARGET")
        fi
        if [[ $PWD == / ]] || [[ $PWD == // ]] || [[ $PWD == $HOME ]]; then
            break
        fi
        cd ..
    done

    printf '%s\n' "${FILES[@]}" | tac
}

source_all_up() {
    local UP_FILES=$(find_all_up "$@")

    for f in ${UP_FILES[@]}; do
        source_env $f
    done
}
