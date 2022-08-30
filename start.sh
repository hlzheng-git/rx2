#!/bin/sh

# configs
AUUID=5aaed9b7-7fe3-47c3-bb52-db59859ce198
CADDYIndexPage=https://github.com/PavelDoGreat/WebGL-Fluid-Simulation/archive/master.zip
CONFIGCADDY=https://raw.githubusercontent.com/test/test/master/etc/Caddyfile
CONFIGX=https://raw.githubusercontent.com/test/test/master/etc/x.json
ParameterSSENCYPT=chacha20-ietf-poly1305
X_Newv=`wget --no-check-certificate -qO- https://api.github.com/repos/XTLS/X-core/tags | grep 'name' | cut -d\" -f4 | head -1 | cut -b 2-`

#PORT=4433
mkdir -p /etc/caddy/ /usr/share/caddy && echo -e "User-agent: *\nDisallow: /" >/usr/share/caddy/robots.txt
wget $CADDYIndexPage -O /usr/share/caddy/index.html && unzip -qo /usr/share/caddy/index.html -d /usr/share/caddy/ && mv /usr/share/caddy/*/* /usr/share/caddy/
wget -qO- $CONFIGCADDY | sed -e "1c :$PORT" -e "s/\$AUUID/$AUUID/g" -e "s/\$MYUUID-HASH/$(caddy hash-password --plaintext $AUUID)/g" >/etc/caddy/Caddyfile
wget -qO- $CONFIGX | sed -e "s/\$AUUID/$AUUID/g" -e "s/\$ParameterSSENCYPT/$ParameterSSENCYPT/g" >/x.json

# storefiles
mkdir -p /usr/share/caddy/$AUUID
wget -P /usr/share/caddy/$AUUID https://github.com/XTLS/Xray-core/releases/download/v$X_Newv/X-linux-64.zip


for file in $(ls /usr/share/caddy/$AUUID); do
    [[ "$file" != "StoreFiles" ]] && echo \<a href=\""$file"\" download\>$file\<\/a\>\<br\> >>/usr/share/caddy/$AUUID/ClickToDownloadStoreFiles.html
done

# start
tor &

/x -config /x.json &

caddy run --config /etc/caddy/Caddyfile --adapter caddyfile
