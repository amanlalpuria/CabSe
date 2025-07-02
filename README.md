# CabSe

### 1. **Prerequisites**
1. Java 24
2. Docker


### 2. **Start the Service**
Run
```sh
./start.sh
```

There will be a message `Everything is up and running!`

You can use the use the below url to access the endpoints

```
http://localhost:8080/actuator/health
```

### 4. **Stop the Containers**
To stop all containers after you’re done, you can use:

```bash
./stop.sh
```

This will stop and remove the containers, networks, and volumes defined in your `docker-compose.yml`. To preserve your data, you can use the `--volumes` option to also remove volumes (if needed).
