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
    Window.width  = 1400
    Window.height = 700
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
        hand_exist=[] #手札にあるか
        field=[]
        
        #手札生成
        5.times { 
            hand << rand(10)
            hand_exist << 1
        }
        
        turn = 0
        Window.loop do
            Window.draw_box_fill(0, 0, 1400, 700, C_GREEN, 0)#背景
            Window.draw_box(150, 100, 500, 500, C_WHITE, 0)#フィールド
            Window.draw_box_fill(200, 430, 450, 480, C_WHITE, 0)#祈るボタン

            if player.hp<=0 || com.hp<=0 
                break
            end
            ############     player      ##########
            if turn==0 
                Window.draw_font(100, 20, "player", font, {:color => C_WHITE})
                if Input.mouse_push?(M_LBUTTON)
                    x = Input.mouse_x
                    y = Input.mouse_y
                    if y > 540 && y < 660
                        if x > 90 && x < 210
                            field << hand[0]
                            hand_exist[0]=0
                        elsif x > 240 && x < 360
                            field << hand[1]
                            hand_exist[1]=0
                        elsif x > 390 && x < 510
                            field << hand[2]
                            hand_exist[2]=0
                        elsif x > 540 && x < 660
                            field << hand[3]
                            hand_exist[3]=0
                        elsif x > 690 && x < 810
                            field << hand[4]
                            hand_exist[4]=0
                        end
                    
                    elsif y > 430 && y < 480 && x > 200 && x < 450 #祈る　相手のターンへ
                        turn=1
                    elsif y > 100 && y < 500 && x > 150 && x < 500 #カードを使用し相手のターンへ
                        field.each do |n|
                            if card[n].kind_of?(Weapon) #Weapon使用
                                com.hp -= card[n].attack
                            end
                        end
                        field.slice!(0,field.size) #配列を空に
                        turn=1
                    end
                end
                
            ###############    com    ############
            elsif turn==1 
                Window.draw_font(100, 20, "com", font, {:color => C_WHITE})
                if Input.mouse_push?(M_LBUTTON) #playerのターンへ
                    turn=0
                    #足りない枚数手札を増やす
                    hand.each_with_index do |n,i|
                        if hand_exist[i] == 0
                            hand[i]=rand(10)
                            hand_exist[i]=1
                        end
                    end
                end 
            end

            ##############     表示    ############
            #手札の表示
            if turn==0 #playerのターン
                hand.each_with_index do |n,i|
                    Window.draw_scale(150*i-150,300,card[n].image,0.2,0.2,nil,nil,0)
                    if hand_exist[i] == 0
                        Window.draw_box(150*i+90, 540, 150*i+210, 660, C_RED, 0)
                    end
                end
            elsif turn==1 #comのターン
                hand.each_with_index do |n,i|
                    if hand_exist[i] == 1
                        Window.draw_scale(150*i-150,300,card[n].image,0.2,0.2,nil,nil,0)
                    else
                        Window.draw_box(150*i+90, 540, 150*i+210, 660, C_WHITE, 0)
                    end
                end
            end
            
            #場のカードの表示
            field.each_with_index do |n,i|
                Window.draw_scale(0,120*i-200,card[n].image,0.2,0.2,nil,nil,0)
            end
            
            #HP,MP表示
            Window.draw_font(600, 20, "player hp:#{player.hp} mp:#{player.mp}", font, {:color => C_WHITE})
            Window.draw_font(600, 120, "com hp:#{com.hp} mp:#{com.mp}", font, {:color => C_WHITE})

        end
        #result()
    end
end