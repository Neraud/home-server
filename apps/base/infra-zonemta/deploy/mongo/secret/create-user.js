db.createUser(
  {
    user: "zonemta",
    pwd: "changeme",
    roles: [ { role: "readWrite", db: "zonemta" } ]
  }
)
