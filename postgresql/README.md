# PosgreSQL

PostgreSQL (Postgres) is an open source object-relational database known for reliability and data integrity. ACID-compliant, it supports foreign keys, joins, views, triggers and stored procedures.


## Implementation Details

The component uses helm chart from bitnami to deploy a PostgreSQL

```text
./
├── hub-component.yaml          # Parameters definitions
└── values.yaml.template        # Base helm values template
```

## Parameters

The following component level parameters has been defined `hub-component.yaml`

| Name | Description | Default Value |
| :--- | :---        | :---          |
| `dns.domain` | Domain name of the kubeflow stack | |
| `component.storage-class.name` | | |
| `postgresql.namespace` | | `database` |
| `postgresql.port` | | `3306` |
| `postgresql.user` | database user | |
| `postgresql.password` | database password | |
| `postgresql.database` | database name | |
| `postgresql.adminPassword` | database root password | |
| `postgresql.volumeSize` | Storage size | `8Gi` |
| `postgresql.helm.chart` | File name of helm chart | `database-8.0.0.tgz` |
| `postgresql.helm.valuesFile` | Name of helm values file | `values.yaml` |

## Outputs

| Name | Description |
| :--- | :---        |
| `postgresql.host` | database host |
| `postgresql.port` | database port |
| `postgresql.database` | database database |
| `postgresql.user` | database user |
| `postgresql.password` | database password |
| `postgresql.rootPassword` | database root password |

## See Also

- [Chart sources](https://github.com/bitnami/charts/tree/main/bitnami/postgresql)
