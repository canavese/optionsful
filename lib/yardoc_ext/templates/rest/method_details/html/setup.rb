def init
  sections :header, [:method_signature, T('docstring')]
end

def header
  erb(:header)
end