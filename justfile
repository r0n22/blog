version := "3.4"
current_dir := ` pwd `

build_command := "docker build -t jekyll ."

base_command := "docker run --rm --publish 4000:4000 --volume=\""+current_dir+":/srv/jekyll:Z\"  -it -t jekyll "
default: serve

update:
    {{build_command}}
    {{base_command}} bundle update

post:
    {{build_command}}
    {{base_command}} jekyll

build:
    {{build_command}}
    {{base_command}} jekyll build

serve:
    {{build_command}}
    {{base_command}} jekyll serve --watch --future --host '0.0.0.0'