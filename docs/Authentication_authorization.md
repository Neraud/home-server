# Authentication and Authorization

## User and password

Users and their passwords are stored in OpenLDAP.
They are created via the ansible playbook and can be configured in `ansible/inventories/vagrant/group_vars/all/kubernetes-apps` : 

```
openldap_ldap_users:
  - id: user
    sn: User
    password: Passw0rd
    email: user@mail.net
    displayName: User
```

You can use [phpLDAPAdmin](https://infra.k8stest.com/phpldapadmin/) to manually create and edit them.

## User groups

2 kinds of groups are created in OpenLDAP :

* SSO groups, used by the Web SSO
* Application groups, used by compatible applications

These groups and their members are configured in `ansible/inventories/vagrant/group_vars/all/kubernetes-apps` : 

```
openldap_ldap_groups:
  # SSO Groups, used to filter access via LemonLDAP
  - id: sso-group-name-1
    description: SSO Group Name 1
    ou: sso_groups
    members: 
      - user

  # App Groups, used to filter access on each app
  - id: app-group-name-1
    description: Application Group Name 1
    ou: app_groups
    members: 
      - user
```

## Web SSO

Most the of exposed sites are protected by LemonLDAP.

### NGinx

In the NGinx reverse proxy configuration, a dedicated `/lmauth` Location is configured to proxy to LemonLDAP.
Each protected Location has an `auth_request`.

These settings are configured in `ansible/inventories/vagrant/group_vars/kubernetes_masters/nginx` :

```
nginx_sites:
  - name: protected-site
    [...]
    lemonLdap:
      path: /lmauth
      proxy_pass: kubernetes-lemonldap-handler-ingress
    locations:
      - path: /
        lemonLdap_protected: True 
        proxy_pass: http://kubernetes-http-ingress
```

### LemonLDAP

LemonLDAP exposes its handler port to receive the NGinx `auth_request`.

The security rules are configured in `ansible/inventories/vagrant/group_vars/all/kubernetes-apps` : 

```
lemonldap_location_rules:
  - domain: "domain.{{ web_base_domain }}"
    # To require TOTP, set the level to >= 4
    #requiredAuthnLevel: 4
    default_rule: groupMatch($hGroups, 'cn', 'sso-group-name-1')
```

### Second Factor

A TOTP can be added to increase security.

To add one for an existing user :

* Go to the [LemonLDAP portal](https://auth.k8stest.com/)
* Log in
* Expand the `connected as [user]` section in the top menu
* Select `2ndFA Manager`
* Register the TOTP

In the default configuration, using a TOTP is not required.
However it can be forced per site by changing the `requiredAuthnLevel` variable.

## Application

When supported, applications also use OpenLDAP to authenticate their users.

A dedicated group under the OU `app_groups` is created for each application. 

### Gitlab

With Gitlab CE, login via LDAP is enabled.
A filter on the `app_groups` `gitlab` is configured.

However, the groups inside Gitlab can't be mapped with LDAP groups (it requires Gitlab EE)

### HomeAssistant

HomeAssistant doesn't natively support LDAP authentication.
However, it supports a generic [command line](https://www.home-assistant.io/docs/authentication/providers/#command-line) authentication provider.
And the community has developped an [LDAP script](https://github.com/efficiosoft/ldap-auth-sh).

This works well, and allows filtering on the `app_groups` `homeassistant`.

However, it does't seem like this authentication provider can be used the first time HomeAssistant is accessed.
The standard process wants to create a user in the local HomeAssistant provider.

In the deployed configuration, both providers are enabled.
After the first access, the HomeAssistant provider can be disabled.

