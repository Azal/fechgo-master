upstream fechgo.cl {
    server 127.0.0.1:4000;
}

# The following map statement is required
# if you plan to support channels. See https://www.nginx.com/blog/websocket-nginx/
map $http_upgrade $connection_upgrade {
    default upgrade;
    '' close;
}

server{
    listen 80;
    server_name 206.189.222.16 fechgo.cl;

    location / {
        try_files $uri @proxy;
    }

    location @proxy {
        include proxy_params;
        proxy_redirect off;
        proxy_pass http://fechgo.cl;
        # The following two headers need to be set in order
        # to keep the websocket connection open. Otherwise you'll see
        # HTTP 400's being returned from websocket connections.
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection $connection_upgrade;
    }
}