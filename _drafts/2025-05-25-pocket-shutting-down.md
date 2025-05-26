---
layout: post
title: Pocket shutting down
date: 2025-05-26 07:10
category: 
author: Cameron Regan
tags: [self-hosted]
summary:  Pocket is shutting down and what can we do about it.
---

# Pocket is shutting down, Self hosted Solution

TLDR: Moved from pocket to Wallabag and got some more features!

I loved it, I use it religiously for websites and keeping knowledge for myself.  It was easy to find what I was looking for when I needed to find the information next.  I was excited that Mozilla purchased it because I like what they are doing and making sure the web is an open platform.  It saddens me that as of July 8th [Pocket is shutting down](https://support.mozilla.org/en-US/kb/future-of-pocket).  

This was unexpected for me.  I hope that [Kevin Rose does get to purchase](https://x.com/kevinrose/status/1925678269560434961) it as that is a Win-Win for both Kevin and Mozilla.   I was not wanting to bank on a tweet for my data.

## Enter Wallabag

I self host alot of my own infrastrure, I have resently gone back to RSS news reading to try to curb my intake of news and doom scrolling. I landed on [Wallabag](https://wallabag.org/) is an open source "save it for later" app that works very much like pocket does.  You can use their hosted version or self host.  If you are not wanting to self host you can pay for use of their instance.  But if you are wanting to host yourself it was simple to get it all spun up.

## Docker

Wallabag suggests that you install it directly on the server but my entire system is dockerized so I went with the dockerized solution.  The docker instructions can be found on the [Docker Hub](https://hub.docker.com/r/wallabag/wallabag/) page.  I used docker compose since that is what my entire system is built on so I added the following to my `docker-compose.yml` file.

``` yaml
services:
  wallabag:
    image: wallabag/wallabag
    restart: unless-stopped
    environment:
      - MYSQL_ROOT_PASSWORD=wallaroot
      - SYMFONY__ENV__DATABASE_DRIVER=pdo_mysql
      - SYMFONY__ENV__DATABASE_HOST=db-wallabag
      - SYMFONY__ENV__DATABASE_PORT=3306
      - SYMFONY__ENV__DATABASE_NAME=wallabag
      - SYMFONY__ENV__DATABASE_USER=wallabag
      - SYMFONY__ENV__FOSUSER_REGISTRATION=False # Add this after you have created your user to not let others use your instance
      - SYMFONY__ENV__DATABASE_PASSWORD=wallapass
      - SYMFONY__ENV__DATABASE_CHARSET=utf8mb4
      - SYMFONY__ENV__DATABASE_TABLE_PREFIX="wallabag_"
      - SYMFONY__ENV__MAILER_DSN=smtp://127.0.0.1
      - SYMFONY__ENV__FROM_EMAIL=wallabag@example.com
      - SYMFONY__ENV__DOMAIN_NAME=<Domain Name>
      - SYMFONY__ENV__SERVER_NAME="Wallabag"
    ports:
      - "5678:80"
    volumes:
      - ./wallabag/images:/var/www/wallabag/web/assets/images
    healthcheck:
      test: ["CMD", "wget" ,"--no-verbose", "--tries=1", "--spider", "http://localhost/api/info"]
      interval: 1m
      timeout: 3s
    depends_on:
      - db-wallabag
      - redis
  db-wallabag:
    image: mariadb
    restart: unless-stopped
    environment:
      - MYSQL_ROOT_PASSWORD=wallaroot
    volumes:
      - ./wallabag/data:/var/lib/mysql
    healthcheck:
      test: ["CMD", "mysqladmin" ,"ping", "-h", "localhost"]
      interval: 20s
      timeout: 3s
  redis:
    image: redis:alpine
    restart: unless-stopped
    healthcheck:
      test: ["CMD", "redis-cli", "ping"]
      interval: 20s
      timeout: 3s
```

Couple things to note, if you do not get the `SYMFONY__ENV__SERVER_NAME` correct it will still work but the stylesheets and images will not be working correctly.  If this happens make sure you remove the container and recreate it.  

I keep all of my data in the local filesystem in folders so I created a folder `wallabag` to store the mysql and image storage and mapped them using volumes.

Once everything is up and running you can log into the system using the default user `wallabag` with password `wallabag`.  I strongly suggest changing the default password.

This allowed me to login with my new user and create 

![Wallabag view](wallabag-view.png)

This was great I was able to get access to the system localy.

## KoReader Intergration

This was a great supprise

