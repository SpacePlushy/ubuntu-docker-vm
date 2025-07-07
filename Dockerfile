# Railway requires a Dockerfile, not just docker-compose
# This wraps the webtop image for Railway deployment

FROM lscr.io/linuxserver/webtop:latest

# Railway uses PORT environment variable
# We need to handle the dual-port nature of webtop
ENV PORT=3000
ENV WEB_PORT=3000

# Add a script to handle Railway's single PORT limitation
RUN echo '#!/bin/bash\n\
# Railway only provides one PORT, but webtop uses two (3000 for HTTP, 3001 for HTTPS)\n\
# We will use HTTP only for Railway deployment\n\
export CUSTOM_PORT=${PORT:-3000}\n\
export WEB_PORT=${PORT:-3000}\n\
exec /init' > /railway-init.sh && \
chmod +x /railway-init.sh

# Use our custom init script
CMD ["/railway-init.sh"]