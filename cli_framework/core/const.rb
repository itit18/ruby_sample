# グローバルで参照出来る変数を集約
#
# グローバル参照は必要最低限にすること! 扱い方注意！！

class Const
  class << self
    @@config = {}
    @@option = {}
    @@system = {}

    # Public: configの設定
    def set_config(hash)
      @@config = hash
    end

    #  Public: システム定数の設定
    def set_system(hash)
      @@system = hash.freeze
    end

    #  Public: option引数の設定
    def set_option(hash)
      @@option = hash.freeze
    end

    #  Public: システム定数参照
    def system
      return @@system
    end

    # Public: config参照
    def config
      return @@config
    end

    # Public: option引数参照
    def option
      return @@option
    end
  end
end
