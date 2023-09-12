# PosgreSQL

PostgreSQL is an open source object-relational database known for reliability and data integrity.
ACID-compliant, it supports foreign keys, joins, views, triggers and stored procedures.

## TL;DR

To define this component within your stack, add the following code to the `components` section of your  `hub.yaml` file

```yaml
components:
  - name: postgresql
    source:
      dir: components/postgresql
      git:
        remote: https://github.com/epam/kubeflow-components.git
        subDir: postgresql 
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
| `postgresql.user`            | Postgresql database user           |                                               |          |
| `postgresql.password`        | Postgresql database password       |                                               |          |
| `postgresql.database`        | Postgresql database name           |                                               |          |
| `postgresql.adminPassword`   | Postgresql database admin password |                                               |          |
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

The component uses helm chart from bitnami to deploy a PostgreSQL

```text
./
├── hub-component.yaml          # parameters definitions
└── values.yaml.template        # base helm values template
```

## See Also

- [Chart sources](https://github.com/bitnami/charts/tree/main/bitnami/postgresql)
