---
layout: post
title:  Keep it simple
date: 2024-05-30 10:42
category: development
author: Cameron Regan
tags: []
summary: Do not overcomplicate your process or development
---


# Keep it simple

I always have liked the quote "The best code to write is none at all" .  If a process can be done with exsiting tools or just a checklist this limits the required effort from the development and maintence of systems.

I pushed up against this in on of my current rewrites of my [timing software](https://mectiming.org).  The current iteration of the software manages all of the yearly calculation factors as variables within the software.  So every year we have to push new version of the software out even if there is no changes to the software.  My idea was to download these factors every year from a central repository so that we can use the same version of the software for multiple years.  This also has the added benefit that multiple years of factors can be stored together and slected based on the year.

I spent a couple hours scoping out a django api project which would allow me to manage all of the data in a central way and to gather the data automatically so that we do not have to keep the system up to date ourselves.

After worrying about another piece of software which I would have to maintain and manage.  I got the idea just to pre-process the factors and store them on our update server as a json file.  This elimates much of my development and ongoing maintence costs for another piece of software.  I actually used ChatGPT to write most of the excel to json conversion python script and create a [just file]({% link _posts/2024-05-23-justfiles.md %}) which provides the autmation to:

1. Take the excel inputs and convert to json output
2. Upload the json files to our configration server in specified folders/formats for our software to use

Overall I think this was a success and we are currently using it in our beta test of our new management software in multiple locations.


