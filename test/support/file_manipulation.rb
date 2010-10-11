require 'pathname'

# Largely stolen from thor, then simplified a bit.
module FileManipulation
  def prepend_file(path, contents)
    inject_into_file(path, contents, :before => /\A/)
  end

  def append_file(path, contents)
    inject_into_file(path, contents, :after => /\z/)
  end

  def inject_into_file(path, contents, options={})
    flag = nil

    if options.key?(:after)
      contents = '\0' + contents + "\n"
      flag     = options.delete(:after)
    else
      contents = contents + "\n" + '\0'
      flag     = options.delete(:before)
    end

    gsub_file(path, flag, contents)
  end

  def gsub_file(path, search, replace)
    write_file(path, File.read(path).gsub(search, replace))
  end

  def write_file(path, contents)
    path = Pathname.new(path)
    path.parent.mkpath
    path.open('w') { |stream| stream.write(contents) }
  end

  def write_versioned_file(path, contents)
    write_file path, contents
    system "git add #{path}"
  end
end

Shoe::TestCase.send(:include, FileManipulation)
