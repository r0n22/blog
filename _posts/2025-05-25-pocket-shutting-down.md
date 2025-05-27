---
layout: post
title: RIP Pocket moved to Wallabag
date: 2025-05-26 07:10
category: 
author: Cameron Regan
tags: [self-hosted]
summary:  Pocket is shutting down and what can we do about it.
---

# RIP Pocket moved to Wallabag

TLDR: Moved from Pocket to Wallabag and got some more features!

I loved it, I use it religiously for websites and keeping knowledge for myself.  It was easy to find what I was looking for when I needed to find the information next time.  I was excited that Mozilla purchased it because I like what they are doing and making sure the web is an open platform.  It saddens me that as of July 8th [Pocket is shutting down](https://support.mozilla.org/en-US/kb/future-of-pocket).  

This was unexpected for me.  I hope that [Kevin Rose does get to purchase](https://x.com/kevinrose/status/1925678269560434961) it as that is a win-win for both Kevin and Mozilla, but I was not going to bank on a tweet for my app to stay going.  I needed to find something to move over to.

## Enter Wallabag

I self host much of my own infrastructure, I have recently gone back to RSS for news reading to try to curb my time reading news and doom scrolling. After a non-exchastive search for open source pocket alternatives I landed on [Wallabag](https://wallabag.org/).  You can use their hosted version or self host.  I almost always go the self host route it was simple to get setup.

## Docker

Wallabag suggests that you install it directly on the server but my entire platform is dockerized which they do have a docker image for.  The docker instructions can be found on the [Docker Hub](https://hub.docker.com/r/wallabag/wallabag/) page.  My server setup is a single docker compose file so to start using Wallabag I added the following to my `docker-compose.yml` file.

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

Couple things to note, if you do not get the `SYMFONY__ENV__SERVER_NAME` correct you will be able to login and have a functioning app but the stylesheets and images will not be working correctly.  If this happens make sure you remove the container and recreate it.  

I keep all of my data in the local filesystem in seprate folders.  I created a folder `wallabag` to store the mysql and image storage and mapped them using volumes.

Once everything is up and running you can log into the system using the default user `wallabag` with password `wallabag`.  I strongly suggest changing the default password.

You cannot change your username so I ended up creating a new user with my normal username so that I would not have to remember the username for a single website.

This allowed me to login with my new user and create 

![Wallabag view](/assets/images/blog/wallabag-view.png)

This was great I was able to get access to the system localy.

## KoReader Intergration

This was a great supprise that KoReader is able pull the articles directly from the Wallabag server and provide them as ePub files that you can read. I know that pocket used to be able to do this with Kobo but it seems that this was broken when Mozilla moved users over to Mozilla's own Single Sign On system.

The configuration cannot be done within your reader you have to setup a setting file.  I am running this on a Kobo so your milage may very on other devices.

For this you need to have your username and password as well as an Client ID and Secret. To get your client ID and Secret go to http://yourinstance/developer and click on "Create A New Client"

![Create a client from wallabag](/assets/images/blog/wallabag-createclient.png)

Give your client a name and click create new client.  You will be able to save your Client ID and Secret. 

I had a hard time finding the location of the file but it seems that koreader stores itself in a hidden folder named `.add` then you can navigate to `koreader/settings/wallabag.lua` (Which if you have not used it before will not exist).  You can add in the following:

``` luz
-- we can read Lua syntax here!
return {
    ["wallabag"] = {
        ["articles_per_sync"] = 30,
        ["server_url"] = "", # Location of the server
        ["client_id"] = "", # Where you put your client ID
        ["client_secret"] = "", # Client Secret
        ["password"] = "", # Your Username
        ["username"] = "", # Your Password

        ["directory"] = "/mnt/sd/articles", # The location you want to store

        ["download_queue"] = {},
        ["filter_tag"] = "",
        ["ignore_tags"] = "",
        ["is_archiving_deleted"] = false,
        ["is_auto_delete"] = false,
        ["is_delete_finished"] = true,
        ["is_delete_read"] = false,
        ["is_sync_remote_delete"] = false,
        ["remove_finished_from_history"] = false,
    },
}
```

Everything was straight forward except the `directory` this was the location on my kobo which I want to have the articles downloaded to.  The issue was making sure I know how kobo mapped everything together.  I created a directory name `articles` on my sd card and found that my kobo mounts the sd card at `/mnt/sd/` so my directory was `/mnt/sd/articles/`.

Once I got that everything worked great.  This allowed me to download the articles and read them on my kobo.  There is also a button which allows you to sync your progess with wallabag so you articles I have on my kobo finished show as finished on wallabag.

## Great Start

Overall for an hour's worth of work it was a great first step.  Now I want to migrate my data from pocket into wallabag to make sure I keep my history.  Keep posted for part 2.
