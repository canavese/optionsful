def init
  return if object.docstring.blank?
  sections :text, T('tags')
end