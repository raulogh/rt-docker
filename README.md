# DEPRECATED NOTICE
The application requires a mail system already provided within OS (which in this case it is not)
Needs more work in order to be able to finish the quick setup page
For now you cannot run the docker image at all, it is unusable in this state.

# How to run
1. create new container:

```
docker run -d -p 8080:8080 -v rt_config:/opt/rt6/etc ghcr.io/raulogh/rt-docker:latest
#              ^            ^                        ^  Docker Image
#              ^            ^  Volume for storaging the RT's data (Configs for DB connection etc.)
#              ^  Port for the web app
```


Another alternative for volume:

```
-v ./RT_SiteConfig.pm::/path/to/your_host_file.pm
```

Configs:

    1. go to /opt/rt6/etc (where you have placed the docker bind/volume)
    2. open RT_SiteConfig.pm
    3. Add the following lines:

```
Set($rtname, "your.domain.slash.ip")

Set($WebDomain, 'your.domain.slash.ip'); # Without port, just domain / ip you are using
Set($WebPort, 443); # <- end port (after reverse proxy / port exposure)
Set($WebSecureCookies, 1);

Set($CanonicalizeRedirectURLs, 1);
Set($CanonicalizeURLsInFeeds, 1);

# Eventually you could also setup the database:

Set($DatabaseType, 'MariaDB'); # This docker has been configured to be MariaDB specifically
Set($DatabaseHost, 'mariadb'); # localhost / ip / domain
Set($DatabasePort, 3306);
Set($DatabaseName, 'db_Name');
Set($DatabaseUser, 'db_Username');
Set($DatabasePassword, 'db_Password');
```

# Need to change to another database type?

    1. Fork this repo
    2. Edit in DockerFile:

at
```
RUN apt-get update && apt-get install -y build-essential curl ca-certificates patch perl cpanminus libssl-dev libexpat1-dev libmariadb-dev libmariadb-dev-compat libxml2-dev libxslt1-dev libgd-dev graphviz
```

Replace
```
libmariadb-dev
libmariadb-dev-compat
```
with
```
libpq-dev
```

```
RUN apt-get update && apt-get install -y build-essential curl ca-certificates patch perl cpanminus libssl-dev libexpat1-dev libpq-dev libxml2-dev libxslt1-dev libgd-dev graphviz
```

for PostgreSQL

then replace
```
RUN ./configure --with-db-type=MariaDB --with-web-handler=standalone && cpanm DBD::mysql@4.055 && make fixdeps && make testdeps && make install
```
with
```
RUN ./configure --with-db-type=Pg --with-web-handler=standalone && make fixdeps && make testdeps && make install
```
