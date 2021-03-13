class Memo < Post
  def load_data(data_hash)
    super(data_hash)
    @text = data_hash['text'].split('\n\r')
  end

  def read_from_console
    puts "Новая заметка (всё, что напишите до строчки \"end\"):"

    @text = []
    line = nil

    loop do
      line = STDIN.gets.chomp
      break if line == 'end'
      @text << line
    end
  end

  def to_db_hash
    return super.merge(
      {
        "text": @text.join('\n')
      }
    )
  end

  def to_strings
    time_string = "Создано: #{@created_at.strftime("%Y.%m.%d, %H:%M:%S")} \n\r"
    return @text.unshift(time_string).join("\n")
  end
end
