# Задание 2 (pymongo-api & mongo-sharding)

## Как запустить

Заходим в папку mongo-sharding

```shell
cd mongo-sharding
```

Запускаем приложение и mongodb с двумя шардами

```shell
docker compose up -d
```

Инициализируем сервер конфигурации, шарды и роутер, и заполняем mongodb данными

```shell
./scripts/mongo-init.sh
```

## Как проверить

### Если вы запускаете проект на локальной машине

Откройте в браузере http://localhost:8080

## Доступные эндпоинты

Список доступных эндпоинтов, swagger http://<ip виртуальной машины>:8080/docs