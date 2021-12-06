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


