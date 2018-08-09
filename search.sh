#!/usr/bin/env bash

error() {
    echo
    echo "Error: $@"
    echo "Usage: ./search.sh [-i] [-v] PATH QUERY"
    exit 1
}

linux() {
    [ $1 ] || error "No location or search query"
    [ $2 ] || error "No search query"

    while [ "$1" == "-i" -o "$1" == "-v" -o "$1" == "-vi" -o "$1" == "-iv" ]; do
        ARGS="$ARGS $1"
        shift
    done

    [[ ${1:0:1} == "-" ]] && error "Unknown option $1"

    [[ $ARGS = *"i"* ]] && FLAGS="i"

    DIRECTORY="$1"
    shift
    
    test -d "$DIRECTORY" 2>/dev/null || error "This directory does not exist or you do not have access rights"

    # Case sensitivity
    QUERY=$(echo $@ |
        sed 's/[[:blank:]]\[case\][[:blank:]]//g' |
        sed 's/\[case\][[:blank:]]//g' |
        sed 's/[[:blank:]]\[case\]//g' |
        sed 's/\[case\]//g')

    # ORs
    QUERY=$(echo "$QUERY" |
        sed 's/[[:blank:]]\[or\][[:blank:]]/\|/g' |
        sed 's/\[or\][[:blank:]]/\|/g' |
        sed 's/[[:blank:]]\[or\]/\|/g' |
        sed 's/\[or\]/\|/g')

    RESULTS=$(egrep -rn $(echo $ARGS) "$DIRECTORY" -e "$QUERY" |
        sed 's/:/\n/' |
        awk '!x[$0]++' |
        sed 's/[[:blank:]][[:blank:]]*/ /g' |
        sed 's/:/:\ /')

    echo -e "$(echo "$RESULTS" | cut -c 1-$(( $(tput cols) - 10 )) |

        sed 's/^\([0-9]\):/\1:     /' |
        sed 's/^\([0-9]\)\([0-9]\):/\1\2:    /' |
        sed 's/^\([0-9]\)\([0-9]\)\([0-9]\):/\1\2\3:   /' |
        sed 's/^\([0-9]\)\([0-9]\)\([0-9]\)\([0-9]\):/\1\2\3\4:  /' |
        sed 's/^\([0-9]\)\([0-9]\)\([0-9]\)\([0-9]\)\([0-9]\):/\1\2\3\4\5: /' |

        sed '/^[0-9][0-9]*/s/^/      /' |
        grep -v "Binary file.*matches" |
        eval $(echo sed \-\e\ \'\s\/"$QUERY"\/\\\\\e\\\[\4\m"$QUERY"\\\\\e\\\[\0\m\/\g"$FLAGS"\' \2\>\/\d\e\v\/\n\u\l\l ))"

    # Count of results
    FOUND=$(echo "$RESULTS" | grep -c '^[0-9][0-9]*:')
    if [ $FOUND -gt 0 ]; then
        echo -e "\n$FOUND found"
    else
        echo "Nothing found"
    fi
}

solaris() {
    [ $1 ] || error "No location or search query"
    [ $2 ] || error "No search query"

    while [ "$1" == "-i" -o "$1" == "-v" -o "$1" == "-vi" -o "$1" == "-iv" ]; do
        ARGS="$ARGS $1"
        shift
    done

    [[ ${1:0:1} == "-" ]] && error "Unknown option $1"

    [[ $ARGS = *"i"* ]] && FLAGS="i"

    DIRECTORY="$1"
    shift

    test -d "$DIRECTORY" 2>/dev/null || error "This directory does not exist or you do not have access rights"

    # Case sensitivity
    QUERY=$(gecho $@ |
        gsed 's/[[:blank:]]\[case\][[:blank:]]//g' |
        gsed 's/\[case\][[:blank:]]//g' |
        gsed 's/[[:blank:]]\[case\]//g' |
        gsed 's/\[case\]//g')

    # ORs
    QUERY=$(gecho "$QUERY" |
        gsed 's/[[:blank:]]\[or\][[:blank:]]/\|/g' |
        gsed 's/\[or\][[:blank:]]/\|/g' |
        gsed 's/[[:blank:]]\[or\]/\|/g' |
        gsed 's/\[or\]/\|/g')

    RESULTS=$(gegrep -rn $(echo $ARGS) "$DIRECTORY" -e "$QUERY" |
        gsed 's/:/\n/' |
        gawk '!x[$0]++' |
        gsed 's/[[:blank:]][[:blank:]]*/ /g' |
        gsed 's/:/:\ /')

    gecho -e "$(gecho "$RESULTS" | gcut -c 1-$(( $(tput cols) - 10 )) |

        gsed 's/^\([0-9]\):/\1:     /' |
        gsed 's/^\([0-9]\)\([0-9]\):/\1\2:    /' |
        gsed 's/^\([0-9]\)\([0-9]\)\([0-9]\):/\1\2\3:   /' |
        gsed 's/^\([0-9]\)\([0-9]\)\([0-9]\)\([0-9]\):/\1\2\3\4:  /' |
        gsed 's/^\([0-9]\)\([0-9]\)\([0-9]\)\([0-9]\)\([0-9]\):/\1\2\3\4\5: /' |

        gsed '/^[0-9][0-9]*/s/^/      /' |
        ggrep -v "Binary file.*matches" |
        eval $(gecho gsed \-\e\ \'\s\/"$QUERY"\/\\\\\e\\\[\4\m"$QUERY"\\\\\e\\\[\0\m\/\g"$FLAGS"\' \2\>\/\d\e\v\/\n\u\l\l ))"

    # Count of results
    FOUND=$(gecho "$RESULTS" | ggrep -c '^[0-9][0-9]*:')
    if [ $FOUND -gt 0 ]; then
        gecho -e "\n$FOUND found"
    else
        gecho "Nothing found"
    fi
}

if [ $(uname) == "SunOS" ]; then
    solaris "$@"
else
    linux "$@"
fi
