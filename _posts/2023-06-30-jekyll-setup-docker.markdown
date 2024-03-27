---
layout: post
title:  "Getting Started with Jekyll"
date:   2023-06-30 08:51:44 -0500
categories: jekyll update
---

# Getting Jekyll setup with docker

I have not done alot of work with Ruby but thought that Jekyll was the best option for writing my blog.

Being able to use docker allows me to not have to install the whole ruby ecosystem on my computer.  So I decided to move to dockerized version of the compile/build/serve.

To start the documentation on [Jekyll Docker](https://github.com/envygeeks/jekyll-docker) was great.  This got me very close.

Seems that the interaction of Jekyll Docker/WSL 2 required some changes.

1. I had to add `gem "webrick"` to Gemfile as it was not stored directly.

I also did not want to have to keep remembering the docker commands to run the blog so I created a makefile for it.

``` make
VERSION=4
current_dir = $(shell pwd)

update:
	docker run --rm --volume="$(current_dir):/srv/jekyll:Z" \
    -it jekyll/jekyll:$(VERSION)  bundle update

build: 
	docker run --rm --volume="$(current_dir):/srv/jekyll:Z" \
    -it jekyll/jekyll:$(VERSION)  jekyll build

serve:
	docker run --rm   --volume="$(current_dir):/srv/jekyll:Z" \
    --publish 4000:4000   jekyll/jekyll:$(VERSION) \
    jekyll serve --watch
```

`VERSION=4` lets me update the version of jekyll that I am using easily

`current_dir = $(shell pwd)` is used instead of $PWD in shell to get the current working directory

Other than that I had to publish the port instead of having it localhost only so that my browser could access it.

So now I can just type `make serve` and get acccess to my blog locally.