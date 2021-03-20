#!/bin/bash
cd /home/pptruser

# Output Current Java Version
node -version ## only really needed to show what version is being used. Should be changed for different applications

# Replace Startup Variables
MODIFIED_STARTUP=`eval echo $(echo ${STARTUP} | sed -e 's/{{/${/g' -e 's/}}/}/g')`
echo ":/home/pptruser$ ${MODIFIED_STARTUP}"

# Run the Server
${MODIFIED_STARTUP}