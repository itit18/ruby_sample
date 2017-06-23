# SQSのポーリング処理

class Worker
  def run()
    # デバッグ用にユニークキーを発行する
    unique_key = SecureRandom.base64(8)
    pid        = Process.pid
    unique     = "pid: #{pid} / unique_key: #{unique_key}"
    Output.info("start ReadWorker #{unique}")
    @sqs = SQS.new(Const.config['sqs']['read'])
    loop do
      begin
        polling
      rescue StandardError => e
        Output.error(e)# エラー出力だけ行ってポーリングは続ける
        sleep 60 # エラーが出続けると困るので長めにスリープする
      end
      p "ポーリング待機中...(#{unique})"
      sleep 3
    end
  end

  private

  # Public: ポーリング処理
  #
  # 受け取った処理内容を実行して結果が返ってくるまで待機するので、処理が重いと1プロセスがずっと待機状態になる点に注意。
  # ↑上記の構造なので複数プロセスのデーモンを採用している。
  def polling
    # キューから読取り
    message = nil
    # AWS SQSエラーのみを拾うようにしないとデーモンが終了できない
    Retryable.retryable(tries: 10, sleep: 5, on: ::Aws::SQS::Errors::ServiceError) do
      message = @sqs.receive
    end
    return unless message

    sqs_message_id = message.message_id
    # キューが他のプロセスで実行済みであれは処理しない
    return if @sqs.processed?(sqs_message_id)

    job_command = message.body
    # 一応怖いのでバリデーション / 英数字空白ハイフンのみ許可
    if job_command.match(/[^\w\s-]/)
      # 該当キューを削除してから例外吐く
      @sqs.delete(message)
      fail DaemonException.new("半角英数字と空白、ハイフン以外の文字が含まれるキューが発行されています。\n #{message}")
    end

    Output.info("ReadWorker 実行コマンド: #{job_command}")
    # キューを削除
    # コマンド実行時にリトライ機構が含まれているのでエラーが置きてもキューは削除する
    # 不正なキューがエラーを吐きつづける状態を回避したい、という意図
    @sqs.delete(message.receipt_handle)
    # memec_cliを叩く / 一応エラー読み取るように
    command = "ruby memec_cli.rb #{job_command}"
    begin
      execute(command)
    rescue DaemonException => e
      p e # エラー出力だけ行って処理を続行
    end
  end

  # Public: コマンド実行
  def execute(command)
    Retryable.retryable(on: [DaemonException], tries: 3) do
      result = systemu command # 1=正常時の結果, 2=エラー時の結果
      unless result[2].empty?
        fail DaemonException.new("[ ReadQueueエラー ]\n" + result[2])
      end
    end
  end

end

