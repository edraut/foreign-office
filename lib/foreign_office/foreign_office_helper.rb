module ForeignOffice
  module ForeignOfficeHelper
    def listener_attrs(resource, key, subtype: nil)
      data_attrs = "data-listener=true data-channel=#{resource.class.name}#{resource.id} data-key=#{key}"
      data_attrs += " data-sub-type=#{subtype}" if subtype
      data_attrs
    end

    def listener_attrs_raw(channel, key, subtype: nil)
      data_attrs = "data-listener=true data-channel=#{channel} data-key=#{key}"
      data_attrs += " data-sub-type=#{subtype}" if subtype
      data_attrs
    end
  end
end