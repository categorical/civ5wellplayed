#!/bin/bash
set -eu
_Err(){ printf '\e[31merr: \e[0m%s\n' "$(printf "$1" "${@:2}")">&2;exit 1;}

readonly dest="$(cygpath -O)/My Games/Sid Meier's Civilization 5/MODS"
readonly thisdir="$(cd "$(dirname "$0")"&&pwd)"
readonly p3='python'

# see: wellplayed/lang.xml
_patch(){
    local f
    f='/cygdrive/d/opt/steam_content/steamapps/common'
    f="$f/Sid Meier's Civilization V/Assets/Gameplay/XML/NewText/English.xml"

    read -d $'\0' <<EOF||:
import sys,xml.etree.ElementTree as a,re
b=a.fromstring(sys.stdin.read())
c=b.find('Languages')
for v in c.findall('Row'):
    if int(v.find('ID').text)==0:
        for u in [
            'UseExtendedFont',
            'FontName',
            'FontWidthScale',
            'FontHeightScale',]:
            if None!=(d:=v.find(u)):v.remove(d)
        for u,w in [
            ('UseExtendedFont','1'),
            ('FontWidthScale','0.38'),
            ]:
            if None==(d:=v.find(u)):
                d=a.SubElement(v,u)
            d.text=w
        break
a.indent(b)
f=a.tostring(b).decode('ascii')
g=re.sub(r'[ ]+(?=/>)','',f)
print(g)
EOF
    local content;content="$(tail -n+2 "$f"|"$p3" -c "$REPLY")"
    sed -i '1!d' "$f";echo "$content">>"$f"

    f="$(cygpath -O)/My Games/Sid Meier's Civilization 5/config.ini"
    sed -i 's/^\(DebugPanel =\).*$/\10/' "$f"   # 1 is on
    sed -i 's/^\(EnableTuner =\).*$/\10/' "$f"  # lua
}
_install(){
    [ -d "$dest" ]||(set -x;mkdir "$dest")
    local f
    f="$thisdir/Packages/Well Played (v 2).civ5mod"
    (set -x;install -m644 -t"$dest" "$f")
}
_remove(){ [ ! -d "$dest" ]||(set -x;rm -r "$dest");}
_main(){ _usage(){ cat<<-EOF
	$0 --patch --remove --install
	EOF
    exit $1;}
    [ $# -gt 0 ]||_usage 1;while [ $# -gt 0 ];do case $1 in
        --install)_install;;
        --remove)_remove;;
        --patch)_patch;;
        -h)_usage 0;;*)_usage 1
    esac;shift;done
};_main "$@"

# modbuddy
# --------
# install
#   steam:library:tools:civ5 sdk:modbuddy
#
#   either  a) install optical salon 2010
#       custom:c hash:install:restart now:popup
#   or      b) install optical salon 2010 isolated shell redownloadable
#       https://visualstudio.microsoft.com/vs/older-downloads/isolated-shell
#       https://my.visualstudio.com/downloads?q=isolated
#       en_visual_studio_2010_shell_isolated_x86_dvd_17fb9d03.iso
#       no:next:accept:next:custom:next:install:finish
#
# use
#   allow uac update
#   civ5 path "d:\opt\steam_content\steamapps\common\sid meier's civilization v"
#   user path "$(cygpath -wO)\my games\sid meier's civilization 5"
#
#   C-B build, it does:
#       1) overwrite "Build/Well Played"
#       2) add "Well Played (v 2)" to "MODS"
#       3) add archive "Well Played (v 2).civ5mod" to "Packages"
#
#   guide 69533-moddersguide.pdf

