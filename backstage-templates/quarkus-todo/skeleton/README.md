# ${{values.artifact_id}} Application with Quarkus

This is an example application based on a Todo list where the different tasks are created, read, updated, or deleted from the database. This application uses `postgresql` as a database and that is provided with Quarkus Dev Services. When running in a 
non-dev mode you will have to provide the database yourself. 

Addition description

${{values.description}}

## Development mode

```bash
mvn compile quarkus:dev
```
Then, open: http://localhost:8080/

## Compile and run on a JVM with PostgresSQL ( in a container )

```bash
mvn package
```
Run:
```bash
docker run --ulimit memlock=-1:-1 -it --rm=true --memory-swappiness=0 \
    --name postgres-quarkus-rest-http-crud \
    -e POSTGRES_USER=restcrud \
    -e POSTGRES_PASSWORD=restcrud \
    -e POSTGRES_DB=rest-crud \
    -p 5432:5432 postgres:10.5
java -jar target/todo-backend-1.0-SNAPSHOT-runner.jar
```

Then, open: http://localhost:8080/

## Compile to Native and run with PostgresSQL ( in a container )

Compile:
```bash
mvn clean package -Pnative
```
Run:
```bash
docker run --ulimit memlock=-1:-1 -it --rm=true --memory-swappiness=0 \
    --name postgres-quarkus-rest-http-crud \
    -e POSTGRES_USER=restcrud \
    -e POSTGRES_PASSWORD=restcrud \
    -e POSTGRES_DB=rest-crud \
    -p 5432:5432 postgres:10.5
target/todo-backend-*-runner
```
## Other links

- http://localhost:8080/q/health (Show the build in Health check for the datasource)
- http://localhost:8080/q/openapi (The OpenAPI Schema document in yaml format)
- http://localhost:8080/q/swagger-ui (The Swagger UI to test out the REST Endpoints)
- http://localhost:8080/graphql/schema.graphql (The GraphQL Schema document)
- http://localhost:8080/q/graphql-ui/ (The GraphiQL UI to test out the GraphQL Endpoint)
- http://localhost:8080/q/dev-ui/ (Show dev ui)
