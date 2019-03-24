FROM nodered/node-red-docker:0.20.3-slim-v10

# Authentication
RUN npm install ldapauth-fork@4.2.0
ADD ldap-user-authentication.js /usr/src/node-red/ldap-user-authentication.js

# Contrib nodes
RUN npm install node-red-contrib-home-assistant-websocket@0.9.1
RUN npm install node-red-contrib-time-range-switch@0.6.1
RUN npm install node-red-contrib-stoptimer@0.0.7
