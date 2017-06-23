# 共通の初期処理

require 'spec_helper'
require 'capybara/rspec'
require 'capybara/poltergeist'

# ドライバーの設定
Capybara.javascript_driver = :poltergeist
Capybara.register_driver :poltergeist do |app|
  Capybara::Poltergeist::Driver.new(app, 
    :js_errors => true, 
    :timeout => 60,
    :window_size => [320, 1500]
    )
end

# 接続先に対する全体的な設定
Capybara.configure do |config|
    config.run_server = false
    config.default_driver = :poltergeist
    config.app_host = 'http://example.com/'
end
Capybara.ignore_hidden_elements = true # 非表示要素に反応しないようにする
Capybara.default_max_wait_time = 5 # 要素が存在しない時の待ち時間
