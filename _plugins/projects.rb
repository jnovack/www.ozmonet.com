# Title: project list tag for Jekyll
# Author: Frederic Hemberger http://frederic-hemberger.de
# URL: https://raw.github.com/fhemberger/jekyll-projectlist/master/plugins/projectlist.rb
# Description: TODO ;-)
#
# Syntax {% projectlist [template] %}
#
# Example:
# {% projectlist my_template.html %}

module Jekyll

  class Project
    include Convertible

    attr_accessor :data, :content
    attr_accessor :projectdata

    def initialize(site, base, dir, name)
      @site = site

      @projectdata = self.read_yaml(File.join(base, dir), name)
      @projectdata['filename'] = File.basename(name, ".md")
      if (@projectdata.include?('last_modified'))
        @projectdata['modified'] = @projectdata['last_modified']
      else 
        @projectdata['modified'] = File.mtime(File.join(dir, name))
      end
      @projectdata['content'] = markdownify(self.content)
    end

    def publish?
      @projectdata['published'].nil? or @projectdata['published'] != false
    end

    # Convert a Markdown string into HTML output.
    #
    # input - The Markdown String to convert.
    #
    # Returns the HTML formatted String.
    def markdownify(input)
      converter = @site.getConverterImpl(Jekyll::MarkdownConverter)
      converter.convert(input)
    end
  end


  class ProjectList
    @@projects = []

    def self.create(site)
      @@projects = []
      dir = site.config['projects_dir'] || 'projects'
      base = File.join(site.source, dir)
      return unless File.exists?(base)

      entries  = Dir.chdir(base) { site.filter_entries(Dir['**/*.md']) }

      # Reverse chronological order
      entries = entries.reverse
      entries.each do |f|
          project = Project.new(site, site.source, dir, f)
          @@projects << project.projectdata if project.publish?
      end
    end

    def self.projects
      @@projects
    end
  end

  # Jekyll hook - the generate method is called by jekyll, and generates all of the category pages.
  class GenerateProjects < Generator
    safe true
    priority :low

    def generate(site)
      ProjectList.create(site)
      site.config['projects'] = ProjectList.projects
    end
  end

end

