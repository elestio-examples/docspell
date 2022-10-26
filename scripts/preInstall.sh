set env vars
set -o allexport; source .env; set +o allexport;


mkdir -p -m 750 ./data
mkdir -p -m 750 ./docs
mkdir -p -m 750 ./docspell-postgres_data
mkdir -p -m 750 ./docspell-solr_data

chown -R 1000:1000 ./data
chown -R 1000:1000 ./docs
chown -R 1000:1000 ./docspell-postgres_data
chown -R 1000:1000 ./docspell-solr_data
