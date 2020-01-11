ARG from_image
FROM $from_image

RUN chown -R node:node /room-assistant

USER node 

# Install dependencies at build time to have a quicker startup
# MQTT
RUN npm install $(python -c "import json ; print ' '.join(json.load(open('./dependencies.json'))['mqtt'])")
# BLE
RUN npm install $(python -c "import json ; print ' '.join(json.load(open('./dependencies.json'))['ble'])")
