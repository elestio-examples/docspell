#set env vars
set -o allexport; source .env; set +o allexport;

#wait until the server is ready
echo "Waiting for software to be ready ..."
sleep 40s;

target=$(docker-compose port restserver 7880)

curl http://$target/api/v1/open/signup/register \
  -H 'User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/106.0.0.0 Safari/537.36' \
  -H 'Content-Type: application/json' \
  --data-raw '{"collectiveName":"root","login":"root","password":"'"$ADMIN_PASSWORD"'","invite":null}' \
  --compressed


  jwt=$(curl http://$target/api/v1/open/auth/login \
  -H 'Referer: https://docspell2-u353.vm.elestio.app/app/login?r=/app/item/6XcBB5zgrWg-JUUS6MZFXv4-Ez5FsN7XpKa-i9HBw44iyZQ&openid=0' \
  -H 'User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/106.0.0.0 Safari/537.36' \
  -H 'Content-Type: application/json' \
  --data-raw '{"account":"root","password":"'"${ADMIN_PASSWORD}"'","rememberMe":true}' \
  --compressed)

  echo "jwt " $jwt

  token=$(echo $jwt | jq -r '.token' )

 echo "token " $token


  curl http://$target/api/v1/sec/email/settings/smtp \
  -H 'Content-Type: application/json' \
  -H 'User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/106.0.0.0 Safari/537.36' \
  -H 'X-Docspell-Auth: '"${token}"'' \
  -H 'sec-ch-ua-platform: "macOS"' \
  --data-raw '{"name":"rootmail","smtpHost":"'"${EMAIL_HOST}"'","smtpPort":"'"${EMAIL_PORT}"'","smtpUser":"'"${EMAIL_HOST_USER}"'","smtpPassword":"'"${EMAIL_HOST_PASSWORD}"'","from":"'"${DEFAULT_FROM_EMAIL}"'","replyTo":null,"sslType":"none","ignoreCertificates":true}' \
  --compressed