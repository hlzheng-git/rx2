FROM alpine:edge

RUN apk update && \
    apk add --no-cache ca-certificates caddy tor wget && \
    	`wget --no-check-certificate -qO- https://api.github.com/repos/hlzheng-git/rx2/blob/main/etc/x.json` && \
	X_Newv=`wget --no-check-certificate -qO- https://api.github.com/repos/hlzheng-git/rx2/blob/main/etc/x.json | grep 'name' | cut -d\" -f4 | head -1 | cut -b 2-` && \
    wget -qO x.zip https://github.com/hlzheng-git/X-core/releases/download/v$X_Newv/X-linux-64.zip && \
    busybox unzip x.zip && \
    chmod +x /x && \
    rm -rf /var/cache/apk/*

ADD start.sh /start.sh
RUN chmod +x /start.sh

CMD /start.sh
