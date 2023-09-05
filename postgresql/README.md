# PosgreSQL

PostgreSQL (Postgres) is an open source object-relational database known for reliability and data integrity.
ACID-compliant, it supports foreign keys, joins, views, triggers and stored procedures.

## TL;DR

Set environment variables `POSTGRES_HOST`,`POSTGRES_USER`,`POSTGRES_PORT`,`POSTGRES_PASSWORD`,`POSTGRES_DATABASE`   
Declare hubctl stack

```shell
cat << EOF > params.yaml
parameters:
- name: mysql
  parameters:
  - name: host
    fromEnv: POSTGRES_HOST
  - name: user
    fromEnv: POSTGRES_USER
  - name: port
    value: POSTGRES_PORT
  - name: password
    fromEnv: POSTGRES_PASSWORD
  - name: database
    fromEnv: POSTGRES_DATABASE
EOF

cat << EOF > hub.yaml
version: 1
kind: stack

requires:
  - kubernetes

extensions:
  include:
    - params.yaml

components:  
  - name: postgresql
    source:
      dir: components/postgresql
      git:
        remote: https://github.com/epam/kubeflow-components.git
        subDir: postgresql 
EOF

hubctl stack init
hubctl stack deploy
```

## Implementation Details

The component uses helm chart from bitnami to deploy a PostgreSQL

```text
./
├── hub-component.yaml          # Parameters definitions
└── values.yaml.template        # Base helm values template
```

## Parameters

The following component level parameters has been defined `hub-component.yaml`

| Name                         | Description                        | Default Value                        | Required 
|:-----------------------------|:-----------------------------------|:-------------------------------------|:--------:|
| `storage.class`              |                                    |                                      |          |
| `kubernetes.namespace`       |                                    | `postgresql`                         |          |
| `postgresql.port`            | Postgresql database port           | `5432`                               |          |
| `postgresql.user`            | Postgresql database user           |                                      |          |
| `postgresql.password`        | Postgresql database password       |                                      |          |
| `postgresql.database`        | Postgresql database name           |                                      |          |
| `postgresql.adminPassword`   | Postgresql database asmin password |                                      |          |
| `postgresql.volumeSize`      | Storage size                       | `8Gi`                                |          |
| `postgresql.extra.databases` | Extra databases                    |                                      |          |
| `helm.repo`                  | Helm chart repository URL          | `https://charts.bitnami.com/bitnami` |          |
| `helm.chart`                 | Helm chart name                    | `postgresql`                              |          |
| `helm.version`               | Helm chart version                 | `12.1.2`                              |          |
| `helm.valuesFile`            | Helm base values file              | `values.yaml`                        |          |

## Outputs

| Name                      | Description            |
|:--------------------------|:-----------------------|
| `postgresql.host`         | database host          |
| `postgresql.port`         | database port          |
| `postgresql.database`     | database database      |
| `postgresql.user`         | database user          |
| `postgresql.password`     | database password      |
| `postgresql.rootPassword` | database root password |

## See Also

- [Chart sources](https://github.com/bitnami/charts/tree/main/bitnami/postgresql)
