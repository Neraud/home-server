# Multus

## Manifest source

`multus-daemonset-thick.yaml` is fetched from <https://github.com/k8snetworkplumbingwg/multus-cni/blob/v4.1.3/deployments/multus-daemonset-thick.yml>

## TODO

### OOM

Multus v4.2.0+ gets OOMKilled with the default resources.

See issue: <https://github.com/k8snetworkplumbingwg/multus-cni/issues/1346>

Minimal config to support a node restart on heavier nodes:

```yaml
resources:
    limits:
    cpu: 100m
    memory: 2Gi
    requests:
    cpu: 100m
    memory: 512Mi
```

### CrashLoopBackOff

Multus pods sometimes get stuck in CrashLoopBackOff.

The `install-multus-binary` initcontainer show the error `cp: cannot create regular file '/host/opt/cni/bin/multus-shim': Text file busy`.

See issue: <https://github.com/k8snetworkplumbingwg/multus-cni/issues/1221>

Workaround: SSH on the node and:

```bash
rm /opt/cni/bin/multus-shim
```
