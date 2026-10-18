FROM debian:trixie

RUN apt-get update && apt-get install -y build-essential curl ca-certificates patch perl cpanminus libssl-dev libexpat1-dev libmariadb-dev libmariadb-dev-compat libxml2-dev libxslt1-dev libgd-dev graphviz

WORKDIR /app
ENV PERL_MM_USE_DEFAULT=1
ENV RT_FIX_DEPS_CMD=/usr/bin/cpanm
RUN curl -fsSL https://download.bestpractical.com/pub/rt/release/rt-6.0.3.tar.gz | tar -xz --strip-components=1
RUN curl -fsSL https://github.com/bestpractical/rt/commit/525547751b76cc422015960bae3056f4e8d4351f.patch | patch -p1
RUN ./configure --with-db-type=MariaDB --with-web-handler=standalone && cpanm DBD::mysql@4.055 && make fixdeps && make testdeps && make install
EXPOSE 8080

CMD ["/opt/rt6/sbin/rt-server", "--port", "8080"]