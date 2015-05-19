namespace :dcv do

  namespace :rails_cache do
    task :clear => :environment do
      Rails.cache.clear
    end
  end

  namespace :index do
    task :list => :environment do
      list = ENV['list']
      pids = []
      if list
        open(list) do |blob|
          blob.each do |line|
            pids << line.strip
          end
        end
      end
      pids.concat ENV['pid'].split(',') if ENV['pid']
      Rails.logger.level = Logger::INFO
      len = pids.length
      current = 0
      pids.each do |pid|
        current += 1
        active_fedora_object = ActiveFedora::Base.find(pid, :cast => true)
        active_fedora_object.update_index
        Rails.logger.info "indexed #{current} of #{len}"
        sleep(3) if current % 100 == 0
      end
    end
  end

  namespace :css do
    task :fix => :environment do
      open('caggs_css.txt') do |blob|
        i = 0
        j = 0
        blob.each do |line|
          line.strip!
          obj = ContentAggregator.find(line)
          mods = obj.datastreams['descMetadata']
          old_content = mods.content
          new_content = old_content.gsub(/\<originInfo/,'<mods:originInfo')
          new_content ||= old_content
          new_content = new_content.gsub(/\/originInfo/,'/mods:originInfo') || new_content
          if new_content
            mods.content = new_content
            obj.save
            j = j + 1
          end
          i = i + 1
          p "processed #{i} of 1348 modifying #{j}\n"
        end
      end
    end
  end
  
  namespace :util do
    task :add_dcv_publish_target => :environment do
			
			start_time = Time.now
			
			dcv_publish_target = 'cul:vmcvdnck2d'
			
			list = ENV['list']
      pids = []
      if list
        open(list) do |blob|
          blob.each do |line|
            pids << line.strip
          end
        end
      end
			
			total = pids.length
			puts "Found #{total} pids."
			counter = 0

			pids.each do |pid|
				counter += 1
				
				begin
					obj = ActiveFedora::Base.find(pid)
					# Preserve other publishers, if present.  Add new publisher if it's not already present.
					current_publishers = obj.relationships(:publisher)
					unless current_publishers.include?('info:fedora/' + dcv_publish_target)
						current_publishers << 'info:fedora/' + dcv_publish_target
						
						obj.clear_relationship(:publisher)
						current_publishers.each do |publisher|
							obj.add_relationship(:publisher, publisher)
						end
						
						obj.save({update_index: false})
					end
				rescue SystemExit, Interrupt => e
					# Allow system interrupt (ctrl+c)
					raise e
				rescue Exception => e
					Rails.logger.error "Encountered problem with #{pid}.  Skipping record.  Exception: #{e.message}"
				end
				
				puts "Added DLC publish target to #{pid} | #{counter} of #{total} | #{Time.now - start_time} seconds"
			end
			
    end
  end

end
