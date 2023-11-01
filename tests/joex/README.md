<a href="https://elest.io">
  <img src="https://elest.io/images/elestio.svg" alt="elest.io" width="150" height="75">
</a>

[![Discord](https://img.shields.io/static/v1.svg?logo=discord&color=f78A38&labelColor=083468&logoColor=ffffff&style=for-the-badge&label=Discord&message=community)](https://discord.gg/4T4JGaMYrD "Get instant assistance and engage in live discussions with both the community and team through our chat feature.")
[![Elestio examples](https://img.shields.io/static/v1.svg?logo=github&color=f78A38&labelColor=083468&logoColor=ffffff&style=for-the-badge&label=github&message=open%20source)](https://github.com/elestio-examples "Access the source code for all our repositories by viewing them.")
[![Blog](https://img.shields.io/static/v1.svg?color=f78A38&labelColor=083468&logoColor=ffffff&style=for-the-badge&label=elest.io&message=Blog)](https://blog.elest.io "Latest news about elestio, open source software, and DevOps techniques.")

# Docspell, verified and packaged by Elestio

[Docspell](https://github.com/eikek/docspell) is a personal document organizer. Or sometimes called a "Document Management System" (DMS). You'll need a scanner to convert your papers into files. 

<img src="https://raw.githubusercontent.com/elestio-examples/docspell/main/docspell.png" alt="docspell" width="800">

[![deploy](https://github.com/elestio-examples/docspell/raw/main/deploy-on-elestio.png)](https://dash.elest.io/deploy?source=cicd&social=dockerCompose&url=https://github.com/elestio-examples/docspell)

Deploy a <a target="_blank" href="https://elest.io/open-source/docspell">fully managed docspell</a> on <a target="_blank" href="https://elest.io/">elest.io</a> if you want automated backups, reverse proxy with SSL termination, firewall, automated OS & Software updates, and a team of Linux experts and open source enthusiasts to ensure your services are always safe, and functional.

# Why use Elestio images?

- Elestio stays in sync with updates from the original source and quickly releases new versions of this image through our automated processes.
- Elestio images provide timely access to the most recent bug fixes and features.
- Our team performs quality control checks to ensure the products we release meet our high standards.

# Usage

## Git clone

You can deploy it easily with the following command:

    git clone https://github.com/elestio-examples/docspell.git

Copy the .env file from tests folder to the project directory

    cp ./tests/.env ./.env

Edit the .env file with your own values.

Create data folders with correct permissions

    mkdir -p ./pgdata
    chown -R 1000:1000 ./pgdata

Run the project with the following command

    docker-compose up -d
    ./scripts/postInstall.sh

You can access the Web UI at: `http://your-domain:9880`

## Docker-compose

Here are some example snippets to help you get started creating a container.

        version: '3.8'
        services:

        restserver:
            image: elestio4test/docspell-restserver:${SOFTWARE_VERSION_TAG}
            restart: always
            ports:
            - "172.17.0.1:9880:7880"
            environment:
            - TZ=Europe/Berlin
            - DOCSPELL_SERVER_INTERNAL__URL=http://restserver:7880
            - DOCSPELL_SERVER_ADMIN__ENDPOINT_SECRET=${ADMIN__ENDPOINT_SECRET}
            - DOCSPELL_SERVER_AUTH_SERVER__SECRET=
            - DOCSPELL_SERVER_BACKEND_JDBC_PASSWORD=dbpass
            - DOCSPELL_SERVER_BACKEND_JDBC_URL=jdbc:postgresql://db:5432/dbname
            - DOCSPELL_SERVER_BACKEND_JDBC_USER=dbuser
            - DOCSPELL_SERVER_BIND_ADDRESS=0.0.0.0
            - DOCSPELL_SERVER_FULL__TEXT__SEARCH_ENABLED=true
            - DOCSPELL_SERVER_FULL__TEXT__SEARCH_SOLR_URL=http://solr:8983/solr/docspell
            - DOCSPELL_SERVER_INTEGRATION__ENDPOINT_ENABLED=true
            - DOCSPELL_SERVER_INTEGRATION__ENDPOINT_HTTP__HEADER_ENABLED=true
            - DOCSPELL_SERVER_INTEGRATION__ENDPOINT_HTTP__HEADER_HEADER__VALUE=${DOCSPELL_SERVER_INTEGRATION__ENDPOINT_HTTP__HEADER_HEADER}
            - DOCSPELL_SERVER_BACKEND_SIGNUP_MODE=open
            - DOCSPELL_SERVER_BACKEND_SIGNUP_NEW__INVITE__PASSWORD=
            - DOCSPELL_SERVER_BACKEND_ADDONS_ENABLED=false
            depends_on:
            - solr
            - db

        joex:
            image: elestio4test/docspell-joex:${SOFTWARE_VERSION_TAG}
            restart: always
            environment:
            - TZ=Europe/Berlin
            - DOCSPELL_JOEX_APP__ID=joex1
            - DOCSPELL_JOEX_PERIODIC__SCHEDULER_NAME=joex1
            - DOCSPELL_JOEX_SCHEDULER_NAME=joex1
            - DOCSPELL_JOEX_BASE__URL=http://joex:7878
            - DOCSPELL_JOEX_BIND_ADDRESS=0.0.0.0
            - DOCSPELL_JOEX_FULL__TEXT__SEARCH_ENABLED=true
            - DOCSPELL_JOEX_FULL__TEXT__SEARCH_SOLR_URL=http://solr:8983/solr/docspell
            - DOCSPELL_JOEX_JDBC_PASSWORD=dbpass
            - DOCSPELL_JOEX_JDBC_URL=jdbc:postgresql://db:5432/dbname
            - DOCSPELL_JOEX_JDBC_USER=dbuser
            - DOCSPELL_JOEX_ADDONS_EXECUTOR__CONFIG_RUNNER=docker,trivial
            ports:
            - "172.17.0.1:9878:7878"
            depends_on:
            - solr
            - db
        
        consumedir:
            image: elestio4test/docspell-dsc:${SOFTWARE_VERSION_TAG}
            command:
            - dsc
            - "-d"
            - "http://docspell-restserver:7880"
            - "watch"
            - "--delete"
            - "-ir"
            - "--not-matches"
            - "**/.*"
            - "--header"
            - "Docspell-Integration:${DOCSPELL_SERVER_INTEGRATION__ENDPOINT_HTTP__HEADER_HEADER}"
            - "/opt/docs"
            restart: always
            volumes:
            - ./docs:/opt/docs
            depends_on:
            - restserver

        db:
            image: postgres:14
            restart: always
            volumes:
            - ./docspell-postgres_data:/var/lib/postgresql/data/
            environment:
            - POSTGRES_USER=dbuser
            - POSTGRES_PASSWORD=dbpass
            - POSTGRES_DB=dbname

        solr:
            image: solr:9
            restart: always
            volumes:
            - ./docspell-solr_data:/var/solr
            command:
            - solr-precreate
            - docspell
            healthcheck:
            test: ["CMD", "curl", "-f", "http://localhost:8983/solr/docspell/admin/ping"]
            interval: 1m
            timeout: 10s
            retries: 2
            start_period: 30s


### Environment variables

|                            Variable                               |      Value (example)       |
| :---------------------------------------------------------------: | :------------------------: |
|    SOFTWARE_VERSION_TAG                                           |         latest             |
|    ADMIN_EMAIL                                                    |         your@email.com     |
|    ADMIN_PASSWORD                                                 |         your-password      |
|    ANYMAIL                                                        |         True               |
|    DEFAULT_FROM_EMAIL                                             |         your_domain        |
|    EMAIL_HOST                                                     |         your_domain        |
|    EMAIL_PORT                                                     |         25                 |
|    EMAIL_USE_TLS                                                  |         False              |
|    EMAIL_USE_SSL                                                  |         False              |
|    ADMIN__ENDPOINT_SECRET                                         |         your-secret        |
|    DOCSPELL_SERVER_INTEGRATION__ENDPOINT_HTTP__HEADER_HEADER      |         your-secret        |


# Maintenance

## Logging

The Elestio Docspell Docker image sends the container logs to stdout. To view the logs, you can use the following command:

    docker-compose logs -f

To stop the stack you can use the following command:

    docker-compose down

## Backup and Restore with Docker Compose

To make backup and restore operations easier, we are using folder volume mounts. You can simply stop your stack with docker-compose down, then backup all the files and subfolders in the folder near the docker-compose.yml file.

Creating a ZIP Archive
For example, if you want to create a ZIP archive, navigate to the folder where you have your docker-compose.yml file and use this command:

    zip -r myarchive.zip .

Restoring from ZIP Archive
To restore from a ZIP archive, unzip the archive into the original folder using the following command:

    unzip myarchive.zip -d /path/to/original/folder

Starting Your Stack
Once your backup is complete, you can start your stack again with the following command:

    docker-compose up -d

That's it! With these simple steps, you can easily backup and restore your data volumes using Docker Compose.

# Links

- <a target="_blank" href="https://docspell.org/docs/">Docspell documentation</a>

- <a target="_blank" href="https://github.com/eikek/docspell">Docspell Github repository</a>

- <a target="_blank" href="https://github.com/elestio-examples/docspell">Elestio/Docspell Github repository</a>
