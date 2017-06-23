# S3操作関連

module Repository
  class S3
    # TODO: configを引数で渡さずに、global化されたconfig情報を読み取るようにする
    def initialize(config)
      @client = Connector.instance.s3
    end

    #Pulic: バケット名設定
    def bucket(bucket)
      @bucket = bucket
    end

    #Public: アップロード
    def upload(local_path, s3_object)
      raise Exception.new('bucketが指定されてません') unless @bucket
      bucket = @client.buckets[@bucket]
      bucket.objects[s3_object].write(:file => local_path)
    end

    #Public: ダウンロード
    def download(s3_object)
      raise Exception.new('bucketが指定されてません') unless @bucket
      bucket = @client.buckets[@bucket]
      return bucket.objects[s3_object].read
    end

    # Public: 削除
    def delete(s3_object)
      raise Exception.new('bucketが指定されてません') unless @bucket
      bucket = @client.buckets[@bucket]
      bucket.objects[s3_object].delete
    end

    #Public: ファイル存在確認
    def exists?(s3_object)
      raise Exception.new('bucketが指定されてません') unless @bucket
      bucket = @client.buckets[@bucket]
      return bucket.objects[s3_object].exists?
    end
  end
end