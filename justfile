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
    {{base_command}} jekyll serve --watch --future