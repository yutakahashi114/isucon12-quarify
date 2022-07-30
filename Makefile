NGINX_LOG:=/var/log/nginx/access.log
SLOW_QUERY_LOG:=/var/log/mysql/mysql-slow.log
GENERAL_LOG:=/var/log/mysql/general.log
UNIT_NAME:=isuports.service
PROJECT_ROOT:=/home/isucon/webapp
APP_ROOT:=$(PROJECT_ROOT)/go

DB_HOST:=127.0.0.1
DB_PORT:=3306
DB_USER:=isucon
DB_PASS:=isucon
DB_NAME:=isuports

MYSQL_CMD:=mysql -h$(DB_HOST) -P$(DB_PORT) -u$(DB_USER) -p$(DB_PASS) $(DB_NAME)

.PHONY: db
db:
	$(MYSQL_CMD)

.PHONY: dbt
dbt:
	$(MYSQL_CMD) -e"select table_name, table_rows from information_schema.TABLES where table_schema = database();"

.PHONY: log
log:
	sudo journalctl -f -u $(UNIT_NAME)

.PHONY: dep
dep:
	cd $(APP_ROOT)

	git checkout .
	git fetch
	git switch main
	git pull --rebase origin main

	sudo cp $(PROJECT_ROOT)/settings/nginx/nginx.conf /etc/nginx/nginx.conf
	sudo cp $(PROJECT_ROOT)/settings/nginx/isuports.conf /etc/nginx/sites-available/isuports.conf

	sudo cp $(PROJECT_ROOT)/settings/mysql/mysqld.cnf /etc/mysql/mysql.conf.d/mysqld.cnf

	sudo systemctl daemon-reload
	sudo systemctl restart nginx
	sudo systemctl restart mysql
	sudo systemctl restart $(UNIT_NAME)

	sudo truncate $(NGINX_LOG) --size 0
	sudo truncate $(SLOW_QUERY_LOG) --size 0
	sudo truncate $(GENERAL_LOG) --size 0

.PHONY: push
push:
	git add . && git commit -m "profile" && git push origin main

.PHONY: ka
ka:
	sudo cat /var/log/nginx/access.log | kataribe -f $(PROJECT_ROOT)/settings/nginx/kataribe.toml

.PHONY: setup
setup:
	sudo apt install -y dstat git unzip
	wget https://github.com/matsuu/kataribe/releases/download/v0.4.3/kataribe-v0.4.3_linux_amd64.zip -O kataribe.zip
	unzip -o kataribe.zip
	sudo mv kataribe /usr/local/bin/
	sudo chmod +x /usr/local/bin/kataribe
	rm kataribe.zip