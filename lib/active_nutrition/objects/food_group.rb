# encoding: UTF-8

module ActiveNutrition
  module Objects
    class FoodGroup < Base
      METHOD_MAP = { :name => :FdGrp_Desc,
                     :code => :FdGrp_CD }
      def as_json(options = nil)
        json = super
        METHOD_MAP.each_pair do |method, attr_name|
          json[method] = attributes[attr_name.to_s]
        end
        json
      end

      METHOD_MAP.each_pair do |method, attr_name|
        define_method(method) { attributes[attr_name.to_s] }
      end
    end
  end
end
