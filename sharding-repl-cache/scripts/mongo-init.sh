#!/bin/bash

# Инициализируем сервер конфигурации
docker-compose exec -T configSrv mongosh --port 27017 --quiet <<EOF
rs.initiate({_id : "config_server", configsvr: true, members: [{ _id : 0, host : "configSrv:27017" }]});
exit();
EOF

# Инициализируем первый шард    
docker-compose exec -T shard10 mongosh --port 27010 --quiet <<EOF
rs.initiate({_id: "shard1", members: [{_id: 0, host: "shard10:27010"}, {_id: 1, host: "shard11:27011"}, {_id: 2, host: "shard12:27012"}]}) 
EOF

# Инициализируем второй шард
docker-compose exec -T shard20 mongosh --port 27030 --quiet <<EOF
rs.initiate({_id: "shard2", members: [{_id: 0, host: "shard20:27030"}, {_id: 1, host: "shard21:27031"}, {_id: 2, host: "shard22:27032"}]})
EOF

# Инициализируем роутер и наполняем его тестовыми данными
docker-compose exec -T mongos_router mongosh --port 27020 --quiet <<EOF

sh.addShard("shard1/shard10:27010");
sh.addShard("shard2/shard20:27030");

sh.enableSharding("somedb");
sh.shardCollection("somedb.helloDoc", { "name" : "hashed" } )

use somedb

db.helloDoc.deleteMany({})

for(var i = 0; i < 1000; i++) db.helloDoc.insertOne({age:i, name:"ly"+i})

db.helloDoc.countDocuments()
exit();
EOF