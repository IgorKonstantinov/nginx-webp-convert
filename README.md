# Requirements
1. NGINX + Lua
```
apt install nginx-extras
```

2. WEBP Library
```
wget http://downloads.webmproject.org/releases/webp/libwebp-0.6.0-linux-x86-64.tar.gz
tar --strip-components 1 -xzvf libwebp*.gz -C /usr/local
rm libwebp*.gz
```

3. Add Location to Domain Config
```
location ~* ^(.+\.(jpe?g|png))$ {
    add_header Vary Accept;
    expires max;
    content_by_lua_file /etc/nginx/lua/webp.lua;
}
```

## Tests
Before

![JPEG](https://i.imgur.com/BJY8ifS.png)

After

![WEBP](https://i.imgur.com/J0eAVN4.png)
