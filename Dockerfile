FROM alpine:edge

RUN apk update && \
    apk add --no-cache ca-certificates caddy tor wget && \
	X_Newv=`wget --no-check-certificate -qO- https://github.com/hlzheng-git/X-core/tags | grep 'name' | cut -d\" -f4 | head -1 | cut -b 2-` && \
    wget -qO x.zip https://github.com/XTLS/Xray-core/releases/download/v$X_Newv/Xray-linux-64.zip && \
    busybox unzip x.zip && \
    chmod +x /x && \
    rm -rf /var/cache/apk/*

ADD start.sh /start.sh
RUN chmod +x /start.sh

CMD /start.sh
