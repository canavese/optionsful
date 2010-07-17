# Needed because running outside Gem
# XXX Is there a better way to deal with this?
$LOAD_PATH.unshift(File.expand_path(File.dirname(__FILE__)))

require "base_helper"

YARD::Templates::Engine.register_template_path File.dirname(__FILE__) + '/../templates'

# Define custom tags
YARD::Tags::Library.define_tag("URL for Service", :url)
YARD::Tags::Library.define_tag("Topic for Service", :topic)
YARD::Tags::Library.define_tag("Arguments", :argument, :with_types_and_name)
YARD::Tags::Library.define_tag("Example Responses", :example_response)
YARD::Tags::Library.define_tag("Response Fields", :response_field, :with_name)

