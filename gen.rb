require 'erb'
require_relative 'data.rb'

LAST_COMMIT_SHA = (`git rev-parse --short HEAD`).strip
COMMIT_URL = "https://github.com/augustt198/projects/commit/#{LAST_COMMIT_SHA}"

# helpers
def link_paren(text, link)
    return "<a href=\"#{link}\" style='text-decoration: none'>(<span style='text-decoration: underline'>#{text}</span>)</a>"
end

def compressed_img(link)
    name = link[0, link.rindex(".")]
    return "#{name}-compressed.jpg"
end

# generate

home_template = File.read('index.erb')
result = ERB.new(home_template).result(binding)
File.write('index.html', result)

def render_layout(project)
    layout_template = File.read('layout.erb')
    ERB.new(layout_template).result(binding)
end

DATA[:projects].each do |project|
    page = project[:page]
    next if !page

    page_template = File.read('pages/' + page + '.erb')

    res = render_layout(project) do
        ERB.new(page_template).result(binding)
    end

    File.write('projects/' + page + '.html', res)
end

Dir.glob("img/**/*.{jpg,png}") do |file|
    name = file[0, file.rindex(".")]
    if !name.end_with?("-compressed")
      spawn("magick convert #{file} -quality 75 #{name}-compressed.jpg")
    end
end
Process.waitall
