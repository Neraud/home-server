# Upgrade Longhorn from 1.3.1 to 1.4.0

## Issue

If a volume is used when deploying the new 1.4.0 deployment, new properties (`spec.snapshotDataIntegrity` and `spec.restoreVolumeRecurringJob`) randomly won't be set.
Any time we try to update this volume (to upgrade the engine for example), it will fail.

## Workaround

Make sure all volumes are not used by scalling down workloads.

## Upgrade steps

* Scale down all workloads that use a Longhorn volume
  * Keep Lemonldap up
  * Check on the Longhorn Dashboard that all volumes are `Detached` (except Lemondap's)
  * scale down Lemonldap
* Deploy the new 1.4.0 manifest
* Remove old resources

```bash
kubectl delete PodSecurityPolicy longhorn-psp
kubectl --namespace longhorn-system delete role longhorn-psp-role
kubectl --namespace longhorn-system delete rolebindings.rbac.authorization.k8s.io longhorn-psp-binding
```

* Wait for the new longhorn workload to start
* Scale up all workloads that use a Longhorn volume
* Update all engines using the longhorn UI
