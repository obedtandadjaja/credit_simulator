module CustomFormatter
  def self.call(object, env)
    return object if !object || object.is_a?(String)

    return MultiJson.dump({ data: object }) if object.respond_to?(:to_json)

    fail Grape::Exceptions::InvalidFormatter.new(object.class, 'json')
  end
end
