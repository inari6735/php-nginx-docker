# php-nginx-docker
Aplikacja PHP oparta na serwerze nginx

Uruchamianie aplikacji w trybie developmentu<br>
<code>docker compose up --build</code>

Uruchamianie aplikacje w trybie produkcyjnym<br>
<code>docker compose -f docker-compose.yml -f docker-compose.prod.yml up -d</code>