module Repository
  # RDB DAO for MySQL
  class DB
    attr_reader :host, :username, :password, :name

    MYSQL_DATETIME = '%Y-%m-%d %H:%M:%S'.freeze

    module Query
      SET_SESSION_TZ = %q(set session time_zone = 'Asia/Tokyo').freeze
      SET_UTF8       = %q(set names 'utf8').freeze
    end.freeze

    def self.datetime_to_s(datetime)
      %('#{datetime.strftime(MYSQL_DATETIME)}')
    end

    def initialize(
        host:,
        username:,
        password:,
        name:,
        # 共通処理としてsessionのtimezoneをJSTに合わせる
        init_command: Query::SET_SESSION_TZ
    )
      @host     = host
      @username = username
      @password = password
      @name     = name
      @init_cmd = init_command

      @clients = {}
    end

    # @param [Symbol] name
    # @param [Hash] opts
    # @return [Mysql2::Client]
    def connection(name = :default, **opts)
      @clients[name] ||= Mysql2::Client.new(
          host:     @host,
          username: @username,
          password: @password,
          database: @name,
          init_command: @init_cmd,
      ).tap do |client|
        client.query_options.merge!(**opts)
      end
    end
  end
end
