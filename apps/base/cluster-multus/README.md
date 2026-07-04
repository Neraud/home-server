# Multus

## Manifest source

`multus-daemonset-thick.yaml` is fetched from <https://github.com/k8snetworkplumbingwg/multus-cni/blob/v4.3.0/deployments/multus-daemonset-thick.yml>

## TODO

### CrashLoopBackOff

Multus pods sometimes get stuck in CrashLoopBackOff.

The `install-multus-binary` initcontainer show the error `cp: cannot create regular file '/host/opt/cni/bin/multus-shim': Text file busy`.

See issue: <https://github.com/k8snetworkplumbingwg/multus-cni/issues/1221>

Workaround: SSH on the node and:

```bash
rm /opt/cni/bin/multus-shim
```
