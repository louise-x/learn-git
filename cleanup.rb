def ruby_dir_with_lazy
  folder =  "/var/www/my-test/shared/tmp/cache/bootsnap/compile-cache/00"
  now = Time.now
  files = []
  puts "--- address the folder : #{folder}"
  Dir.glob("#{folder}/**/*").lazy.each do |file|
    puts "--- checking #{file}"
    if File.file? file
      atime = File.atime(file)
      delta = now - atime
      puts "delta is ....#{delta}"
      if delta > 600
        files << file
      end
    end
  end
  puts "found access no more 10min ago: #{files}"
end