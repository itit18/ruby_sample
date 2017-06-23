# thorを使ってバッチ処理の受け口を一括化する

require_relative './autoload.rb'

class Command < Thor
  # 全てのコマンド共通の引数設定
  class_option :env
  class_option :dryrun, type: :boolean

  def initialize(*args, **opts)
    super
    # 共通処理 / thorはbeforeを指定できないので初期化時に実行
    Bootstrap.instance.setup(options)
  end

  # コマンド設定のサンプル
  desc 'sample', 'コマンド設定のサンプルです' # コマンドの使用例と、概要を記載
  def sample
    Hello.new.run() # libクラスのrunだけを実行する / 他の処理は書かない
  end

  #######################################################
  #  ここから下にコマンドを追加していく(アルファベット順)
  #######################################################s
end

begin
  Command.start(ARGV)
rescue WarnException => e
  # 単なるワーニングのときはメール通知したくないのでエラーログ出力のみにする
  Output.error_log(e.message)
rescue => e
  Output.error(e)
end
