---
layout: note
title: ElasticSearch on CentOS 7
excerpt: A brief primer on installing, configurating and populating ElasticSearch with some sample data.
promote: true
published: true
status: current
last_modified: 2015-01-16 13:37:00 -0400
---

ElasticSearch is amazing.  It's my new best friend.  Sorry redis, we're still cool.

I have heard a lot about it, but never thought I had a need for it.  Boy, was I wrong.

I will walk you through installation, setup, and population of a sample database.  This will
give you a good idea of what you can do.  In the next article, I tackle
[sending your Syslog messages to ElasticSearch](/projects/rsyslog.md) without LogStash.  Nothing
against LogStash, it is just out of the scope of the article.

I assume you are familiar with the command-line, and have basic linux system administration
skills higher than "I installed it once!".

For my single node installation, I'm using a CentOS 7 machine with 2GB RAM and 20GB harddrive. This
is plenty for a "home" installation.  After install, you should have 15GB of disk space free for
data and elasticsearch takes up about 700MB of RAM while being fed about 10 documents a second. It
is VERY slim.  The sample database takes up 16MB on disk and has 110k rows.

#### Basics

ElasticSearch may look like a NoSQL database like MongoDB, but it is much more than that. It is
built from the ground up to be a distributed aggregation and extraction engine.  There is nothing
stopping you from using ElasticSearch to store and retrieve JSON objects, in fact, Marvel, Kibana
and other third-party software use it for a simple storage engine.

* **document** - A document is a JSON-structured object.  This is your content.  A *document* is
analogous to a **row**.
* **index** - You store documents in an *index*. An *index* is analogous to a **database**.
* **mapping** - Each index can have a **schema** defining the types of data in each field.
* **type** - Documents can be of different *type*s. A *type* of document is analogous to a **table**.

ElasticSearch is interacted with via a
[REST API](http://www.elasticsearch.org/guide/en/elasticsearch/reference/current/_exploring_your_cluster.html).
The commands here will be presented to `curl`, however, we will be using the Marvel-included Sense
interface.  An earlier version of Sense is packaged as a
[Google Chrome plugin](https://chrome.google.com/webstore/detail/sense-beta/lhjgkmllcaadmopgmanpapmpjgmfcfig?hl=en)
as well.

#### Installation

Installation on CentOS 7 was very complicated.

    yum install -y java-1.7.0-openjdk-headless
    rpm -Uvh https://download.elasticsearch.org/elasticsearch/elasticsearch/elasticsearch-1.4.2.noarch.rpm

Done.

ElasticSearch updates rather frequently, so be sure to check the
[ElasticSearch download page](http://www.elasticsearch.org/overview/elkdownloads/) for the most up
to date version.

This will install ElasticSearch into `/usr/share/elasticsearch`, your data in
`/var/lib/elasticsearch`, a configuration file at `/etc/elasticsearch/elasticsearch.yml`
and add it to **systemd** as `elasticsearch`.

Now we are going to install [Marvel](http://www.elasticsearch.org/overview/marvel/download/), an
ElasticSearch plugin to help you monitor the status of your (single-node) cluster, but more
importantly to install [Kibana](http://www.elasticsearch.org/overview/kibana/) easily.

    cd /usr/share/elasticsearch/
    bin/plugin -i elasticsearch/marvel/latest

#### Configuration

Open up `/etc/elasticsearch/elasticsearch.yml` with your favorite editor (it better be **vi**).

Head to about line 40, and change `node.name` to something useful and meaningful to you.  By
default, the node name changes every reboot, which could cause confusion to newbies.

    node.name: "esnode1"

Go to the bottom of the file and insert the following lines.

    # Protect against accidental close/delete operations on all indices.
    # You can still close/delete individual indices.
    action.disable_close_all_indices: true
    action.disable_delete_all_indices: true
    action.disable_shutdown: true

Save and exit.  Now let's restart ElasticSearch.

    systemctl restart elasticsearch

Browsing to `http://localhost:9200` you should see a simple JSON document much like the one below:

    {
        status: 200,
        name: "esnode1",
        cluster_name: "elasticsearch",
        version: {
            number: "1.4.2",
            build_hash: "927caff6f05403e936c20bf4529f144f0c89fd8c",
            build_timestamp: "2014-12-16T14:11:12Z",
            build_snapshot: false,
            lucene_version: "4.10.2"
        },
        tagline: "You Know, for Search"
    }

Congrats, ElasticSearch is working.

#### Caveats

The vanilla ElasticSearch has NO support for authentication and all commands are processed from
anyone, anywhere.  I recommend securing the ElasticSearch port or changing it.

A more comprehensive list on configuration changes is found on the ElasticSearch website,
[Important Configuration Changes](http://www.elasticsearch.org/guide/en/elasticsearch/guide/current/_important_configuration_changes.html).

#### Sample Data

ElasticSearch provides a sample database you can import.  It is 25MB and the commands are written
for the bulk import API.  Download it now.
[[`shakesphere.json`](http://www.elasticsearch.org/guide/en/kibana/current/snippets/shakespeare.json)]

Before importing any data, you want to finalize your mapping.  While there is a method for
[changing your mapping](http://www.elasticsearch.org/blog/changing-mapping-with-zero-downtime/),
you do not want to confuse yourself.

Normally, ElasticSearch indexes every field, and every word in the field, through the built-in
analyzer, separately.  In an example `full_name` field, "Justin Novack" will index both
"Justin" and "Novack".  This will become problematic later, trust me.  Additionally, the default
analyzer splits words by hyphens: "built-in", "hodge-podge", and "up-to-date" would be split
into "built" and "in", "hodge" and "podge" and "up", "to" and "date", respectively.

Both a static mapping and a dynamic mapping can help resolve this issue.  To import the static
mapping on the index `shakesphere` run the following:

    curl -XPUT http://localhost:9200/shakespeare -d '
    {
      "mappings" : {
        "_default_" : {
          "properties" : {
            "speaker" : {"type": "string", "index" : "not_analyzed" },
            "play_name" : {"type": "string", "index" : "not_analyzed" },
            "line_id" : { "type" : "integer" },
            "speech_number" : { "type" : "integer" }
          }
        }
      }
    }
    ';

This will ensure that both `speaker` and `play_name` are not analyzed by the built-in indexing
analyzer and the string will remain as "King Henry" rather than "King" and "Henry".

Now we can import the data.

    curl -XPUT http://localhost:9200/_bulk --data-binary @shakespeare.json

After a few minutes and lots of data on screen, you should have a fully populated database.

Navigate to `http://localhost:9200/_plugin/marvel/` and become familiar with your new cluster.

To see your data, navigate to
`http://elasticsearch:9200/_plugin/marvel/kibana/index.html#/dashboard/file/guided.json`.  When you
name and save this page, you will be presented with a new URL you can bookmark.

#### References

1. [http://www.elasticsearch.org/guide/en/kibana/current/using-kibana-for-the-first-time.html](http://www.elasticsearch.org/guide/en/kibana/current/using-kibana-for-the-first-time.html)
1. [http://www.elasticsearch.org/guide/en/elasticsearch/reference/current/index.html](http://www.elasticsearch.org/guide/en/elasticsearch/reference/current/index.html)