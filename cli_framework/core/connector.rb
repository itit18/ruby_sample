# インラフ層への接続クライアントを生成するクラス
# DB / APIなど。クライアント生成を1回のみにしたい時用

class Connector
  include Singleton

  # Public: MySQL接続
  def db
    if(@db_client) return @db_client

    db_config = Const.config['db']
    @db_client = mysql_connect(db_config)

    return @db_client
  end

  # Public: Redis接続
  def redis
    if(@redis_client) return @redis_client

    Output.info "redis接続: #{Const.config['redis_url']}"
    @redis_client = Redis.new(
        host: Const.config['redis_url'],
        port: Const.config['redis_port'],
    )

    return @redis_client
  end

  private

  # Internal: MySQL接続共通部分
  def mysql_connect(db_config, name: :default)
    Output.info "DB接続: #{db_config['url']}"

    return Core::DB.new(
        host:     db_config['url'],
        username: db_config['user'],
        password: db_config['password'],
        name:     db_config['db'],
    ).connection(name)
  end
end
