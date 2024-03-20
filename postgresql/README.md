# PostgreSQL

PostgreSQL is an open source object-relational database known for reliability and data integrity.
ACID-compliant, it supports foreign keys, joins, views, triggers and stored procedures.

## TL;DR

To define this component within your stack. Add the followings to your `hub.yaml` file

* Include the configuration of Kubernetes

```yaml
extensions:
  configure:
    - kubernetes
```

* Define postgresql component under the `components` section

```yaml
components:
  - name: postgresql
    source:
      dir: components/postgresql
      git:
        remote: https://github.com/epam/kubeflow-components.git
        subDir: postgresql
```

* Define parameters under the `parameters` section

```yaml
parameters:
  - name: postgresql
    parameters:
      - name: user
        value: default
      - name: password
        value: default
      - name: database
        value: default
      - name: adminPassword
        value: default
```

To initiate the deployment, run the following commands:

```bash
hubctl stack init
hubctl stack configure
# * Setting parameters for configuration
hubctl stack deploy -c postgresql
```

## Parameters

The following component level parameters has been defined `hub-component.yaml`

| Name                         | Description                        | Default Value                                 | Required |
|:-----------------------------|:-----------------------------------|:----------------------------------------------|:--------:|
| `kubernetes.namespace`       |                                    | `postgresql`                                  |          |
| `storage.class`              |                                    |                                               |          |
| `postgresql.port`            | Postgresql database port           | `5432`                                        |          |
| `postgresql.user`            | Postgresql database user           |                                               |   `x`    |
| `postgresql.password`        | Postgresql database password       |                                               |   `x`    |
| `postgresql.database`        | Postgresql database name           |                                               |   `x`    |
| `postgresql.adminPassword`   | Postgresql database admin password |                                               |   `x`    |
| `postgresql.volumeSize`      | Storage size                       | `8Gi`                                         |          |
| `postgresql.extra.databases` | Extra databases                    |                                               |          |
| `helm.repo`                  | Helm chart repository URL          | [bitnami](https://charts.bitnami.com/bitnami) |          |
| `helm.chart`                 | Helm chart name                    | `postgresql`                                  |          |
| `helm.version`               | Helm chart version                 | `12.1.2`                                      |          |
| `helm.valuesFile`            | Helm base values file              | `values.yaml`                                 |          |

## Outputs

| Name                      | Description            |
|:--------------------------|:-----------------------|
| `postgresql.host`         | database host          |
| `postgresql.port`         | database port          |
| `postgresql.database`     | database database      |
| `postgresql.user`         | database user          |
| `postgresql.password`     | database password      |
| `postgresql.rootPassword` | database root password |

## Implementation Details

The component has the following directory structure:

```text
./
├── hub-component.yaml          # parameters definitions
└── values.yaml.template        # base helm values template
```

This component will be installed using Helm. By default, we rely on Bitnami distribution of helm chart as a quality
helm chart with lots of improvements and hardening.

## See Also

- [Chart sources](https://github.com/bitnami/charts/tree/main/bitnami/postgresql)
