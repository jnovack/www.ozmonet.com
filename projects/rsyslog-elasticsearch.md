---
layout: note
title: rSyslog and ElasticSearch
excerpt: Getting your syslogs into elasticsearch without LogStash.
promote: false
published: false
status: current
last_modified: 2015-01-16 13:37:00 -0400
---


    curl -XPUT localhost:9200/_template/logstash -d '
    {
      "template" : "logstash-*",
      "settings" : {
        "index.refresh_interval" : "5s"
      },
      "mappings" : {
        "_default_" : {
           "_all" : {"enabled" : true},
           "dynamic_templates" : [ {
             "string_fields" : {
               "match" : "*",
               "match_mapping_type" : "string",
               "mapping" : {
                 "type" : "string", "index" : "analyzed", "omit_norms" : true,
                   "fields" : {
                     "raw" : {"type": "string", "index" : "not_analyzed", "ignore_above" : 256}
                   }
               }
             }
           } ],
           "properties" : {
             "@version": { "type": "string", "index": "not_analyzed" },
             "geoip"  : {
               "type" : "object",
                 "dynamic": true,
                 "path": "full",
                 "properties" : {
                   "location" : { "type" : "geo_point" }
                 }
             }
           }
        }
      }
    }
    '



#### References

1. [http://www.rsyslog.com/output-to-elasticsearch-in-logstash-format-kibana-friendly/](http://www.rsyslog.com/output-to-elasticsearch-in-logstash-format-kibana-friendly/)