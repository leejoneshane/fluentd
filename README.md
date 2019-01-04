# fluentd
This docker image base on [fluent/fluentd-docker-image](https://github.com/fluent/fluentd-docker-image) and add the following packages:
- fluent-plugin-elasticsearch
- fluent-plugin-rewrite-tag-filter
- fluent-plugin-grok-parser

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
      name iptables
      pattern %{IPTABLES}
    </grok>
    <grok>
      name fortigate
      pattern %{FORTIGATE}
    </grok>
  </parse>
</source>

<match **>
    @type copy
    <store>
      @type elasticsearch
      host elasticsearch
      port 9200
      logstash_format true
      <buffer tag>
        @type memory
        flush_thread_count 4
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

![Fluentd Logo](https://www.fluentd.org/assets/img/miscellany/fluentd-logo.png)
