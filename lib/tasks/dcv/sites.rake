require 'csv'

namespace :dcv do

  namespace :sites do
    namespace :export do
      task site: :environment do
        site_export = Dcv::Sites::Export::Directory.new(ENV['slug'], ENV['directory'])
        if site_export.exists?
          site_export.run
        else
          puts "No exportable directory at #{ENV['directory']}"
        end
      end
      task all: :environment do
        Site.all.each do |site|
          directory = File.join(ENV['directory'], site.slug)
          site_export = Dcv::Sites::Export::Directory.new(site.slug, directory)
          if site_export.exists?
            site_export.run
          else
            puts "Can't export to directory at #{directory}"
          end
        end
      end
    end
    task export: 'export:site'

    task import: :environment do
      site_import = Dcv::Sites::Import::Directory.new(ENV['directory'])
      if site_import.exists?
        site_import.run
      else
        puts "No site export at #{ENV['directory']}"
      end
    end
    task seed_from_solr: :environment do
      SolrDocument.each_site_document do |document|
        site_import = Dcv::Sites::Import::Solr.new(document)
        next unless site_import.exists?
        site_import.run
      end
    end
  end
end