module ForeignOffice
  module ForeignOfficeHelper
    def listener_attrs(resource, key, reveal_hide: false, endpoint: nil, download: nil,
      trigger: nil, delete: nil, href_target: nil, create_modal: nil, mask_me: nil,
      exclude_value: nil, browser_tab_id: nil)
      presence_prefix = resource.class.channel_presence_required? ? 'presence-' : ''
      channel = "#{presence_prefix}#{resource.class.foreign_office_channel_prefix}#{resource.id}"
      channel += "@#{browser_tab_id}" if browser_tab_id
      data_attrs = "data-listener=true data-channel=#{channel}"
      if delete
        data_attrs += " data-delete-key=#{key}"
      else
        data_attrs += " data-key=#{key}"
      end
      data_attrs += " data-exclude-value=#{exclude_value}" if exclude_value
      data_attrs += " data-reveal-hide=true" if reveal_hide
      data_attrs += " data-endpoint=#{endpoint}" if endpoint
      data_attrs += " data-trigger-on-message=true" if trigger
      data_attrs += " data-download=true" if download
      data_attrs += " data-href-target=true" if href_target
      data_attrs += " data-mask-me=#{mask_me}" if mask_me
      data_attrs += " data-create-modal=#{create_modal}" if create_modal
      data_attrs
    end

    def progress_indicator_attrs(resource, key)
      data_attrs = "data-foreign-office-progress-indicator=true data-channel=#{resource.class.foreign_office_channel_prefix}#{resource.id}"
      data_attrs += " data-key=#{key}"
    end

    def listener_attrs_raw(channel, key, reveal_hide: false, endpoint: nil, download: nil,
      trigger: nil, delete: nil, href_target: nil, create_modal: nil, mask_me: nil,
      exclude_value: nil, browser_tab_id: nil)
      channel += "@#{browser_tab_id}" if browser_tab_id
      data_attrs = "data-listener=true data-channel=#{channel}"
      if delete
        data_attrs += " data-delete-key=#{key}"
      else
        data_attrs += " data-key=#{key}"
      end
      data_attrs += " data-reveal-hide=true" if reveal_hide
      data_attrs += " data-endpoint=#{exclude_value}" if exclude_value
      data_attrs += " data-endpoint=#{endpoint}" if endpoint
      data_attrs += " data-download=true" if download
      data_attrs += " data-trigger-on-message=true" if trigger
      data_attrs += " data-href-target=true" if href_target
      data_attrs += " data-mask-me=#{mask_me}" if mask_me
      data_attrs += " data-create-modal=#{create_modal}" if create_modal
      data_attrs
    end

    def listener_hash(resource, key, reveal_hide: false, endpoint: nil, download: nil,
      trigger: nil, delete: nil, href_target: nil, create_modal: nil, mask_me: nil,
      exclude_value: nil, browser_tab_id: nil)
      presence_prefix = resource.class.channel_presence_required? ? 'presence-' : ''
      channel = "#{presence_prefix}#{resource.class.foreign_office_channel_prefix}#{resource.id}"
      channel += "@#{browser_tab_id}" if browser_tab_id
      hash = {listener: true, channel: channel}
      if delete
        hash[:delete_key] = key
      else
        hash[:key] = key
      end
      hash[:reveal_hide] = true if reveal_hide
      hash[:endpoint] = endpoint if endpoint
      hash[:exclude_value] = exclude_value if exclude_value
      hash[:download] = true if download
      hash[:trigger_on_message] = true if trigger
      hash[:href_target] = true if href_target
      hash[:create_modal] = create_modal if create_modal
      hash[:mask_me] = mask_me if mask_me
      hash
    end

    def listener_hash_raw(channel, key, reveal_hide: false, endpoint: nil, download: nil,
      trigger: nil, delete: nil, href_target: nil, create_modal: nil, mask_me: nil,
      exclude_value: nil, browser_tab_id: nil)
      channel += "@#{browser_tab_id}" if browser_tab_id
      hash = {listener: true, channel: channel}
      if delete
        hash[:delete_key] = key
      else
        hash[:key] = key
      end
      hash[:reveal_hide] = true if reveal_hide
      hash[:endpoint] = endpoint if endpoint
      hash[:exclude_value] = exclude_value if exclude_value
      hash[:download] = true if download
      hash[:trigger_on_message] = true if trigger
      hash[:href_target] = true if href_target
      hash[:create_modal] = create_modal if create_modal
      hash[:mask_me] = mask_me if mask_me
      hash
    end
  end
end
