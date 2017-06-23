# メール送信処理
#
# クラス名Mailだと標準ライブラリと被るのであえて冗長にしている
module Repository
  class MailSender
    FROM = ''.freeze
    class << self
      # Public: 送信処理
      #
      # TODO: 本番環境でのみ送信するように修正
      def send(title, message, to)
        mail = create_mail
        mail.to      = to
        mail.subject = title
        mail.body    = format_body(message)
        if Const.system[:env] == 'production'
          mail.deliver
        else
          p 'メール送信キャンセル'
        end
      rescue => exce
        p 'メール送信エラー: ' + exce.message
      end

      private

      # Internal: 共通部分の生成
      def create_mail
        mail = Mail.new
        mail.from    = FROM
        mail.charset = 'utf-8'

        return mail
      end

      # Internal: bodyの定型文
      def format_body(message)
        mail_message = <<-EOS
        #{message}
        EOS

        return mail_message
      end
    end
  end
end
