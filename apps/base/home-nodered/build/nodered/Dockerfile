FROM docker.io/nodered/node-red:3.1.3-18-minimal

# Authentication
RUN npm install ldapauth-fork@5.0.5
ADD ldap-user-authentication.js /usr/src/node-red/ldap-user-authentication.js

# Contrib nodes
RUN npm install node-red-contrib-home-assistant-websocket@0.62.2
RUN npm install node-red-contrib-time-range-switch@1.2.0
RUN npm install node-red-contrib-stoptimer@0.0.7
