# Title: Note list tag for Jekyll
# Author: Frederic Hemberger http://frederic-hemberger.de
# URL: https://raw.github.com/fhemberger/jekyll-projectlist/master/plugins/projectlist.rb
# Description: TODO ;-)
#
# Syntax {% notelist [template] %}
#
# Example:
# {% notelist my_template.html %}

module Jekyll

  class Note
    include Convertible

    attr_accessor :data, :content
    attr_accessor :notedata

    def initialize(site, base, dir, name)
      @site = site

      @notedata = self.read_yaml(File.join(base, dir), name)
      @notedata['filename'] = File.basename(name, ".md")
      if (@notedata.include?('last_modified'))
        @notedata['modified'] = @notedata['last_modified']
      else
        @notedata['modified'] = File.mtime(File.join(dir, name))
      end
      @notedata['content'] = markdownify(self.content)
    end

    def publish?
      @notedata['published'].nil? or @notedata['published'] != false
    end

    # Convert a Markdown string into HTML output.
    #
    # input - The Markdown String to convert.
    #
    # Returns the HTML formatted String.
    def markdownify(input)
      converter = @site.getConverterImpl(Jekyll::Converters::Markdown)
      converter.convert(input)
    end
  end


  class NoteList
    @@notes = []

    def self.create(site)
      @@notes = []
      dir = site.config['notes_dir'] || 'notes'
      base = File.join(site.source, dir)
      return unless File.exists?(base)

      entries  = Dir.chdir(base) { site.filter_entries(Dir['**/*.md']) }

      # Reverse chronological order
      entries = entries.reverse
      entries.each do |f|
          note = Note.new(site, site.source, dir, f)
          @@notes << note.notedata if note.publish?
      end
    end

    def self.notes
      @@notes
    end
  end

  # Jekyll hook - the generate method is called by jekyll, and generates all of the category pages.
  class GenerateNotes < Generator
    safe true
    priority :low

    def generate(site)
      NoteList.create(site)
      site.config['notes'] = NoteList.notes
    end
  end


  class NotelistTag < Liquid::Tag
    def initialize(tag_name, markup, tokens)
      @notes = NoteList.notes
      @template_file = markup.strip
      super
    end

    def load_teplate(file, context)
      includes_dir = File.join(context.registers[:site].source, '_includes')

      if File.symlink?(includes_dir)
        return "Includes directory '#{includes_dir}' cannot be a symlink"
      end

      if file !~ /^[a-zA-Z0-9_\/\.-]+$/ || file =~ /\.\// || file =~ /\/\./
        return "Include file '#{file}' contains invalid characters or sequences"
      end

      Dir.chdir(includes_dir) do
        choices = Dir['**/*'].reject { |x| File.symlink?(x) }
        if choices.include?(file)
          source = File.read(file)
        else
          "Included file '#{file}' not found in _includes directory"
        end
      end

    end

    def render(context)
      output = super
      template = load_teplate(@template_file, context)

      Liquid::Template.parse(template).render('notes' => @notes).gsub(/\t/, '')
    end
  end


end

Liquid::Template.register_tag('notelist', Jekyll::NotelistTag)
