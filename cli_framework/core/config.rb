# コンフィグ参照用のクラス
# 初回起動時のみ実行するようにシングルトンにする

class Config
  include Singleton
  DIR = 'config/'.freeze

  def setup(env)
    @env = env
    config_file = 'config.yml'
    @config = YAML.load_file(DIR + config_file)
    @config = @config[@env]
  end

  # Public: 追加でconfigファイル読み込んでconfigにマージする
  def add(filename)
    add_config = YAML.load_file(DIR + filename.to_s)
    add_config = add_config[@env]
    @config = @config.merge(add_config)
    Const.set_config(@config) # Constの中身を更新する
    return @config
  end

  # Public: 環境を指定して該当するconfig設定を取得
  def get
    return @config
  end
end
