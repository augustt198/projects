MATCHERS = {
  "comment" => /\/\/.*(\r\n|\r|\n)?/,
  "str" => /\".*?\"/,
  "op" => /(=|==|>=|<=|>|<|&&|\|\||&|\||!=|!|<<|>>|\+|-|\/|\*)/,
  "kw" => /\b(int|float|double|char|void|long|bool|if|else|for|while|return)\b/,
  "float" => /\b(\d*\.\d+)\b/,
  "int" => /\b((?<!\.)(0x)?\d+(?!\.))\b/,
  "hex" => /\b0x[0-9a-fA-F]+\b/,
  "call" => /\b\w+(?=\()\b/,
}

def taggify(s, tag)
  return "<span class=\"syntax-#{tag}\">#{s}</span>"
end

def roast(s)
  s.chars.map { |c| c.ord > 500 ? c : (c.ord+1000).chr(Encoding::UTF_8) }.join
end
def unroast(s)
  s.chars.map { |c| c.ord < 500 ? c : (c.ord-1000).chr(Encoding::UTF_8) }.join
end

# this will self destruct on non-ascii input
def hilite(s)
  MATCHERS.each do |k, v|
    s = s.gsub(v) do |m|
      roast(taggify(m, k))
    end
  end
  return unroast(s)
end
