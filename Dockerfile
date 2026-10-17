FROM debian:trixie

RUN apt-get update && apt-get install -y build-essential curl ca-certificates patch perl libssl-dev libexpat1-dev libpq-dev libxml2-dev libxslt1-dev libgd-dev graphviz

WORKDIR /app
ENV PERL_MM_USE_DEFAULT=1
RUN curl -fsSL https://download.bestpractical.com/pub/rt/release/rt-6.0.3.tar.gz | tar -xz --strip-components=1
RUN curl -fsSL https://github.com/bestpractical/rt/commit/525547751b76cc422015960bae3056f4e8d4351f.patch | patch -p1
RUN ./configure --with-db-type=Pg --with-web-handler=standalone && make fixdeps && make install
EXPOSE 8080

CMD ["/opt/rt6/sbin/rt-server", "--port", "8080"]