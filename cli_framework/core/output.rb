# 汎用のアウトプット系
#
# アウトプット系のファサードとして定義

class Output
  class << self
    ERROR_KEY = 'error'.freeze
    INFO_KEY = 'info_error'.freeze

    ERROR_COLOR = "\e[1;31m".freeze
    INFO_COLOR = "\e[1;32m".freeze
    BASE_COLOR = "\e[m".freeze

    # Public: 定形のinfo出力
    def info(message)
      print INFO_COLOR
      print '[ info ] '
      print BASE_COLOR
      puts message
      Bootstrap.instance.log.info(message)

      # redisにログ保存
      now = Time.now
      redis = Connector.instance.redis
      redis.zadd(INFO_KEY, now.to_i, now.strftime('[%Y-%m-%d %H:%M:%S] ') + message)
      redis_clean if rand(100) == 1 # 適度にリフレッシュ処理を実行
    end

    # Public: 定形のerror処理
    def error(execption)
      message = execption.message + "\n" + execption.backtrace.join("\n")
      error_log(message)
      error_mail('例外検知メール', message)
    end

    # Public: errorログへの記録
    def error_log(message)
      print ERROR_COLOR
      print '[ error ] '
      print BASE_COLOR
      puts message
      Bootstrap.instance.error_log.error(message)

      # redisにログ保存
      now = Time.now
      redis = Connector.instance.redis
      redis.zadd(ERROR_KEY, now.to_i, now.strftime('[%Y-%m-%d %H:%M:%S] ') + message)
    end

    # Public: 処理開始時の定形出力
    def start(class_name, method_name)
      message = "#{class_name}##{method_name} start!"
      info(message)
    end

    # Public: 処理開始時の定形出力
    def end(class_name, method_name)
      message = "#{class_name}##{method_name} successfully!"
      info(message)
    end

    # Public:インフォメール送信
    def info_mail(title, message, to)
      title = '[ system info ] ' + title
      MailSender.send(title, message, to)
    end

    # Public: アラートメール送信
    #
    # アラート ≠ エラーなので注意。システムが正常稼働していて、検知したアラートをメール送信する
    def alert_mail(title, message, to)
      now = Time.now.strftime('%Y-%m-%d %H:%M:%S')
      title = "[ system alert ] #{title} #{now}"
      MailSender.send(title, message, to)
    end

    private

    # Internal: エラーメール送信
    #
    # システムの異常終了を知らせるメール
    def error_mail(title, message, to)
      message = "例外を検知しました。\n\n#{message}"
      title = "[ system error ] #{title}"
      MailSender.send(title, message, to)
    end

    # Internal: redisに保存されたログを掃除する
    def redis_clean
      redis = Connector.instance.redis
      redis.zremrangebyrank(INFO_KEY, -100, 0) # 直近100件以外のログ削除
      redis.zremrangebyrank(ERROR_KEY, -100, 0) # 直近100件以外のログ削除
    end
  end
end
