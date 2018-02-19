require 'erb'

require_relative 'data.rb'

home_template = File.read('index.erb')
result = ERB.new(home_template).result(binding)
File.write('index.html', result)


def render_layout(project)
    thing2 = 'bleg'
    layout_template = File.read('layout.erb')
    ERB.new(layout_template).result(binding)
end

# helpers
def link_paren(text, link)
    return "<a href=\"#{link}\" style='text-decoration: none'>(<span style='text-decoration: underline'>#{text}</span>)</a>"
end

DATA[:projects].each do |project|
    page = project[:page]
    next if !page

    page_template = File.read('pages/' + page + '.erb')

    thing = 'blah'

    res = render_layout(project) do
        ERB.new(page_template).result(binding)
    end

    File.write('projects/' + page + '.html', res)
end
