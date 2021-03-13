require 'sqlite3'

class Post
  SQLITE_DB_FILE = "#{__dir__}/../data/note.db"

  def self.post_types
    {'Memo' => Memo, 'Task' => Task, 'Link' => Link}
  end

  def self.create(type)
    post_types[type].new
  end

  def self.find(limit, type, id)
    db = SQLite3::Database.open(SQLITE_DB_FILE)

    if !id.nil?
      db.results_as_hash = true

      result = db.execute("SELECT * FROM posts WHERE rowid=?", id)
      result = result[0]

      db.close

      if result.empty?
        puts "Такой id #{id} не найден в базе."
        return nil
      else
        post = create(result['type'])

        post.load_data(result)

        return post
      end

    else
      db.results_as_hash = false

      query = "SELECT rowid, * FROM posts "
      query += "WHERE type=:type " unless type.nil?
      query += "ORDER BY rowid DESC "
      query += "LIMIT :limit" unless limit.nil?

      statement = db.prepare(query)

      statement.bind_param('type', type) unless type.nil?
      statement.bind_param('limit', limit) unless limit.nil?

      result = statement.execute!

      statement.close
      db.close

      return result
    end
  end

  def initialize
    @created_at = Time.now
    @text = nil
  end

  def file_path
    file_name = @created_at.strftime("#{self.class.name}_%Y-%m-%d_%H-%M-%S.txt")
    return "#{__dir__}/../data/#{file_name}"
  end

  def load_data(data_hash)
    @created_at = Time.parse(data_hash['created_at'])
  end

  def read_from_console

  end

  def save
    File.write(file_path, to_strings)
  end

  def save_to_db
    db = SQLite3::Database.open(SQLITE_DB_FILE)
    db.results_as_hash = true

    db.execute(
      "INSERT INTO posts (" +
      to_db_hash.keys.join(', ') + ")" +
      " VALUES (" + ('?,' * to_db_hash.keys.size).chomp(',') + ")",
      to_db_hash.values
    )

    insert_row_id = db.last_insert_row_id

    db.close

    return insert_row_id
  end

  def to_db_hash
    {
      "type": self.class.name,
      "created_at": @created_at.to_s
    }
  end

  def to_strings

  end
end
