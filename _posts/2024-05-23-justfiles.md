---
layout: post
title: Just Files for the win
date: 2024-05-23 21:56
category: productivity
author: Cameron Regan
tags: [Productivity]
summary: Just files provides ease of management of automations wihout need of external tools.
---


# Just files

I recently found [Just](https://github.com/casey/just) this provides an easy way to keep a standarized file of reusable tasks.  This seems to rework my makefile idea's.  This provides some extra features which allows some cool ideas:

* OS Depenancies - you can preface your tasks with `[windows]` or `[linux]` to pick which based on the operating system you are running.
* Default - This provides a list of items and the order to run them to allow for the tasks to be run in succession.

So now for an example, the make file for this blog:

``` make
VERSION=4
current_dir = $(shell pwd)

update:
	docker run --rm --volume="$(current_dir):/srv/jekyll:Z" \
    -it jekyll/jekyll:$(VERSION)  bundle update

post:
	docker run --rm --volume="$(current_dir):/srv/jekyll:Z" \
    -it jekyll/jekyll:$(VERSION)  jekyll


build: 
	docker run --rm --volume="$(current_dir):/srv/jekyll:Z" \
    -it jekyll/jekyll:$(VERSION)  jekyll build

serve:
	docker run --rm   --volume="$(current_dir):/srv/jekyll:Z" \
    --publish 4000:4000   jekyll/jekyll:$(VERSION) \
    jekyll serve --watch
```

And now in just

``` just

version := "4"
current_dir := ` pwd `

base_command := "docker run --rm --publish 4000:4000 --volume=\""+current_dir+":/srv/jekyll:Z\"  -it jekyll/jekyll:"+version
default: serve

update:
    {{base_command}} bundle update

post:
    {{base_command}} jekyll

build:
    {{base_command}} jekyll build

serve:
    {{base_command}} jekyll serve --watch

```

This provides a much more concise system and allows for extra tasks to be added with minimal effort.

We just scratched the surface for what can be done with just files.

Here is a great [one pager](https://cheatography.com/linux-china/cheat-sheets/justfile/) for just syntax and some other things that can be done.