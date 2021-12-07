include DXOpal
require 'dxopal'
require_remote 'player.rb'
require_remote 'com.rb'
require_remote 'card.rb' #画像の読み込み

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

Window.load_resources do
    Window.width  = 800
    Window.height = 600
    player=Player.new()
    com=Com.new()
    font = Font.new(32)

    card=[]

    #カードの登録
    card << sword = Weapon.new("剣",10,0,Image[:sword])                         #1
    card << axe = Weapon.new("斧",5,0,Image[:axe])                              #2
    card << hammer = Weapon.new("ハンマー",8,0,Image[:hammer])                  #3
    card << nife = Weapon.new("ナイフ",2,0,Image[:nife])                        #4
    card << helmet = Armor.new("ヘルメット",3,0,Image[:helmet])                 #5
    card << chest = Armor.new("チェスト",6,0,Image[:chest])                     #6
    card << boots = Armor.new("ブーツ",4,0,Image[:boots])                       #7
    card << hand = Armor.new("小手",2,0,Image[:hand])                           #8
    card << smile_water = Item.new("スマイルの水",5,0,Image[:smile_water])      #9
    card << smile_flower = Item.new("スマイルの花",0,5,Image[:smile_flower])    #10

    Window.loop do
        #init
        player.hp=20
        player.mp=10
        com.hp=20
        com.mp=10

        hand=[]
        
        #手札生成
        5.times { 
            hand << rand(10)
        }
        
        turn = 0
        Window.loop do
            if player.hp<=0 || com.hp<=0 
                break
            end
            Window.draw_box_fill(0, 00, 800, 600, C_GREEN, 0)
            if turn==0 #player
                Window.draw_font(200, 100, "#{player.mp}", font, {:color => C_WHITE})
                if Input.mouse_push?(M_LBUTTON)
                    turn=1 
                end
            elsif turn==1 #com
                Window.draw_font(300, 100, "#{player.hp}", font, {:color => C_WHITE})
                if Input.mouse_push?(M_LBUTTON)
                    turn=0
                end
            end
            Window.draw_scale(0,100,card[hand[0]].image,0.2,0.2,100,450,0)
            Window.draw_scale(100,100,card[hand[1]].image,0.2,0.2,150,450,0)
            Window.draw_scale(200,100,card[hand[2]].image,0.2,0.2,200,450,0)
            Window.draw_scale(300,100,card[hand[3]].image,0.2,0.2,250,450,0)
            Window.draw_scale(400,100,card[hand[4]].image,0.2,0.2,300,450,0)
            #sword.draw
            #axe.draw
            #sleep 1
        end
        #result()
    end
end