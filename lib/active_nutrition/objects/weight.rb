# encoding: UTF-8

module ActiveNutrition
  module Objects
    class Weight < Base
      METHOD_MAP = { :amount => :Amount,
                     :grams => :Gm_Wgt,
                     :measurement => :Msre_Desc }
      def as_json(options = nil)
        json = super
        METHOD_MAP.each_pair do |method, attr_name|
          json[method] = attributes[attr_name.to_s]
        end
        json
      end

      METHOD_MAP.each_pair do |method, attr_name|
        define_method(method) { self.attributes[attr_name.to_s] }
      end
    end
  end
end