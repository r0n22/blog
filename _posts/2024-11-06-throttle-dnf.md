---
layout: post
title: How to limit your DNF dowload Speed
date: 2024-11-06 20:49
category: linux
author: Cameron Regan
tags: [linux]
summary: 
---

# Throttle DNF

To throttle your system's update downloads you will be able to do this by editing `/etc/dnf/dnf.conf`

Add a line under `[main]`  which is `throttle=Xk/m/g` where x is the number of bytes.

So mine is

```
[main]
throttle=1024k
gpgcheck=True
installonly_limit=3
clean_requirements_on_remove=True
best=False
skip_if_unavailable=True

```


If you want to do this for a single command you can use the `--setopt=`

So for example `dnf --setopt=throttle=1024k update` will throttle your upgrade to 1Mb/s for just that update.