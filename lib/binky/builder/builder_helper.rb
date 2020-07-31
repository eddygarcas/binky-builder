module BuilderHelper

  # Builds an instance variable as well as its class method accessors from a key value pair.
  def accessor_builder k, v
    self.instance_variable_set("@#{k}", v)
    self.class.send(:define_method, "#{k}", proc {self.instance_variable_get("@#{k}")})
    self.class.send(:define_method, "#{k}=", proc {|v| self.instance_variable_set("@#{k}", v)})
  end

  #Goes through a complex Hash nest and gets the value of a passed key.
  # First wil check whether the object has the key? method,
  # which will mean it's a Hash and also if the Hash the method parameter key
  #   if obj.respond_to?(:key?) && obj.key?(key)
  #
  # If it's not a Hash will check if it's a Array instead,
  # checking out whether it responds to a Array.each method or not.
  #   elsif obj.respond_to?(:each)
  #
  # For every Array found it make a recursive call to itself passing
  # the last element of the array and the Key it's looking for.
  #   r = nested_hash_value(a.last, key)
  def nested_hash_value(obj, key)
    if obj.respond_to?(:key?) && obj.key?(key)
      obj[key]
    elsif obj.respond_to?(:each)
      r = nil
      #The asterisk "splat" operator means you can pass multiple parameters in its place and the block will see them as an array.
      obj.find do |*a|
        r = nested_hash_value(a.last, key)
      end
      r
    end
  end

  # Parses a given json structure looking for specific keys inside the structure.
  # The result of it it's stored on a instance variable called to_hash and accessible through accessors with same name.
  def parse(json = {},keys = [])
    accessor_builder('to_hash',{})
    keys.each do |key|
      @to_hash.merge!({key => nested_hash_value(json,key)})
    end unless json.blank?
  end

  def attribute_from_inner_key(element, attribute, inner_key = nil)
    {attribute.to_sym => nested_hash_value(element, inner_key.present? ? inner_key : attribute.to_s)}
  end

end
