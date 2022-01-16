def ruby_dir_with_lazy
  File.open("/tmp/cleanup_logs.log", "a") do |f|
    folder =  "/var/www/my-test/shared/tmp/cache/bootsnap/compile-cache/00"
    now = Time.now
    files = []
    f.puts "--- address the folder : #{folder}"
    Dir.glob("#{folder}/**/*").lazy.each do |file|
      f.puts "--- checking #{file}"
      if File.file? file
        atime = File.atime(file)
        delta = now - atime
        f.puts "delta is ....#{delta}"
        if delta > 600
          files << file
        end
      end
    end
    f.puts "found access no more 10min ago: #{files}"
  end
end