# 共通の初期処理をまとめる

class Bootstrap
  include Singleton

  attr_reader :log, :error_log
  # thorから呼ばれるイメージ
  def setup(option)
    # 環境設定
    ENV['TZ'] = 'Asia/Tokyo' # 念のためruby環境のタイムゾーンをjstへ変更

    # システム定数設定
    system = {}
    system[:env] = ENV['APP_ENV'] || 'develop'
    system[:root_path] = File.expand_path('../', __dir__)

    # コンフィグの読み込み
    config = Config.instance.get

    # ログ設定
    # logディレクトリの有無を確認して作成
    dir = system[:root_path] + File.dirname(config['general_log'])
    Dir.mkdir(dir) unless File.exist?(dir)
    dir = system[:root_path] + File.dirname(config['error_log'])
    Dir.mkdir(dir) unless File.exist?(dir)

    # ログクラスを設定
    rotation = 9
    size = 300 * 1024 * 1024
    @log = Logger.new(system[:root_path] + config['general_log'], rotation, size)
    @error_log = Logger.new(system[:root_path] + config['error_log'], rotation, size)
    @log.level = Logger::INFO
    @error_log.level = Logger::WARN

    # Constクラスを設定
    Const.set_system(system)
    Const.set_config(config)
    Const.set_option(option)

    print boot_view
  end

  def boot_view
    view = <<-EOS
---------------------------
-- APP NAME
--
-- ENV: #{Const.system[:env]}
---------------------------

EOS
    return view
  end
end
