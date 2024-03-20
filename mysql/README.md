# MySQL

[MySQL](https://www.mysql.com/) is a fast, reliable, scalable, and easy to use open source relational database system.
Designed to handle mission-critical, heavy-load production applications.

## TL;DR

To define this component within your stack. Add the followings to your `hub.yaml` file

* Include the configuration of Kubernetes

```yaml
extensions:
  configure:
    - kubernetes
```

* Define mysql component under the `components` section

```yaml
components:
  - name: mysql
    source:
      dir: components/mysql
      git:
        remote: https://github.com/epam/kubeflow-components.git
        subDir: mysql
```

* Define parameters under the `parameters` section

```yaml
parameters:
  - name: mysql
    parameters:
      - name: rootPassword
        value: default
      - name: database
        value: default
      - name: username
        value: default
      - name: password
        value: default
```

To initiate the deployment, run the following commands:

```bash
hubctl stack init
hubctl stack configure
# * Setting parameters for configuration
hubctl stack deploy -c mysql
```

## Requirements

Before you can deploy this component, the following requirements must be met:

* Kubernetes 1.19+
* [Helm](https://helm.sh/docs/intro/install/) 3.2.0+
* PV provisioner support in the underlying infrastructure

## Parameters

The following component level parameters has been defined `hub-component.yaml`

| Name                   | Description                                 | Default Value | Required |
|:-----------------------|:--------------------------------------------|:--------------|:--------:|
| `mysql.user`           | Database user                               | `mysql`       |          |
| `mysql.password`       | Database password                           |               |   `x`    |
| `mysql.database`       | Database name                               |               |   `x`    |
| `mysql.rootPassword`   | Database root password                      |               |   `x`    |
| `storage.class`        | Kubernetes storage class                    |               |          |
| `storage.size`         | Database PV size                            | `8Gi`         |          |
| `kubernetes.namespace` | Target namespace                            | `mysql`       |          |
| `kubernetes.replicas`  | Number of replicas                          | `1`           |          |
| `helm.chart`           | File name of helm chart                     | `mysql`       |          |
| `helm.valuesFile`      | Instructs to use helm chart values for base | `values.yaml` |          |
| `helm.version`         | Helm chart version                          | `9.11.2`      |          |
| `hub.backup.file`      | Hub CLI backup file name                    |               |          |

> Note: parameters with default values have been omitted as required parameters

### Outputs Parameters

This component provides the following output values that can be consumed by other components.

| Name         | Description        |
|:-------------|:-------------------|
| `mysql.host` | Mysql service host |
| `mysql.port` | Mysql service port |

## Implementation Details

The component has the following directory structure:

```text
./
├── backup                               # Script to backup mysql data
├── hub-component.yaml                   # Parameters definitions
├── post-deploy                          # Post deploy script to restore data from backup file if provided
├── values-auth.yaml.template            # MySQL auth helm values template
├── values-replication.yaml.gotemplate   # MySQL replication config via helm values template
└── values.yaml.template                 # Base helm values template
```

This component will install a mysql using helm. By default, we rely on Bitnami distribution of helm chart as a quality
helm chart with lots of improvements and hardening.

### After Deploy

After helm chart have been deployed then there is a `post-deploy` script to initialize database (or extra databases) and
optionally restore data from backup file when provided

### Backup

`backup` script will create a database backup and store it as the tar.gz file locally. The backup file name can be
provided via `hub.backup.file` parameter (to restore data from backup file after deploy)

## See Also

* [MySQL Helm Chart](https://bitnami.com/stack/mysql/helm)
