---
layout: post
title: Cost Savings
date: 2023-11-07 20:15
category: 
author: Cameron Regan
tags: []
summary: 
---

# Cost Savings

Every year when you are putting together your Balance Sheet and Income Statement.  It is hard to see all of the charges which hit your bottom line.

## Investigation

When you look at your Income Statement you can see the breakdown of where the costs are coming from.  For example:

Internet Hosting: $2300
COGS: $6700

You will be able to drill down into the data and see where the costs are going.  For example the Internet Hosting is exclusivly AWS so we can use the AWS Cost explorer to review where the bills are going.

So for my costing we had created a infrastructer server for some applications which are used intermentently.  I over engineered my wordpress site with regional aviability.  

## Change

I moved it to docker based wordpress setup which can be seen here.  This turned allowed 2 servers to be turned off which saved approximatly $1000 per year which will go directly to my bottome line.


## Conculsion

I think this was a great exercise to done at least once a year.  The cavat is that this has increased time for administration of the server as for currently the mariadb is shutting down every night with no logs telling me what is going on.  
