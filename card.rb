class Weapon < Sprite
    attr_accessor :name,:attack,:attribute,:image
    def initialize(name,attack,attribute,image)
        @name = name
        @attack = attack
        @attribute = attribute
        @image = image
    end
end

class Armor < Sprite
    attr_accessor :name,:defence,:attribute,:image
    def initialize(name,defence,attribute,image)
        @name = name
        @adefence = defence
        @attribute = attribute
        @image = image
    end
end

class Item < Sprite
    attr_accessor :name,:hp,:mp,:image
    def initialize(name,hp,mp,image)
        @name = name
        @hp = hp
        @mp = mp
        @image = image
    end
end

sword = Weapon.new("剣",10,0,"sword.png")
axe = Weapon.new("斧",5,0,"axe.png")
hammer = Weapon.new("ハンマー",8,0,"hammer.png")
nife = Weapon.new("ナイフ",2,0,"nife.png")

helmet = Armor.new("ヘルメット",3,0,"helmet.png")
chest = Armor.new("チェスト",6,0,"chest.png")
boots = Armor.new("ブーツ",4,0,"boots.png")
hand = Armor.new("小手",2,0,"hand.png")

smile_water = Item.new("スマイルウォーター",5,0,"smile_water.png")
smile_flower = Item.new("スマイルの花",0,5,"smile_flower.png")