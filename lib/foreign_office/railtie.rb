require 'foreign_office/foreign_office_helper'
module ForeignOffice
  class Railtie < Rails::Railtie
    initializer "foreign_office.foreign_office_helper" do
      ActionView::Base.send :include, ForeignOfficeHelper
    end
  end
end
