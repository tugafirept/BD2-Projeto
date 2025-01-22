db.createCollection("avaliacoes");

db.avaliacoes.createIndex({ id_utilizador: 1 }); // Índice para consultas por utilizador
db.avaliacoes.createIndex({ id_evento: 1 }); // Índice para consultas por evento


db.createCollection("comentarios");

db.comentarios.createIndex({ id_utilizador: 1 }); // Índice para consultas por utilizador
db.comentarios.createIndex({ id_evento: 1 }); // Índice para consultas por evento


db.createUser(
  {
    user: "bd2admin",
    pwd: "bd2admin",
    roles: [ { role: "readWrite", db: "BD2_PROJETO" } ]
  }
)