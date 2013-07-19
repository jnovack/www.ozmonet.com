Dir['.ruby/*.rake'].each { |file| load(file) }

task :default => :server

desc 'Clean up generated site'
task :clean do
  cleanup
end

desc 'Build site with Jekyll'
task :build => [:clean, :cats] do
  jekyll
end

desc 'Start server with --watch'
task :server => :clean do
  jekyll('server --watch')
end

desc 'Check links for site already running on localhost:4000'
task :check_links do
  begin
    require 'anemone'
    root = 'http://localhost:4000/'
    Anemone.crawl(root, :discard_page_bodies => true) do |anemone|
      anemone.after_crawl do |pagestore|
        broken_links = Hash.new { |h, k| h[k] = [] }
        pagestore.each_value do |page|
          if page.code != 200
            referrers = pagestore.pages_linking_to(page.url)
            referrers.each do |referrer|
              broken_links[referrer] << page
            end
          end
        end
        broken_links.each do |referrer, pages|
          puts "#{referrer.url} contains the following broken links:"
          pages.each do |page|
            puts "  HTTP #{page.code} #{page.url}"
          end
        end
      end
    end

  rescue LoadError
    abort 'Install anemone gem: gem install anemone'
  end
end

def cleanup
  sh 'rm -rf _site'
end

def jekyll(opts = '')
  sh 'jekyll ' + opts
end

desc "deploy basic rack app to heroku"
multitask :heroku do
  puts "## Deploying to Heroku "
  (Dir["#{deploy_dir}/public/*"]).each { |f| rm_rf(f) }
  system "cp -R _site/* #{deploy_dir}/public"
  puts "\n## copying _site to #{deploy_dir}/public"
  cd "#{deploy_dir}" do
    system "git add ."
    system "git add -u"
    puts "\n## Committing: Site updated at #{Time.now.utc}"
    message = "Site updated at #{Time.now.utc}"
    system "git commit -m '#{message}'"
    puts "\n## Pushing generated #{deploy_dir} website"
    system "git push heroku #{deploy_branch}"
    puts "\n## Heroku deploy complete"
  end
end

desc 'Generate categories pages'
task :cats do
  puts "Generating categories..."
  sh 'rm -rf categories'
  Dir::mkdir('categories')
  require 'rubygems'
  require 'jekyll'
  include Jekyll::Filters
          
  options = Jekyll.configuration({})
  site = Jekyll::Site.new(options)
  site.read_posts('')
  site.categories.sort.each do |category, posts|
    html = ''
    html << <<-HTML
---
layout: wide
title: Postings under "#{category}"
---
    <h3 id="#{category}">Postings under "#{category}"</h3>
    HTML
    html << '<ul class="posts">'
    posts.sort.reverse.each do |post|
      post_data = post.to_liquid
      puts "#{post_data['title']}"
      html << <<-HTML
        <div class="section list">
          <p class="line">
            <span class="label label-info">#{date_to_string(post.date)}</span>
            <a class="title" href="#{post.url}">#{post_data['title']}</a>
          </p>
          <p class="excerpt">
            #{post_data['excerpt']}
          </p>
        </div>
      HTML
    end
    html << '</ul>'

    File.open("categories/#{category}.html", 'w+') do |file|
      file.puts html
    end
  end
  puts 'Done.'
end
