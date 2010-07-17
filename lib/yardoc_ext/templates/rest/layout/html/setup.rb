include Helpers::FilterHelper

def init
  @breadcrumb = []

  @page_title = options[:title]

  if @file
    @contents = File.read_binary(@file)
    @file = File.basename(@file)
    sections :layout, [:diskfile]
  elsif object
    case object
    when '_index.html'
      sections :layout, [:index]
    when CodeObjects::Base
      type = object.root? ? :module : object.type
      sections :layout, [T(type)]
    end
  else
    sections :layout, [:contents]
  end
end

def contents
  @contents
end

def index

  legitimate_objects = @objects.reject {|o| o.root? || !is_class?(o) || o.tags('url').empty?}
  topic_objects = legitimate_objects.reject{|o| o.tags('topic').empty? }
  @topics = {}
  
  topic_objects.each do |object|
    object.tags('topic').each { |topic| (@topics[topic.text] ||= []) << object }
  end

  @resources = legitimate_objects.sort_by {|o| o.tags('url').first.text }
  
  erb(:index)
end

def diskfile
  "<div id='filecontents'>" +
  case (File.extname(@file)[1..-1] || '').downcase
  when 'htm', 'html'
    @contents
  when 'txt'
    "<pre>#{@contents}</pre>"
  when 'textile', 'txtile'
    htmlify(@contents, :textile)
  when 'markdown', 'md', 'mdown', 'mkd'
    htmlify(@contents, :markdown)
  else
    htmlify(@contents, diskfile_shebang_or_default)
  end +
  "</div>"
end

def diskfile_shebang_or_default
  if @contents =~ /\A#!(\S+)\s*$/ # Shebang support
    @contents = $'
    $1.to_sym
  else
    options[:markup]
  end
end