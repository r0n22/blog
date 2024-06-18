---
layout: post
title: VS Code Black Formatter
date: 2024-04-02 20:02
category: productivity
author: Cameron Regan
tags: ['vscode','programming']
summary: 
---

# Intergrating Black formatter into your workflow

I love using software which can remove mundaine tasks from my workflow.  I exculsively use VS Code for my programming.  You can install the [Official Microsoft Black formatter](https://marketplace.visualstudio.com/items?itemName=ms-python.black-formatter)

This provides formatting for python and great addition is organization and cleanup of imports for each file.  This can all be done using hot keys.  

* `Ctrl + Alt + I` to format the document

If you add into your Prefrences JSON 

``` json
  "[python]": {
    "editor.defaultFormatter": "ms-python.black-formatter",
    "editor.formatOnSave": true
  }
```

This will default python files to the black formatter. Every time you save it will automatically reformat the document.  This was a game changer for me.  

IF you want the organization of the imports as well then use the below:

``` json
 "[python]": {
    "editor.defaultFormatter": "ms-python.black-formatter",
    "editor.formatOnSave": true,
    "editor.codeActionsOnSave": {
        "source.organizeImports": true
    }
  }

```
Source: [Blog osull] [1]

This provides you update of the imports on every time you save the document.  

Next upgrade for my productivity increase will have these done one a [pre-commit](https://pre-commit.com/#cli) task.


[1]: <https://blog.osull.com/2022/03/02/python-vs-code-make-black-and-organize-imports-work-together-on-save/> 