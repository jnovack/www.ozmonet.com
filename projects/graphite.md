---
layout: note
title: Graphite on CentOS 7
excerpt: Hurdles I had to overcome installing my first graphite instance. All other documentation was confusing.
promote: true
published: true
status: current
last_modified: 2014-08-01 13:37:00 -0400
---

#### Preface

It is bittersweet being the 'tinkerer' out of my friends; on the upside, I love the attention and it satisfies
the little scientist in me.  On the downside, I usually have to figure it out myself, and usually cannot ask my friends
for help or insight, as they occasionally just do not care until it is done.

Like the rest of you, once I read [the inspirational blog post](http://codeascraft.com/2011/02/15/measure-anything-measure-everything/)
introducing StatsD by Etsy's engineering team, I had to install it. It just seemed so simple! Boy was I wrong.

Before you get started, [this blog post](http://kevinmccarthy.org/blog/2013/07/18/10-things-i-learned-deploying-graphite/)
covers a lot of the basics.  If you are unfamiliar with Graphite, go read sections 1, 2 and 3.  Then come back here.

Sections 4 and on deal with hurdles he had to overcome while installing, do not get bogged down with those yet. Go! I will wait.

#### Introduction

Graphite is a generic name for a complicated Rube Golderburg-esque group of applications all doing a specific
piece of the puzzle.  It is named as such, because Graphite is the name of the (original) front-end.

There are a number of different applications which make up the core package...

* Graphite - This is the web front-end, where you will design your graphs or just play around with the data.
* Carbon - Receives metrics over the network and writes them down to disk using a storage backend.
* Whisper - Similar to RRDTool, stores time-series data in a non-growable database. (Alternate: Ceres)

...and a number of helper applications, which not required, but do make things helpful.

* StatsD - An aggregator which bulk pushes data to Carbon after a flush interval.
* CollectD - A data collector similar to Nagios or Munin which sends data directly to Carbon.

#### Installation

We are going to install each of those five (5) components, so using a base CentOS 7 image, I ran the following:

    yum -y update
    yum install -y httpd net-snmp perl pycairo mod_wsgi python-devel git gcc-c++

After adding the EPEL repo (pretty much a requirement these days), I finished the installation.

    yum install -y python-pip node npm

I did the graphite install within pip, which means I had some caveats.  You might be able to rpm some of these to
avoid having to install specific versions.

    pip install 'django<1.6'
    pip install 'Twisted<12'
    pip install django-tagging
    pip install whisper
    pip install graphite-web
    pip install carbon

Finally, let's get grab the additional components.

    yum install collectd collectd-snmp
    git clone https://github.com/etsy/statsd.git /usr/local/src/statsd/

##### Configuration

That was the easy part! Now time to pull our your hair.  Until I get more time to explain, here are my configs.

    cp example-graphite-vhost.conf /etc/httpd/conf.d/graphite.conf
    cp /opt/graphite/conf/storage-schemas.conf.example /opt/graphite/conf/storage-schemas.conf
    cp /opt/graphite/conf/storage-aggregation.conf.example /opt/graphite/conf/storage-aggregation.conf
    cp /opt/graphite/conf/graphite.wsgi.example /opt/graphite/conf/graphite.wsgi
    cp /opt/graphite/conf/graphTemplates.conf.example /opt/graphite/conf/graphTemplates.conf
    chown -R apache:apache /opt/graphite/storage/

`/opt/graphite/conf/storage-schemas.conf`

    [default]
    pattern = .*
    retentions = 10s:4h, 1m:3d, 5m:8d, 15m:32d, 1h:1y

If the retentions line is parsed improperly, you will get a `ValueError: need more than 1 value to unpack` error.
Double check your commas and colons to make sure your lines are proper.

The above code makes every statistic save 10 seconds for 4 hours, which then aggregates to 1 minute for 3 days,
5 minutes for 8 days, and finally 1 hour for 1 year.  This is an important topic, and you will not want this for
ALL of your metrics, but we will put a pin in this topic for now.

Create a super-user in graphite to save your graphs.

    cd /opt/graphite/webapp/graphite
    sudo python manage.py syncdb

#### Getting Started

_What do you mean we are not started yet??_  Relax, there are a lot of moving pieces to this.

    systemctl enable httpd
    systemctl start httpd
    /opt/graphite/bin/carbon-cache.py start

You can run the graphite development server just to make sure you have the front-end in order.

    /opt/graphite/bin/run-graphite-devel-server.py /opt/graphite/

If everything works, it will be started on port `:8080` with errors being displayed in the console. If that works,
the browse to the `http://localhost` and get the real application.

#### Collection

The helper applications are there to make your collection life easier.  You can fire off stats directly to Carbon,
there is nothing stopping you.  If you have a metric to capture at a time, send it to carbon directly.

    echo "local.random.diceroll 4 `date +%s`" | nc localhost 2003

However, if you have a need to consolidate data over time (sum/rate data BEFORE it gets to Carbon) or need something
to go out and get metrics (e.g. snmp polling) then you will want the helper applications.

For a small installation, these can be installed on the same server. As your installation grows, you will want to peel
off your collection daemons first.

##### StatsD

[StatsD](https://github.com/etsy/statsd/) is an amazingly simple application designed to "bucket" the statistics and
"flush" them at a predefined interval (along with addidional meta-statistics).  StatsD is designed to be run distributed
so that you can split the load.  Since it is just listening for data and sending it off in an interval, resource
utilization is relatively low.

    cd /usr/local/src/
    node stats.js exampleConfig.js

This is going to run in the console, you are probably better off installing `forever` and running in the background.

    npm install forever -g
    forever start --uid 'statsd' stats.js exampleConfig.js

Now is a good time to [read the rest of Kevin's post](http://kevinmccarthy.org/blog/2013/07/18/10-things-i-learned-deploying-graphite/#make-sure-that-your-statsd-flush-interval-is-at-least-as-long-as-your-graphite-interval)
as it covers a VERY IMPORTANT topic: **Storage and Aggregation Calculations**.

##### CollectD

[CollectD](http://collectd.org/) the system performance collection daemon that reminds me of Nagios.  The good part here,
is that it can send directly to Carbon rather than it's own RRDs.  CollectD has a number of plug-ins and can be run on
each of your servers, or on a collection server (like Nagios) to get stats on each remote device.  Resource utilization
is pretty high from CollectD, because it is actively seeking statistics.


#### References

1. [http://graphite.readthedocs.org/en/latest/](http://graphite.readthedocs.org/en/latest/)
1. [https://ezunix.org/index.php?title=Install_statsd_and_graphite_on_CentOS_or_RHEL](https://ezunix.org/index.php?title=Install_statsd_and_graphite_on_CentOS_or_RHEL)
1. [http://stackoverflow.com/questions/19894708/cant-start-carbon-12-04-python-error-importerror-cannot-import-name-daem](http://stackoverflow.com/questions/19894708/cant-start-carbon-12-04-python-error-importerror-cannot-import-name-daem)
1. [http://stackoverflow.com/questions/17259279/valueerror-when-trying-to-start-carbon-cache](http://stackoverflow.com/questions/17259279/valueerror-when-trying-to-start-carbon-cache)
1. [http://wiki.cementhorizon.com/display/CH/How+to+install+graphite+on+a+bare+metal+CentOS+6.2+machine](http://wiki.cementhorizon.com/display/CH/How+to+install+graphite+on+a+bare+metal+CentOS+6.2+machine)
1. [http://blog.pkhamre.com/2012/07/24/understanding-statsd-and-graphite/](http://blog.pkhamre.com/2012/07/24/understanding-statsd-and-graphite/)
1. [http://bucksnort.pennington.net/blog/post/collectd-snmp-graphite/](http://bucksnort.pennington.net/blog/post/collectd-snmp-graphite/)
1. [https://gist.github.com/DrPheltRight/1071989](https://gist.github.com/DrPheltRight/1071989)