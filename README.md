# fluentd

This docker image base on [fluent/fluentd-docker-image](https://github.com/fluent/fluentd-docker-image) and add the following packages:

- fluent-plugin-elasticsearch
- fluent-plugin-rewrite-tag-filter
- fluent-plugin-grok-parser
- fluent

Then you can add logstash grok pattern file with -v:

```
docker run -v your_patterns_dir:/fluentd/grok -v your_fluentd_config:/fluentd/etc -d leejoneshane/fluent
```

Configuration your fluent.conf to use grok parser like below:

```
<source>
  @type syslog
  port 24224
  tag firewall
  <parse>
    @type grok
    custom_pattern_path /fluentd/grok
    <grok>
      name message
      pattern %{IPTABLES}
    </grok>
  </parse>
</source>
<filter firewall.**>
  @type geoip
  geoip_lookup_keys  source_ip
  backend_library geoip2_c
  <record>
    geoip {
        "country_iso_code": "${country.iso_code['source_ip']}",
        "country_name": "${country.names.en['source_ip']}",
        "postal_code": "${postal.code['source_ip']}",
        "region_iso_code": "${subdivisions.0.iso_code['source_ip']}",
        "region_name": "${subdivisions.0.names.en['source_ip']}",
        "city_name": "${city.names.en['source_ip']}",
        "location": {
          "lat": "${location.latitude['source_ip']}",
          "lon": "${location.longitude['source_ip']}"
        }
    }
  </record>
  skip_adding_null_record  true
</filter>
<match firewall.**>
    @type copy
    <store>
      @type elasticsearch
      host elasticsearch
      port 9200
      logstash_format true
      <buffer tag>
        @type file
        path /fluentd/buffer
        flush_thread_count 8
        flush_interval 1s
        chunk_limit_size 32M
        queue_limit_length 4
        retry_max_interval 30
        retry_forever true
      </buffer>
    </store>
    <store>
        @type stdout
    </store>
</match>
```

## What is Fluentd?

Fluentd is an open source data collector, which lets you unify the data
collection and consumption for a better use and understanding of data.

> [www.fluentd.org](https://www.fluentd.org/)

![Fluentd Logo](https://www.fluentd.org/images/miscellany/fluentd-logo_2x.png)
