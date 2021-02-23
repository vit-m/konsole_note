class Post

  def initialize
    @created_at = Time.now
    @text = nil
  end

  def file_path
    file_name = @created_at.strftime("#{self.class.name}_%Y-%m-%d_%H-%M-%S.txt")
    return "#{__dir__}/../data/#{file_name}"
  end

  def read_from_console

  end

  def save
    File.write(file_path, to_strings)
  end

  def to_strings

  end


end
