# Integrate OnCall

> This is a working copy from [Doc](https://github.com/grafana/oncall/blob/dev/README.md).

## Getting Started

We prepared multiple environments:

- [production](https://grafana.com/docs/grafana-cloud/oncall/open-source/#production-environment)
- [developer](./dev/README.md)
- hobby (described in the following steps)

1. Download [`docker-compose.yml`](docker-compose.yml):

   ```bash
   curl -fsSL https://raw.githubusercontent.com/grafana/oncall/dev/docker-compose.yml -o docker-compose.yml
   ```

2. Set variables:

   ```bash
   echo "DOMAIN=http://localhost:8080
   COMPOSE_PROFILES=with_grafana  # Remove this line if you want to use existing grafana
   SECRET_KEY=my_random_secret_must_be_more_than_32_characters_long" > .env
   ```

   an .env with `

    ```
    DOMAIN=http://localhost:8080  # verify the port is correct
    SECRET_KEY=my_random_secret_must_be_more_than_32_characters_long  # just for demonstration
    ```

3. Launch services:

   ```bash
   docker-compose pull && docker-compose up -d
   ```

4. Go to [OnCall Plugin Configuration](http://localhost:3000/plugins/grafana-oncall-app), using log in credentials
   as defined above: `admin`/`admin` (or find OnCall plugin in configuration->plugins) and connect OnCall _plugin_
   with OnCall _backend_:

   ```text
   OnCall backend URL: http://engine:8080
   ```

5. Enjoy! Check our [OSS docs](https://grafana.com/docs/grafana-cloud/oncall/open-source/) if you want to set up
   Slack, Telegram, Twilio or SMS/calls through Grafana Cloud.

## Update version

To update your Grafana OnCall hobby environment:

```shell
# Update Docker image
docker-compose pull engine

# Re-deploy
docker-compose up -d
```

After updating the engine, you'll also need to click the "Update" button on the [plugin version page](http://localhost:3000/plugins/grafana-oncall-app?page=version-history).
See [Grafana docs](https://grafana.com/docs/grafana/latest/administration/plugin-management/#update-a-plugin) for more
info on updating Grafana plugins.
