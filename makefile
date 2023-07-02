VERSION=4
current_dir = $(shell pwd)

update:
	docker run --rm --volume="$(current_dir):/srv/jekyll:Z" \
    -it jekyll/jekyll:$(VERSION)  bundle update

post:
	docker run --rm --volume="$(current_dir):/srv/jekyll:Z" \
    -it jekyll/jekyll:$(VERSION)  jekyll


build: 
	docker run --rm --volume="$(current_dir):/srv/jekyll:Z"s \
    -it jekyll/jekyll:$(VERSION)  jekyll build

serve:
	docker run --rm   --volume="$(current_dir):/srv/jekyll:Z" \
    --publish 4000:4000   jekyll/jekyll:$(VERSION) \
    jekyll serve --watch