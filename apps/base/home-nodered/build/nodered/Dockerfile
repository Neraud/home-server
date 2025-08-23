FROM docker.io/nodered/node-red:4.1.0-22-minimal

# Authentication
RUN npm install ldapauth-fork@6.1.0
ADD ldap-user-authentication.js /usr/src/node-red/ldap-user-authentication.js

# Contrib nodes
RUN npm install node-red-contrib-home-assistant-websocket@0.77.2
RUN npm install node-red-contrib-time-range-switch@1.2.0
RUN npm install node-red-contrib-stoptimer@0.0.7
