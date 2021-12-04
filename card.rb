class Weapon < Sprite
    attr_accessor :name,:attack,:attribute
    def initialize(name,attack,attribute,img)
        @name = name
        @attack = attack
        @attribute = attribute
        x = 0
        y = 0
        image = img
        super(x,y,image)
    end
end
class Armor < Sprite
    attr_accessor :name,:defence,:attribute
    def initialize(name,defence,attribute,img)
        @name = name
        @adefence = defence
        @attribute = attribute
        x = 0
        y = 0
        image = img
        super(x,y,image)
    end
end

class Item < Sprite
    attr_accessor :name,:hp,:mp
    def initialize(name,hp,mp,img)
        @name = name
        @hp = hp
        @mp = mp
        x = 0
        y = 0
        image = img
        super(x,y,image)
    end
end

#画像の読み込み
Image.register(:sword,'images/sword.png')
Image.register(:axe,'images/axe.png')
Image.register(:hammer,'images/hammer.png')
Image.register(:nife,'images/nife.png')
Image.register(:helmet,'images/helmet.png')
Image.register(:chest,'images/chest.png')
Image.register(:boots,'images/boots.png')
Image.register(:hand,'images/hand.png')
Image.register(:smile_water,'images/smile_water.png')
Image.register(:smile_flower,'images/smile_flower.png')

