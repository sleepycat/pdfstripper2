# Run with -t:
# docker run -p=4000:4000 -t mikewilliamson/pdfstripper
#
FROM gliderlabs/alpine:3.3

ENV PORT 4000
ENV MIX_ENV dev
# Elixir expects utf8
ENV LANG en_US.UTF-8

RUN apk add -U git=2.6.4-r0 erlang-crypto=18.1-r5 elixir=1.1.1-r0 ghostscript-fonts=8.11-r1 ghostscript=9.18-r0 file=5.25-r0  && rm -rf /var/cache/apk/*

RUN addgroup -S elixir
RUN adduser -S elixir -G elixir

RUN mkdir -p /home/elixir/pdfstripper
COPY ./ /home/elixir/pdfstripper
RUN chown -R elixir:elixir /home/elixir
WORKDIR /home/elixir/pdfstripper
USER elixir
RUN yes | mix local.hex && mix deps.get

EXPOSE 4000
CMD mix phoenix.server
