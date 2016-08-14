namespace :songs do
  desc 'Song: Attempt to delete duplicate song sheets in a directory'
  task delete_dupes: :environment do
    VALID_OPTS = ['dir=DIR_NAME', 'recursive=[true|false]']

    options = OpenStruct.new
    options.dir = ENV['dir'] || ''
    options.recursive = ENV['recursive'] == 'true' ? true : false

    if options.dir.blank?
      puts "Options are: #{VALID_OPTS.join(' ')}"
      exit
    else
      options.dir = File.expand_path(options.dir)
    end

    new_dir = "#{options.dir}.new"
    FileUtils.copy_entry(options.dir, new_dir, false, false, true)

    deleted_files = Set[]
    search_str = "#{new_dir}/*"
    search_str << '*' if options.recursive
    Dir.glob(search_str).each do |file|
      next if File.directory?(file)
      next if deleted_files.include?(file)

      base_name = File.basename(file, File.extname(file))
      next if base_name.split.length < 3 # not enough words to go by

      puts "Looking at '#{base_name}'...".green

      similar_files = Dir.glob("#{new_dir}/#{base_name}*")
      similar_files.delete(file) # don't want to remove the original

      if similar_files.any?
        puts "\nremoving: \n\t#{similar_files.join("\n\t")}\n".green
        FileUtils.rm(similar_files)
        deleted_files += similar_files
      elsif file.match(/\(.*\)(?=\.)| in \w{1,2}(?=\.)/)
        # It's possible that dupes may exist as
        # 'same file (A).doc', 'same file (B).doc'. Using Dir.glob with the
        # whole filename as the prefix to search against won't capture these.
        search = base_name.split[0..-2].join(' ') # remove the end piece (A)
        #byebug
        other_similar_files = Dir.glob("#{new_dir}/#{search}*")

        if other_similar_files.any?
          other_similar_files.reject! { |f| File.directory?(f) }
          keep = other_similar_files.delete(file).split # keep this one
          remove = []

          other_similar_files.each do |f|
            remove << f if (keep - f.split).length == 1
          end

          if remove.any?
            puts "\nremoving: \n\t#{remove.join("\n\t")}\n".green
            FileUtils.rm(remove)
            deleted_files += remove
          end
        end
      end
    end

    puts "Done! Removed #{deleted_files.length} files.".green
    puts "New directory is: #{new_dir}".cyan
  end
end
