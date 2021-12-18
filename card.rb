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
        @defence = defence
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

class Magic < Sprite
    attr_accessor :name,:mp,:type
    def initialize(name,mp,type,img)
        @name = name
        @mp = mp
        @type = type
        image = img
        super(0,0,image)
    end
end
