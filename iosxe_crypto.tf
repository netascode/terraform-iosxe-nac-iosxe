locals {
  ipsec_profiles = flatten([
    for device in local.devices : [
      for profile in try(local.device_config[device.name].crypto.ipsec_profiles, []) : {
        key    = format("%s%s", device.name, profile.name)
        device = device.name

        name                                                                = profile.name
        set_transform_set                                                   = try(profile.set_transform_set, local.defaults.iosxe.configuration.crypto.ipsec_profiles.set_transform_set, null)
        set_isakmp_profile_ikev2_profile_ikev2_profile_case_ikev2_profile   = try(profile.set_isakmp_profile_ikev2_profile_ikev2_profile_case_ikev2_profile, local.defaults.iosxe.configuration.crypto.ipsec_profiles.set_isakmp_profile_ikev2_profile_ikev2_profile_case_ikev2_profile, null)
        set_isakmp_profile_ikev2_profile_isakmp_profile_case_isakmp_profile = try(profile.set_isakmp_profile_ikev2_profile_isakmp_profile_case_isakmp_profile, local.defaults.iosxe.configuration.crypto.ipsec_profiles.set_isakmp_profile_ikev2_profile_isakmp_profile_case_isakmp_profile, null)
      }
    ]
  ])
}

resource "iosxe_crypto_ipsec_profile" "crypto_ipsec_profile" {
  for_each                                                            = { for e in local.ipsec_profiles : e.key => e }
  device                                                              = each.value.device
  name                                                                = each.value.name
  set_transform_set                                                   = each.value.set_transform_set
  set_isakmp_profile_ikev2_profile_ikev2_profile_case_ikev2_profile   = each.value.set_isakmp_profile_ikev2_profile_ikev2_profile_case_ikev2_profile
  set_isakmp_profile_ikev2_profile_isakmp_profile_case_isakmp_profile = each.value.set_isakmp_profile_ikev2_profile_isakmp_profile_case_isakmp_profile
}

locals {
  ipsec_transform_sets = flatten([
    for device in local.devices : [
      for transform_set in try(local.device_config[device.name].crypto.ipsec_transform_sets, []) : {
        key    = format("%s%s", device.name, transform_set.name)
        device = device.name

        name        = transform_set.name
        esp         = transform_set.esp
        esp_hmac    = transform_set.esp_hmac
        mode_tunnel = try(transform_set.mode_tunnel, local.defaults.iosxe.configuration.crypto.ipsec_transform_sets.mode_tunnel, null)
      }
    ]
  ])
}

resource "iosxe_crypto_ipsec_transform_set" "crypto_ipsec_transform_set" {
  for_each    = { for e in local.ipsec_transform_sets : e.key => e }
  device      = each.value.device
  name        = each.value.name
  esp         = each.value.esp
  esp_hmac    = each.value.esp_hmac
  mode_tunnel = each.value.mode_tunnel
}

resource "iosxe_crypto_ikev2" "crypto_ikev2" {
  for_each = { for device in local.devices : device.name => device if try(local.device_config[device.name].crypto.ikev2, null) != null || try(local.defaults.iosxe.configuration.crypto.ikev2, null) != null }
  device   = each.value.name

  dpd                = try(local.device_config[each.value.name].crypto.ikev2.dpd_interval, local.defaults.iosxe.configuration.crypto.ikev2.dpd_interval, null)
  dpd_query          = try(local.device_config[each.value.name].crypto.ikev2.dpd_query, local.defaults.iosxe.configuration.crypto.ikev2.dpd_query, null)
  dpd_retry_interval = try(local.device_config[each.value.name].crypto.ikev2.dpd_retry, local.defaults.iosxe.configuration.crypto.ikev2.dpd_retry, null)
  nat_keepalive      = try(local.device_config[each.value.name].crypto.ikev2.nat_keepalive, local.defaults.iosxe.configuration.crypto.ikev2.nat_keepalive, null)
}

locals {
  ikev2_profiles = flatten([
    for device in local.devices : [
      for profile in try(local.device_config[device.name].crypto.ikev2.profiles, []) : {
        key    = format("%s%s", device.name, profile.name)
        device = device.name

        name                            = profile.name
        authentication_local_pre_share  = try(profile.authentication_local_pre_share, local.defaults.iosxe.configuration.crypto.ikev2.profiles.authentication_local_pre_share, null)
        authentication_remote_pre_share = try(profile.authentication_remote_pre_share, local.defaults.iosxe.configuration.crypto.ikev2.profiles.authentication_remote_pre_share, null)
        config_exchange_request         = try(profile.config_exchange_request, local.defaults.iosxe.configuration.crypto.ikev2.profiles.config_exchange_request, null)
        description                     = try(profile.description, local.defaults.iosxe.configuration.crypto.ikev2.profiles.description, null)
        dpd_interval                    = try(profile.dpd_interval, local.defaults.iosxe.configuration.crypto.ikev2.profiles.dpd_interval, null)
        dpd_query                       = try(profile.dpd_query, local.defaults.iosxe.configuration.crypto.ikev2.profiles.dpd_query, null)
        dpd_retry                       = try(profile.dpd_retry, local.defaults.iosxe.configuration.crypto.ikev2.profiles.dpd_retry, null)
        identity_local_address          = try(profile.identity_local_address, local.defaults.iosxe.configuration.crypto.ikev2.profiles.identity_local_address, null)
        identity_local_key_id           = try(profile.identity_local_key_id, local.defaults.iosxe.configuration.crypto.ikev2.profiles.identity_local_key_id, null)
        ivrf                            = try(profile.ivrf, local.defaults.iosxe.configuration.crypto.ikev2.profiles.ivrf, null)
        keyring_local                   = try(profile.keyring_local, local.defaults.iosxe.configuration.crypto.ikev2.profiles.keyring_local, null)
        match_address_local_ip          = try(profile.match_address_local_ip, local.defaults.iosxe.configuration.crypto.ikev2.profiles.match_address_local_ip, null)
        match_fvrf                      = try(profile.match_fvrf, local.defaults.iosxe.configuration.crypto.ikev2.profiles.match_fvrf, null)
        match_fvrf_any                  = try(profile.match_fvrf_any, local.defaults.iosxe.configuration.crypto.ikev2.profiles.match_fvrf_any, null)
        match_identity_remote_ipv4_addresses = [for e in try(profile.match_identity_remote_ipv4_addresses, []) : {
          address = e.address
          mask    = try(e.mask, local.defaults.iosxe.configuration.crypto.ikev2.profiles.match_identity_remote_ipv4_addresses.mask, null)
        }]
        match_identity_remote_ipv6_prefixes = try(profile.match_identity_remote_ipv6_prefixes, local.defaults.iosxe.configuration.crypto.ikev2.profiles.match_identity_remote_ipv6_prefixes, null)
        match_identity_remote_keys          = try(profile.match_identity_remote_keys, local.defaults.iosxe.configuration.crypto.ikev2.profiles.match_identity_remote_keys, null)
        match_inbound_only                  = try(profile.match_inbound_only, local.defaults.iosxe.configuration.crypto.ikev2.profiles.match_inbound_only, null)
      }
    ]
  ])
}

resource "iosxe_crypto_ikev2_profile" "crypto_ikev2_profile" {
  for_each                             = { for e in local.ikev2_profiles : e.key => e }
  device                               = each.value.device
  name                                 = each.value.name
  authentication_local_pre_share       = each.value.authentication_local_pre_share
  authentication_remote_pre_share      = each.value.authentication_remote_pre_share
  config_exchange_request              = each.value.config_exchange_request
  description                          = each.value.description
  dpd_interval                         = each.value.dpd_interval
  dpd_query                            = each.value.dpd_query
  dpd_retry                            = each.value.dpd_retry
  identity_local_address               = each.value.identity_local_address
  identity_local_key_id                = each.value.identity_local_key_id
  ivrf                                 = each.value.ivrf
  keyring_local                        = each.value.keyring_local
  match_address_local_ip               = each.value.match_address_local_ip
  match_fvrf                           = each.value.match_fvrf
  match_fvrf_any                       = each.value.match_fvrf_any
  match_identity_remote_ipv4_addresses = each.value.match_identity_remote_ipv4_addresses
  match_identity_remote_ipv6_prefixes  = each.value.match_identity_remote_ipv6_prefixes
  match_identity_remote_keys           = each.value.match_identity_remote_keys
  match_inbound_only                   = each.value.match_inbound_only
}

locals {
  ikev2_keyrings = flatten([
    for device in local.devices : [
      for keyring in try(local.device_config[device.name].crypto.ikev2.keyrings, []) : {
        key    = format("%s%s", device.name, keyring.name)
        device = device.name

        name = keyring.name
        peers = [for e in try(keyring.peers, []) : {
          name                             = e.name
          description                      = try(e.description, local.defaults.iosxe.configuration.crypto.ikev2.keyrings.peers.description, null)
          hostname                         = try(e.hostname, local.defaults.iosxe.configuration.crypto.ikev2.keyrings.peers.hostname, null)
          identity_address                 = try(e.identity_address, local.defaults.iosxe.configuration.crypto.ikev2.keyrings.peers.identity_address, null)
          identity_email_domain            = try(e.identity_email_domain, local.defaults.iosxe.configuration.crypto.ikev2.keyrings.peers.identity_email_domain, null)
          identity_email_name              = try(e.identity_email_name, local.defaults.iosxe.configuration.crypto.ikev2.keyrings.peers.identity_email_name, null)
          identity_fqdn_domain             = try(e.identity_fqdn_domain, local.defaults.iosxe.configuration.crypto.ikev2.keyrings.peers.identity_fqdn_domain, null)
          identity_fqdn_name               = try(e.identity_fqdn_name, local.defaults.iosxe.configuration.crypto.ikev2.keyrings.peers.identity_fqdn_name, null)
          identity_key_id                  = try(e.identity_key_id, local.defaults.iosxe.configuration.crypto.ikev2.keyrings.peers.identity_key_id, null)
          ipv4_address                     = try(e.ipv4_address, local.defaults.iosxe.configuration.crypto.ikev2.keyrings.peers.ipv4_address, null)
          ipv4_mask                        = try(e.ipv4_mask, local.defaults.iosxe.configuration.crypto.ikev2.keyrings.peers.ipv4_mask, null)
          ipv6_prefix                      = try(e.ipv6_prefix, local.defaults.iosxe.configuration.crypto.ikev2.keyrings.peers.ipv6_prefix, null)
          pre_shared_key                   = try(e.pre_shared_key, local.defaults.iosxe.configuration.crypto.ikev2_keyrings.peers.pre_shared_key, null)
          pre_shared_key_encryption        = try(e.pre_shared_key_encryption, local.defaults.iosxe.configuration.crypto.ikev2.keyrings.peers.pre_shared_key_encryption, null)
          pre_shared_key_local             = try(e.pre_shared_key_local, local.defaults.iosxe.configuration.crypto.ikev2.keyrings.peers.pre_shared_key_local, null)
          pre_shared_key_local_encryption  = try(e.pre_shared_key_local_encryption, local.defaults.iosxe.configuration.crypto.ikev2.keyrings.peers.pre_shared_key_local_encryption, null)
          pre_shared_key_remote            = try(e.pre_shared_key_remote, local.defaults.iosxe.configuration.crypto.ikev2.keyrings.peers.pre_shared_key_remote, null)
          pre_shared_key_remote_encryption = try(e.pre_shared_key_remote_encryption, local.defaults.iosxe.configuration.crypto.ikev2.keyrings.peers.pre_shared_key_remote_encryption, null)
        }]
      }
    ]
  ])
}

resource "iosxe_crypto_ikev2_keyring" "crypto_ikev2_keyring" {
  for_each = { for e in local.ikev2_keyrings : e.key => e }
  device   = each.value.device
  name     = each.value.name
  peers    = each.value.peers
}

locals {
  ikev2_policies = flatten([
    for device in local.devices : [
      for policy in try(local.device_config[device.name].crypto.ikev2.policies, []) : {
        key    = format("%s%s", device.name, policy.name)
        device = device.name

        name = policy.name
        proposals = [for e in try(policy.proposals, []) : {
          proposals = e.proposals
        }]
        match_address_local_ip = try(policy.match_address_local_ip, local.defaults.iosxe.configuration.crypto.ikev2.policies.match_address_local_ip, null)
        match_fvrf             = try(policy.match_fvrf, local.defaults.iosxe.configuration.crypto.ikev2.policies.match_fvrf, null)
        match_fvrf_any         = try(policy.match_fvrf_any, local.defaults.iosxe.configuration.crypto.ikev2.policies.match_fvrf_any, null)
        match_inbound_only     = try(policy.match_inbound_only, local.defaults.iosxe.configuration.crypto.ikev2.policies.match_inbound_only, null)
      }
    ]
  ])
}

resource "iosxe_crypto_ikev2_policy" "crypto_ikev2_policy" {
  for_each               = { for e in local.ikev2_policies : e.key => e }
  device                 = each.value.device
  name                   = each.value.name
  proposals              = each.value.proposals
  match_address_local_ip = each.value.match_address_local_ip
  match_fvrf             = each.value.match_fvrf
  match_fvrf_any         = each.value.match_fvrf_any
  match_inbound_only     = each.value.match_inbound_only
}

locals {
  ikev2_proposals = flatten([
    for device in local.devices : [
      for proposal in try(local.device_config[device.name].crypto.ikev2.proposals, []) : {
        key    = format("%s%s", device.name, proposal.name)
        device = device.name

        name                   = proposal.name
        encryption_aes_cbc_128 = try(proposal.encryption_aes_cbc_128, local.defaults.iosxe.configuration.crypto.ikev2.proposals.encryption_aes_cbc_128, null)
        encryption_aes_cbc_192 = try(proposal.encryption_aes_cbc_192, local.defaults.iosxe.configuration.crypto.ikev2.proposals.encryption_aes_cbc_192, null)
        encryption_aes_cbc_256 = try(proposal.encryption_aes_cbc_256, local.defaults.iosxe.configuration.crypto.ikev2.proposals.encryption_aes_cbc_256, null)
        encryption_aes_gcm_128 = try(proposal.encryption_aes_gcm_128, local.defaults.iosxe.configuration.crypto.ikev2.proposals.encryption_aes_gcm_128, null)
        encryption_aes_gcm_256 = try(proposal.encryption_aes_gcm_256, local.defaults.iosxe.configuration.crypto.ikev2.proposals.encryption_aes_gcm_256, null)
        encryption_en_3des     = try(proposal.encryption_en_3des, local.defaults.iosxe.configuration.crypto.ikev2.proposals.encryption_en_3des, null)
        group_fifteen          = try(proposal.group_fifteen, local.defaults.iosxe.configuration.crypto.ikev2.proposals.group_fifteen, null)
        group_fourteen         = try(proposal.group_fourteen, local.defaults.iosxe.configuration.crypto.ikev2.proposals.group_fourteen, null)
        group_nineteen         = try(proposal.group_nineteen, local.defaults.iosxe.configuration.crypto.ikev2.proposals.group_nineteen, null)
        group_one              = try(proposal.group_one, local.defaults.iosxe.configuration.crypto.ikev2.proposals.group_one, null)
        group_sixteen          = try(proposal.group_sixteen, local.defaults.iosxe.configuration.crypto.ikev2.proposals.group_sixteen, null)
        group_twenty           = try(proposal.group_twenty, local.defaults.iosxe.configuration.crypto.ikev2.proposals.group_twenty, null)
        group_twenty_four      = try(proposal.group_twenty_four, local.defaults.iosxe.configuration.crypto.ikev2.proposals.group_twenty_four, null)
        group_twenty_one       = try(proposal.group_twenty_one, local.defaults.iosxe.configuration.crypto.ikev2.proposals.group_twenty_one, null)
        group_two              = try(proposal.group_two, local.defaults.iosxe.configuration.crypto.ikev2.proposals.group_two, null)
        integrity_md5          = try(proposal.integrity_md5, local.defaults.iosxe.configuration.crypto.ikev2.proposals.integrity_md5, null)
        integrity_sha1         = try(proposal.integrity_sha1, local.defaults.iosxe.configuration.crypto.ikev2.proposals.integrity_sha1, null)
        integrity_sha256       = try(proposal.integrity_sha256, local.defaults.iosxe.configuration.crypto.ikev2.proposals.integrity_sha256, null)
        integrity_sha384       = try(proposal.integrity_sha384, local.defaults.iosxe.configuration.crypto.ikev2.proposals.integrity_sha384, null)
        integrity_sha512       = try(proposal.integrity_sha512, local.defaults.iosxe.configuration.crypto.ikev2.proposals.integrity_sha512, null)
        prf_md5                = try(proposal.prf_md5, local.defaults.iosxe.configuration.crypto.ikev2.proposals.prf_md5, null)
        prf_sha1               = try(proposal.prf_sha1, local.defaults.iosxe.configuration.crypto.ikev2.proposals.prf_sha1, null)
        prf_sha256             = try(proposal.prf_sha256, local.defaults.iosxe.configuration.crypto.ikev2.proposals.prf_sha256, null)
        prf_sha384             = try(proposal.prf_sha384, local.defaults.iosxe.configuration.crypto.ikev2.proposals.prf_sha384, null)
        prf_sha512             = try(proposal.prf_sha512, local.defaults.iosxe.configuration.crypto.ikev2.proposals.prf_sha512, null)
      }
    ]
  ])
}

resource "iosxe_crypto_ikev2_proposal" "crypto_ikev2_proposal" {
  for_each               = { for e in local.ikev2_proposals : e.key => e }
  device                 = each.value.device
  name                   = each.value.name
  encryption_aes_cbc_128 = each.value.encryption_aes_cbc_128
  encryption_aes_cbc_192 = each.value.encryption_aes_cbc_192
  encryption_aes_cbc_256 = each.value.encryption_aes_cbc_256
  encryption_aes_gcm_128 = each.value.encryption_aes_gcm_128
  encryption_aes_gcm_256 = each.value.encryption_aes_gcm_256
  encryption_en_3des     = each.value.encryption_en_3des
  group_fifteen          = each.value.group_fifteen
  group_fourteen         = each.value.group_fourteen
  group_nineteen         = each.value.group_nineteen
  group_one              = each.value.group_one
  group_sixteen          = each.value.group_sixteen
  group_twenty           = each.value.group_twenty
  group_twenty_four      = each.value.group_twenty_four
  group_twenty_one       = each.value.group_twenty_one
  group_two              = each.value.group_two
  integrity_md5          = each.value.integrity_md5
  integrity_sha1         = each.value.integrity_sha1
  integrity_sha256       = each.value.integrity_sha256
  integrity_sha384       = each.value.integrity_sha384
  integrity_sha512       = each.value.integrity_sha512
  prf_md5                = each.value.prf_md5
  prf_sha1               = each.value.prf_sha1
  prf_sha256             = each.value.prf_sha256
  prf_sha384             = each.value.prf_sha384
  prf_sha512             = each.value.prf_sha512
}