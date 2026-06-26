---
layout: post
title: Debugging Can Hurt
date: 2026-06-26 14:44
category: 
author: Cameron Regan
tags: [Development]
summary: Don't debug performance with Debug.WriteLine 
---

# Debugging can hurt you

I was working on a performance issue.  In [dTris](https://mectiming.org/products/dtris/) my ski racing software,  racers were taking 1-2 seconds to get from the start of the race course to being in progress after we have heard the timer acknowledge the racer is on course.

In a regular program this might not be that bad but dTris is a real time application which requires that the user have quick refresh of the information. 
I started logging all the timings and calculate the time from intial pulse read to final refresh of UI, there was `Debug.WriteLine` statements everywhere!

I just could not get the system to perform any better.

Then reading stack overflow it someone asked why is `Debug.WriteLine` so slow?

So I did a test of my log4net vs Debug.Witeline. Debug for writeline was 20x slower than my internal logging.

After updating all my Debugging statements to use my internal debug logger the performance issue went away.


