# aws-cliのコマンド実行
module Repository
  class AWSCLI
    class << self
      def execute(command)
        return true if Const.option['dryrun']

        result = systemu command # 1=正常時の結果, 2=エラー時の結果
        fail AWSCLIException.new("[AWS-CLIエラー]\n" + result[2]) unless result[2].empty?

        # s3コマンドは返り値が平文限定なので行ごとに配列化して返す
        begin
          # json形式で返ってこない構文もあるので…
          result_arr = JSON.parse(result[1])
        rescue => e
          result_arr = result[1].split("\n")
        end

        return result_arr
      end
    end
  end
end