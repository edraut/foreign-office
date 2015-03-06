module ForeignOffice
  module ForeignOfficeHelper
    def listener_attrs(resource, key, reveal_hide: false)
      data_attrs = "data-listener=true data-channel=#{resource.class.name}#{resource.id} data-key=#{key}"
      data_attrs += " data-reveal-hide=true" if reveal_hide
      data_attrs
    end

    def listener_attrs_raw(channel, key, reveal_hide: false)
      data_attrs = "data-listener=true data-channel=#{channel} data-key=#{key}"
      data_attrs += " data-reveal-hide=true" if reveal_hide
      data_attrs
    end

    def listener_hash(resource, key, reveal_hide: false)
      hash = {listener: true, channel: resource.class.name + resource.id.to_s, key: key}
      hash[:reveal_hide] = true if reveal_hide
      hash
    end
  end
end