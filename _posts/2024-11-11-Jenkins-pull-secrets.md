---
layout: post
title: Pulling Secrets out of Jenkins
date: 2024-11-11 07:10
category: 
author: Cameron Regan
tags: [cicd]
summary: Easy way to pull a secret out of Jenkins
---

# Pull Secrets out of jenkins

We are currently deprciating our use of jenkins within our ecosystem and moving to Gitlab CI which is great for us.

Problem is that we were going to migrate some complicated CI/CD work to gitlab and required some of the secrets which we put into the system before.  Jenkins is great that it does not allow you to view private secrets after the fact but now we have try to get them out.

## Get the encrypted secret

Pulling the secret they are in `/var/lib/jenkin/` or wherever you installed jenkins, in the `credentials.xml` file. You should be able to find your credentials which you are trying to use in the xml file in a format like this:

``` xml
 <com.cloudbees.jenkins.plugins.awscredentials.AWSCredentialsImpl plugin="aws-credentials@191.vcb_f183ce58b_9">
    <scope>GLOBAL</scope>
    <id>deploy key</id>
    <description>Deploy Deploy</description>
    <accessKey>Access Key</accessKey>
    <secretKey>{XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX==}</secretKey>
    <iamRoleArn></iamRoleArn>
    <iamExternalId></iamExternalId>
    <iamMfaSerialNumber></iamMfaSerialNumber>
</com.cloudbees.jenkins.plugins.awscredentials.AWSCredentialsImpl>
```
This is great! only problem is that the secretKey is encrypted using the information from the current jenkins install.

## Get the plaintext

To get the plain text you can go to jenkins script console which is at `https://<YOUR_INSTANCE>/manage/script` and then you can paste the following line. Substitue the text in quotes with your information from your secret key.

``` grovvy
println(hudson.util.Secret.decrypt("{XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX==}"))
```

This uses the jenkins built in decryption algorithm and prints out the plain text for your use.

## Profit

This was a quick way for us to pull the required keys out of our own enviroment with minimal disruption.
