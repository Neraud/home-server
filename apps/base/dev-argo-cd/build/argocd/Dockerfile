#--------------------------------------------#
#--------Build KSOPS and Kustomize-----------#
#--------------------------------------------#
FROM viaductoss/ksops:v4.2.1 as ksops-builder


#--------------------------------------------#
#--------Build Custom Argo Image-------------#
#--------------------------------------------#
FROM quay.io/argoproj/argocd:v2.7.1

# Switch to root for the ability to perform install
USER root

ARG PKG_NAME=ksops

# Override the default kustomize executable with the Go built version
COPY --from=ksops-builder /usr/local/bin/kustomize /usr/local/bin/kustomize

# Add ksops executable to path
COPY --from=ksops-builder /usr/local/bin/ksops /usr/local/bin/ksops

# Switch back to non-root argocd user
USER 999
