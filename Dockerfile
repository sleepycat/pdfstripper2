# Run with -t:
# docker run -p=4000:4000 -t mikewilliamson/pdfstripper
#
FROM mikewilliamson/archlinux

ENV PORT 4000
ENV MIX_ENV prod
ENV PATH /usr/bin:/usr/sbin
# Elixir expects utf8
ENV LANG en_US.UTF-8

RUN pacman -S --noconfirm reflector
RUN reflector --country 'United States' -l 10 -p https --sort rate --save /etc/pacman.d/mirrorlist
RUN pacman -Syu --noconfirm
RUN pacman -S --noconfirm ghostscript file

RUN groupadd elixir
RUN useradd -m -g elixir -s /usr/bin/nologin elixir

RUN mkdir -p /home/elixir/pdfstripper2
COPY ./rel/pdfstripper2/ /home/elixir/pdfstripper2/
RUN chown -R elixir:elixir /home/elixir/pdfstripper2

EXPOSE 4000
USER elixir
CMD ["/home/elixir/pdfstripper2/bin/pdfstripper2", "foreground"]
