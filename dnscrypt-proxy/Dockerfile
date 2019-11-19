
FROM klutchell/dnscrypt-proxy:arm32v7-2.0.27
#FROM --platform=linux/arm/v6 klutchell/dnscrypt-proxy:2.0.31

#RUN mkdir /config
#COPY ./dnscrypt-proxy.toml /config/
#COPY ./dnscrypt-proxy.toml /app/example-dnscrypt-proxy.toml
COPY ./entrypoint.sh /

# Lower Output
#RUN sed -r "s/^(# )?log_level = .+$/log_level = 6/" -i /app/example-dnscrypt-proxy.toml
#RUN sed -r "s/^(# )?use_syslog = .+$/use_syslog = false/" -i /app/example-dnscrypt-proxy.toml