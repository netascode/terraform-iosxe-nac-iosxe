*** Settings ***
Documentation   Verify Prefix List Configuration
Suite Setup     Run Only Once   Get Configs
Resource        ../iosxe_common.resource
Default Tags    config   iosxe   prefix_lists

*** Test Cases ***

{% for device in iosxe.devices | default([]) %}
{% if device.configuration.prefix_lists is defined %}
Get Config {{ device.name }}
    ${config}=   Get Parallel Value For Key   {{ device.name }}_config
    Set Suite Variable   ${config}

{% for prefix_list in device.configuration.prefix_lists | default([]) %}
Verify Prefix List {{ prefix_list.name }} Device {{ device.name }}
    ${pl_xpath}=   Set Variable   data/native/ip/prefix-lists
{% if prefix_list.description is defined %}
    Should Be Equal Value Xml String   ${config}   ${pl_xpath}/prefix-list-description[name='{{ prefix_list.name }}']/name   {{ prefix_list.name }}
    Should Be Equal Value Xml String   ${config}   ${pl_xpath}/prefix-list-description[name='{{ prefix_list.name }}']/description   {{ prefix_list.description | default(defaults.iosxe.configuration.prefix_lists.description) | default() }}
{% endif %}
{% for seq in prefix_list.seqs | default([]) %}
    Should Be Equal Value Xml String   ${config}   ${pl_xpath}/prefixes[name='{{ prefix_list.name }}'][no='{{ seq.seq }}']/name   {{ prefix_list.name }}
    Should Be Equal Value Xml Numeric   ${config}   ${pl_xpath}/prefixes[name='{{ prefix_list.name }}'][no='{{ seq.seq }}']/no   {{ seq.seq }}
    Should Be Equal Value Xml String   ${config}   ${pl_xpath}/prefixes[name='{{ prefix_list.name }}'][no='{{ seq.seq }}']/action   {{ seq.action | default(defaults.iosxe.configuration.prefix_lists.seqs.action) | default() }}
    Should Be Equal Value Xml String   ${config}   ${pl_xpath}/prefixes[name='{{ prefix_list.name }}'][no='{{ seq.seq }}']/ip   {{ seq.prefix | default(defaults.iosxe.configuration.prefix_lists.seqs.prefix) | default() }}
    Should Be Equal Value Xml Numeric   ${config}   ${pl_xpath}/prefixes[name='{{ prefix_list.name }}'][no='{{ seq.seq }}']/ge   {{ seq.greater_equal | default(defaults.iosxe.configuration.prefix_lists.seqs.greater_equal) | default() }}
    Should Be Equal Value Xml Numeric   ${config}   ${pl_xpath}/prefixes[name='{{ prefix_list.name }}'][no='{{ seq.seq }}']/le   {{ seq.less_equal | default(defaults.iosxe.configuration.prefix_lists.seqs.less_equal) | default() }}
{% endfor %}
{% endfor %}
{% endif %}
{% endfor %}

