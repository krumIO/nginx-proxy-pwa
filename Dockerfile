FROM jwilder/nginx-proxy:alpine
RUN { \
      echo 'fastcgi_buffers 16 16k; '; \
      echo 'fastcgi_buffer_size 32k;'; \
      echo 'proxy_buffer_size   128k;'; \
      echo 'proxy_buffers   4 256k;'; \
      echo 'proxy_busy_buffers_size   256k;'; \
    } > /etc/nginx/conf.d/my_proxy.conf