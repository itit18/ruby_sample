# Capybara動作確認用サンプル / E2Eの書き方サンプル

# 共通の前処理を実行しています
require 'init'

# 大枠としてのテストの目的を書いてください
RSpec.feature "E2Eの書き方サンプル", :type => :feature do
  # このbackgroundの記述は踏襲してください
  background do |example|
    # example引数にはテストに関するメタデータが入っています
    # メタデータ参考: puts example.metadata

    # feature名/scenario名というフォーマットになるように変換
    @ss_name = example.full_description.gsub!(/\s/, '/')
  end

  # 1つのシナリオの粒度が小さくなると良いです
  # またシナリオ同士は実行順や依存性を持たせないようにしてください
  scenario "トップページが表示されること" do
    visit('/')
    wait('#pickupArea')
    screenshot(@ss_name)# スクリーンショット自動生成 / @ss_nameをbefourで作っておくこと
    expect(page).to have_content('サイトネーム')
  end

  # ログイン処理は共通化してあります。
  scenario "ログインテスト" do
    visit('/')
  end
end
