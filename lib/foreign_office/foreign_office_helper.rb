module ForeignOffice
  module ForeignOfficeHelper
    def listener_attrs(resource, key, reveal_hide: false, endpoint: nil, trigger: nil)
      data_attrs = "data-listener=true data-channel=#{resource.class.name}#{resource.id} data-key=#{key}"
      data_attrs += " data-reveal-hide=true" if reveal_hide
      data_attrs += " data-endpoint=#{endpoint}" if endpoint
      data_attrs += " data-trigger-on-message=true" if trigger
      data_attrs
    end

    def listener_attrs_raw(channel, key, reveal_hide: false, endpoint: nil, trigger: nil)
      data_attrs = "data-listener=true data-channel=#{channel} data-key=#{key}"
      data_attrs += " data-reveal-hide=true" if reveal_hide
      data_attrs += " data-endpoint=#{endpoint}" if endpoint
      data_attrs += " data-trigger-on-message=true" if trigger
      data_attrs
    end

    def listener_hash(resource, key, reveal_hide: false, endpoint: nil, trigger: nil)
      hash = {listener: true, channel: resource.class.name + resource.id.to_s, key: key}
      hash[:reveal_hide] = true if reveal_hide
      hash[:endpoint] = endpoint if endpoint
      hash[:trigger_on_message] = true if trigger
      hash
    end
  end
end