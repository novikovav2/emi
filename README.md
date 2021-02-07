# Электронная модель инфраструктуры
Как обычно планов много, но для начала пробуем сделать кабельный журнал

## Для запуска надо:
- ruby: 2.6.6
- rails: 6.0.3.3
- MySQL
- Neo4j 4.0

### Переменные окружения
- MYSQL_USER 
- MYSQL_PASS
- MYSQL_HOST
- NEO4J_URL
- NEO4J_USER
- NEO4J_PASS

## Установка на Heroku:
- heroku buildpacks:add --index 1 heroku-community/apt --app YOUR_APPLICATION
- heroku buildpacks:add  heroku-community/ruby --app YOUR_APPLICATION
- heroku buildpacks:add  heroku-community/nodejs --app YOUR_APPLICATION
- heroku buildpacks --app YOUR_APPLICATION - Проверяем, что все builpack на месте
- Создаем в корне файл Aptfile и кладем в него содержимое:
  https://github.com/neo4j-drivers/seabolt/releases/download/v1.7.4/seabolt-1.7.4-Linux-ubuntu-18.04.deb
- Создаем переменную окружения LD_LIBRARY_PATH=./.apt/usr/local/lib