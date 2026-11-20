from nac_validate import RuleBase, Violation


class Rule(RuleBase):
    id = "313"
    description = "Verify route-map match prefix-lists reference defined prefix-lists"
    severity = "HIGH"

    title = "ROUTE-MAP REFERENCES UNDEFINED PREFIX-LIST"
    affected_items_label = "Route-map entries referencing undefined prefix-lists"
    explanation = """\
"match ip address prefix-list" and "match ipv6 address prefix-list" in a
route-map must reference an existing IPv4 or IPv6 prefix-list. IOS-XE
accepts a reference to an undefined prefix-list, but the entry then
matches differently than intended, which silently changes routing
policy."""
    recommendation = """\
Define the prefix-list (prefix_lists for IPv4, ipv6_prefix_lists for
IPv6) or fix the route-map reference:

  iosxe:
    devices:
      - name: Router1
        configuration:
          prefix_lists:
            - name: PL_DEFAULT
              seqs:
                - seq: 10
                  action: permit
                  prefix: 0.0.0.0/0
          route_maps:
            - name: RM_IN
              entries:
                - seq: 10
                  operation: permit
                  match:
                    ipv4_address_prefix_lists:
                      - PL_DEFAULT"""

    # match attribute -> prefix list section it references
    FIELDS = (
        ("ipv4_address_prefix_lists", "prefix_lists"),
        ("ipv4_next_hop_prefix_lists", "prefix_lists"),
        ("ipv6_address_prefix_lists", "ipv6_prefix_lists"),
        ("ipv6_next_hop_prefix_lists", "ipv6_prefix_lists"),
    )

    @classmethod
    def match(cls, inventory):
        violations = []
        for device in (inventory.get("iosxe") or {}).get("devices") or []:
            device_name = device.get("name", "")
            config = device.get("configuration") or {}
            defined = {
                section: {
                    pl.get("name") for pl in config.get(section) or [] if pl.get("name")
                }
                for section in ("prefix_lists", "ipv6_prefix_lists")
            }
            for rm in config.get("route_maps") or []:
                rm_name = rm.get("name")
                for entry in rm.get("entries") or []:
                    seq = entry.get("seq")
                    match_config = entry.get("match") or {}
                    for field, section in cls.FIELDS:
                        refs = match_config.get(field) or []
                        if isinstance(refs, str):
                            refs = [refs]
                        for ref in refs:
                            if not ref or ref in defined[section]:
                                continue
                            violations.append(
                                Violation(
                                    message=f"{field} references undefined prefix-list '{ref}'",
                                    path=(
                                        f"iosxe.devices[name={device_name}].configuration"
                                        f".route_maps[name={rm_name}].entries[seq={seq}]"
                                        f".match.{field}"
                                    ),
                                    details={
                                        "device": device_name,
                                        "route_map": rm_name,
                                        "seq": seq,
                                        "field": field,
                                        "prefix_list": ref,
                                    },
                                )
                            )
        return violations
