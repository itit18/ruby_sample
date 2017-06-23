require 'pp'
require 'bundler/setup' # local gemを読み込むように$LOAD_PATHを変更
Bundler.require

# ローカルのlibを読み込む
root = File.expand_path('./', __dir__)
$LOAD_PATH.unshift(root)# ロードパスを追加
%w(yaml json optparse kconv time).each do |lib|
  require lib
end

# 自作クラスを全て自動読み込み
require 'core/old_boot'
%w[ class core model service lib repository ].each do |dir_name|
  Dir::glob("./#{dir_name}/*.rb").each do |file|
    require file
  end
end

# 例外を規定
class AlertException < StandardError; end
class WarnException < StandardError; end
class AWSCLIException < StandardError; end
