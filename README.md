Currently a FreeBSD database server is deployed on Hetzner Cloud.

```
.
+-- config/         Global configuration vriables
+-- terraform/      Server infrastructure
+-- ansible/        Server system provisioning
+-- inventory/      Ansible inventory
+-- scripts/
```

System configuration variables are centrally defined in YAML files in the
`config` directory. See `config/config.yml.example`.
