# 共通処理

require 'rspec/core/shared_context'

module MyHelper
  @@s_s_number = 1.step #スクリーンショット用連番 / 1テストファイル内で連番は共通

  # スクリーンショット取得簡略化
  def screenshot(filename)
    filename = "#{filename}_#{@@s_s_number.next}"
    root_dir = 'screenshot/'
    filepath = "#{root_dir}#{filename}"
    # 存在しないディレクトリは自動生成される

    page.save_screenshot("#{filepath}.png")
  end

  # 目当てのDOM要素が生成されるまで待機 / 糖衣構文
  def wait(selector)
    find(selector, match: :first)
  end
end
