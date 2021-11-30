require "middleman-gh-pages"

# Ignore errors about dirty `middleman-gh-pages` builds
ENV["ALLOW_DIRTY"] = "true"

namespace :posts do
  desc "Create a new blog post"
  task :new, :title do |t, args|
    abort "Error: You must pass in a name for the post." unless args[:title]

    post_name = post_name(args[:title])
    sh "touch ./source/posts/#{post_name}; subl ./source/posts/#{post_name}"
  end
end

def post_name(title)
  date = Date.today.strftime('%Y-%m-%d')
  file_type = ".html.markdown"
  title = title.downcase.split(" ").join("-")

  "#{date}-" + "#{title}" + "#{file_type}"
end
