---
title: Transforming and Refining Collected Data
header_type: base
tags: [processing, collection]
---

I frequently recommend that systems be configured to collect raw data straight from the "firehose". It's unnecessary to apply transformations during the storage phase, and here's why:

- The 'raw' data is all the data; you aren't losing anything during transform, and you aren't adding any assumptions
- Any required transformation can be done later with no loss. Eventually, if it makes sense, transformation happen immediately upon raw data arrival.
- It's unlikely you know all the ways you'll want to transform your raw data for analysis or other uses. You might have a general idea, but specific, concrete, and proven structures often emerge after trying a few things.

So assuming you're collecting raw data - from your webserver, customer transactions, appointments, or anything else - now what? Let's enter the world of data transformations. I'll present a few options to consider below.

##### 1. Databases and SQL-based processing

A database provides an excellent way to encapsulate your data: structured storage, high performance, detailed access controls, and many "out of the box" capabilities. Applications rely on databases because they can be blazingly fast to find and group data, and because they provide transactional capabilities.

Depending on the specific platform, databases can be relatively cheap, or extremely expensive. Getting data into a database requires a data modelling and ingestion process, where the specific details of the data structure must be strictly defined. Using a database generally requires SQL which is powerful yet lacks the extensibility of a high level general purpose language. For example, we can't easily run ML functions inside a database, so generally end up pulling out large chunks of data to perform that process in Python.

When considering a database I will want to be sure that we're truly using the features of a database (transactions or aggregations) rather than simply using it as a place to hold data between different applications. If we only need a place to store the data between applications then regular files can often be a better and simpler solution.

##### 2. Application-based Batch Processing

Imagine a program that can process your raw data. It might need to extract some columns from a spreadsheet, or count the different type of events in a log file. In general these programs will take some data in (typically a file or files), perform some "work", and then output some derived data to one or more files. You want this program to run every day, or every hour, and process the data that has arriving since it last ran. We call this type of work a "batch process".

A subsystem like this has two main considerations: how it is built, and where it will run.

How it is built is most about the programming language. It can be written in any number of programming languages; this decision is best informed by considering the experience and skills of people using and maintaining the program, any other languages used in the system, cost to implement, etc. I will generally recommend Python both as an appropriate fit for lightweight data transformation and as a relatively simple language with low barrier to entry.

Where it will run is determined on a case by case basis. Most programs can run on any computer, but a dedicated system will provide more stability and likely fewer issues. Today there's a very strong case for running processes like this on a Cloud provider where we can use on-demand systems which charge by the minute, meaning we only pay whilst the process is running. In many case this will be for a few minutes each day, which is effectively free. Larger organizations might have a datacentre, and at scale this can be more cost effective than Cloud platforms.

##### 3. Scale Out & Big Data

When data becomes larger than can be processed in small batches, we look to "big data" solutions that will effectively perform those small operations on many computers in parallel, and also provide the capability to summarize results across those parallel runs. Tools in this ecosystem include Hadoop, Hive, Spark, or Beam. Sometimes these needs need to used in conjunction with what are known as "streaming" tools (such as Kafka or Flink), which assist with effectively 'catching' large quantities of data arriving very quickly, or in a continuous manner.

This pattern provides a huge amount of power to process extremely large datasets. Imagine trying to perform conversion analysis with advertising data and website traffic, or find system irregularites in sensor data from a large industrial site. When data size exceeds some number of gigabytes (depending on how big your servers are!), you need to spread that work across multiple servers. Often times these compute "clusters" will contain dozens of high powered servers operating in concert. It's much more expensive than working with a single server, but we only do this work when the potential value is also high.

The tools listed above make the orchestration of multiple servers _relatively_ easy, but it is still much more complicated than a single server. The guidance here is that if something can be done on a single server, that's the answer. Only fall back to these more complicated options when necessary.

##### In Conclusion

Consider the complexity of your data transformation, your data rigidity, scale, and complexity, and your organizational profile when choosing transformation tools. Remember that you don't need to pre-empty any transformation - raw data can be transformed today, tomorrow, or next year. For more information about any of the above approaches, [reach out](contact) and I'll be happy to discuss.
