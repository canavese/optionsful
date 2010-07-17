def init
  sections :index, [:argument, :example_response, :response_field]
end

def response_field
  generic_tag :response_field
end

def argument
  generic_tag :argument, :no_types => false
end

def generic_tag(name, opts = {})
  return unless object.has_tag?(name)
  @no_names = true if opts[:no_names]
  @no_types = true if opts[:no_types]
  @name = name
  out = erb('generic_tag')
  @no_names, @no_types = nil, nil
  out
end

