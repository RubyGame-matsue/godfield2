include DXOpal
require 'dxopal'
require_remote 'player.rb'
require_remote 'com.rb'
require_remote 'card.rb' #画像の読み込み


Window.load_resources do
    Window.width  = 800
    Window.height = 600
    player=Player.new()
    com=Com.new()
    font = Font.new(32)
    Window.loop do
        #init
        player.hp=20
        player.mp=10
        com.hp=20
        com.mp=10
        sword = Weapon.new("剣",10,0,Image[:sword])  #カードの登録
        axe = Weapon.new("斧",5,0,Image[:axe])
        hammer = Weapon.new("ハンマー",8,0,Image[:hammer])
        nife = Weapon.new("ナイフ",2,0,Image[:nife])
        helmet = Armor.new("ヘルメット",3,0,Image[:helmet])
        chest = Armor.new("チェスト",6,0,Image[:chest])
        boots = Armor.new("ブーツ",4,0,Image[:boots])
        hand = Armor.new("小手",2,0,Image[:hand])
        smile_water = Item.new("スマイルの水",5,0,Image[:smile_water])
        smile_flower = Item.new("スマイルの花",0,5,Image[:smile_flower])
        #geme
        turn = 0
        Window.loop do
            if player.hp<=0 || com.hp<=0 
                break
            end
            if turn==0 #player
                Window.draw_font(200, 100, "#{player.mp}", font, {:color => C_GREEN})
                turn=1 
            end
            if turn==1 #com
                Window.draw_font(300, 100, "#{player.hp}", font, {:color => C_GREEN})
                turn=0
            end
            #Window.draw(100,100,Image[:sword])
            #sword.draw
            axe.draw
        end
        #result()
    end
end