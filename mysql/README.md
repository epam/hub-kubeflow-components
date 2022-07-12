# MySQL

## Overview of the MySQL

[MySQL](https://www.mysql.com/) is a fast, reliable, scalable, and easy to use open source relational database system. Designed to handle mission-critical, heavy-load production applications.

## Implementation Details

The component has the following directory structure:

```text
./
├── charts                      # Directory contains helm charts archives
├── backup                      # Script to backup mysql data
├── hub-component.yaml          # Parameters definitions
├── post-deploy                 # Post deploy script to restore data from backup file if provided
├── values-auth.yaml.template   # MySQL auth helm values template
└── values.yaml.template        # Base helm values template
```

## Parameters

The following component level parameters has been defined `hub-component.yaml`

| Name | Description | Default Value |
| :--- | :---        | :---          |
| `dns.domain` | Domain name of the kubeflow stack | |
| `component.storage-class.name` | | |
| `component.mysql.namespace` | | `mysql` |
| `component.mysql.port` | | `3306` |
| `component.mysql.user` | MySQL database user | |
| `component.mysql.password` | MySQL database password | |
| `component.mysql.database` | MySQL database name | |
| `component.mysql.rootPassword` | MySQL database root password | |
| `component.mysql.volumeSize` | Storage size | `8Gi` |
| `component.mysql.docker.registry` | Docker image registry | `docker.io` |
| `component.mysql.docker.repository` | Docker image repository | `bitnami/mysql` |
| `component.mysql.docker.tag` | Docker image tag | `8.0.22-debian-10-r23` |
| `component.mysql.helm.chart` | File name of helm chart | `mysql-8.0.0.tgz` |
| `component.mysql.helm.valuesFile` | Name of helm values file | `values.yaml` |
| `hub.backup.file` | Hub CLI backup file name | |

## Outputs

| Name | Description |
| :--- | :---        |
| `component.mysql.host` | MySQL database host |
| `component.mysql.port` | MySQL database port |
| `component.mysql.database` | MySQL database database |
| `component.mysql.user` | MySQL database user |
| `component.mysql.password` | MySQL database password |
| `component.mysql.rootPassword` | MySQL database root password |

## See Also

- [MySQL](https://www.mysql.com/)
