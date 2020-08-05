require "binky/builder/version"

module Binky
  module Helper

    # Parses a given json structure looking for specific keys inside the structure.
    # Keys are given through a block.
    # The result of it it's stored on a instance variable called to_hash and accessible through accessors with same name.
    def build_by_keys(json = {}, keys = nil)
      k = keys || json&.keys
      raise ArgumentError "keys argument is not an array" unless k&.respond_to?(:each)
      accessor_builder('to_h',{})
      json.transform_keys!(&:to_s)
      k&.reject!{|ky| ky.end_with?('=')}
      k&.each do |key|
        self.send("#{key}=",nested_hash_value(json, key.to_s))
        @to_h.merge!({key.to_sym => nested_hash_value(json,key.to_s)})
      end
      yield self if block_given?
      self
    end

    # Builds an instance variable as well as its class method accessors from a key value pair.
    def accessor_builder(k, v)
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
        obj.find do |*a|
          r = nested_hash_value(a.last, key)
        end
        r
      end
    end

    def method_missing(name,*args)
      accessor_builder name.to_s.chop, args[0]
    end

    def attribute_from_inner_key(elem, attr, in_key = nil)
      {attr.to_sym => nested_hash_value(elem, in_key&.present? ? in_key : attr.to_s)}
    end
  end

  module Struct
    class Error < StandardError; end
    include Helper

    def initialize(json = nil)
      @attributes = {}
      json.each do |k, v|
        self.send("#{k}=", v)
      end unless json.nil?
    end

    def method_missing(name, *args)
      attribute = name.to_s.start_with?(/\d/) ? "_#{name.to_s}" : name.to_s
      if attribute =~ /=$/
        if args[0].respond_to?(:key?) || args[0].is_a?(Hash)
          @attributes[attribute.chop] = self.class.new(args[0])
        else
          @attributes[attribute.chop] = args[0]
        end
      else
        @attributes[attribute]
      end
    end
  end

  module Builder
    class Error < StandardError; end
    include Helper
    alias_method :initialize,:build_by_keys
  end

end
