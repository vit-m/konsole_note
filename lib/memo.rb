class Memo < Post

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
        "text": @text.join('\n\r')
      }
    )
  end

  def to_strings
    time_string = "Создано: #{@created_at.strftime("%Y.%m.%d, %H:%M:%S")} \n\r"
    return @text.unshift(time_string).join("\n")
  end
end
