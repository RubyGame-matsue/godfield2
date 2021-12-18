include DXOpal
require 'dxopal'
require_remote 'player.rb'
require_remote 'com.rb'
require_remote 'card.rb' #画像の読み込み
# reauire_remote 'game.rb'

#画像の読み込み
Image.register(:sword,'images/sword.png')
Image.register(:axe,'images/axe.png')
Image.register(:hammer,'images/hammer.png')
Image.register(:nife,'images/nife.png')
Image.register(:helmet,'images/helmet.png')
Image.register(:chest,'images/chest.png')
Image.register(:boots,'images/boots.png')
Image.register(:hand,'images/hand.png')
Image.register(:book,'images/book.png')
Image.register(:smile_flower,'images/smile_flower.png')
Image.register(:aura,'images/aura.png')
Image.register(:waterfall,'images/waterfall.png')

#音声の読み込み
Sound.register(:damage,'sounds/damage.mp3')
Sound.register(:select,'sounds/select.mp3')
Sound.register(:cancel,'sounds/cancel.mp3')
Sound.register(:heal,'sounds/heal.wav')
Sound.register(:start,'sounds/start.mp3')
Sound.register(:result,'sounds/result.mp3')
Sound.register(:change,'sounds/change.mp3')

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
    card << book = Item.new("呪文",0,5,Image[:book])                            #9
    card << smile_flower = Item.new("スマイルの花",5,0,Image[:smile_flower])    #10
    card << aura = Magic.new("オーラ",10,1,Image[:aura])                        #11
    card << waterfall = Magic.new("滝",15,2,Image[:waterfall]) 
    gamestart = true
    gameset = false
    Window.loop do
       #スタート画面
        if gamestart 
            puts "start"
            font1 = Font.new(150)
            x = Input.mouse_x
            y = Input.mouse_y
            Window.draw_box_fill(0, 0, 1400, 700, [180, 250, 200])#背景
            Window.draw_font(300, 200, "BUDFIELD", font1, {:color => [240,130,200]})
            Window.draw_box_fill(550, 500, 750, 620, C_WHITE, 0) 
            Window.draw_font(590, 550, "生誕する", font, {:color => C_BLACK})  
            if x>550 && x<750 && y>500 && y<620
                if Input.mouse_push?(M_LBUTTON)
                    gamestart = false
                end
            end
        else

            player.hp=30
            player.mp=10
            com.hp=30
            com.mp=10

            hand=[]
            hand_exist=[] #手札にあるか
            field=[]
            
            comhand=[]
            comhand_exist=[] #手札にあるか
            comfield=[]

            
            #手札生成
            5.times { 
                hand << rand(12)
                hand_exist << 1
                comhand << rand(12)
                comhand_exist << 1
            }
            Sound[:start].play
            turn = 0
            winer = ""
            soundflag = true
            Window.loop do
                 ###########  gamse over scene      ##########
                if gameset
                    if soundflag
                        Sound[:result].play
                        soundflag = false
                    end
                    font1 = Font.new(150)
                    x = Input.mouse_x
                    y = Input.mouse_y
                    Window.draw_box_fill(0, 0, 1400, 700, [128, 240, 50])#背景
                    Window.draw_font(100, 50, "RESULT", font1, {:color => C_BLACK})
                    Window.draw_box_fill(300, 500, 600, 620, C_WHITE, 0) 
                    Window.draw_font(350, 550, "CONTINUE", font, {:color => C_BLACK}) 
                    Window.draw_font(100, 250, winer, font, {:color => C_RED})
                    if x>300 && x<600 && y>500 && y<620
                        if Input.mouse_push?(M_LBUTTON)
                            gamestart = true
                            gameset = false
                            Sound[:start].play
                            break
                        end
                    end
                else 
                ####     game     #####
                Window.draw_box_fill(0, 0, 1400, 700, [128, 255, 150], 0)#背景
                Window.draw_box(150, 100, 500, 500, C_WHITE, 0)#フィールド
                Window.draw_box(600, 100, 950, 500, C_WHITE, 0)#フィールド
                Window.draw_font(250, 20, "PLAYER", font, {:color => C_BLACK})
                Window.draw_font(700, 20, "COM", font, {:color => C_BLACK})
                Window.draw_font(1000, 20, "PLAYER HP:#{player.hp} MP:#{player.mp}", font, {:color => C_BLACK})
                Window.draw_font(1000, 120, "COM HP:#{com.hp} MP:#{com.mp}", font, {:color => C_BLACK})

                if player.hp<=0 || com.hp<=0 
                    if player.hp<=0
                        winer = "YOU LOSE"
                    else
                        winer = "YOU WIN!!"
                    end
                    player.hp=20
                    player.mp=10
                    com.hp=20
                    com.mp=10
                    turn=0
                    gameset = true
                    next
                end

                x = Input.mouse_x
                y = Input.mouse_y
            
                ############     player attack     ##########
                if turn==0
                Window.draw_font(500, 20, "→", font, {:color => C_BLACK})
                
                ###  カード選択  ###
                if Input.mouse_push?(M_LBUTTON)
                    if y > 540 && y < 660
                        if x > 90 && x < 210
                            if hand_exist[0] == 1 && !card[hand[0]].kind_of?(Armor)
                                if field.size ==0 || field.size ==1 && card[hand[0]].class != card[field[0]].class&& !(card[hand[0]].kind_of?(Weapon) && card[field[0]].kind_of?(Item) || card[hand[0]].kind_of?(Item) && card[field[0]].kind_of?(Weapon))
                                    if card[hand[0]].kind_of?(Magic)
                                        if card[hand[0]].mp <= player.mp
                                            Sound[:select].play 
                                            field << hand[0]
                                            hand_exist[0]=0
                                        end
                                    else
                                        Sound[:select].play 
                                        field << hand[0]
                                        hand_exist[0]=0
                                    end
                                end
                            elsif hand_exist[0] == 0
                                Sound[:cancel].play
                                field.delete(hand[0])
                                hand_exist[0]=1
                            end
                        elsif x > 240 && x < 360
                            if hand_exist[1] == 1  && !card[hand[1]].kind_of?(Armor)
                                if field.size ==0 || field.size ==1 && card[hand[1]].class != card[field[0]].class&& !(card[hand[1]].kind_of?(Weapon) && card[field[0]].kind_of?(Item) || card[hand[1]].kind_of?(Item) && card[field[0]].kind_of?(Weapon))
                                    if card[hand[1]].kind_of?(Magic)
                                        if card[hand[1]].mp <= player.mp
                                            Sound[:select].play 
                                            field << hand[1]
                                            hand_exist[1]=0
                                        end
                                    else
                                        Sound[:select].play
                                        field << hand[1]
                                        hand_exist[1]=0
                                    end
                                end
                            elsif hand_exist[1] == 0
                                Sound[:cancel].play
                                field.delete(hand[1])
                                hand_exist[1]=1
                            end
                        elsif x > 390 && x < 510
                            if hand_exist[2] == 1  && !card[hand[2]].kind_of?(Armor)
                                if field.size ==0 || field.size ==1 && card[hand[2]].class != card[field[0]].class&& !(card[hand[2]].kind_of?(Weapon) && card[field[0]].kind_of?(Item) || card[hand[2]].kind_of?(Item) && card[field[0]].kind_of?(Weapon))
                                    if card[hand[2]].kind_of?(Magic)
                                        if card[hand[2]].mp <= player.mp
                                            Sound[:select].play 
                                            field << hand[2]
                                            hand_exist[2]=0
                                        end
                                    else
                                        Sound[:select].play
                                        field << hand[2]
                                        hand_exist[2]=0
                                    end
                                end
                            elsif hand_exist[2] == 0
                                Sound[:cancel].play
                                field.delete(hand[2])
                                hand_exist[2]=1
                            end
                        elsif x > 540 && x < 660
                            if hand_exist[3] == 1  && !card[hand[3]].kind_of?(Armor)
                                if field.size ==0 || field.size ==1 && card[hand[3]].class != card[field[0]].class&& !(card[hand[3]].kind_of?(Weapon) && card[field[0]].kind_of?(Item) || card[hand[3]].kind_of?(Item) && card[field[0]].kind_of?(Weapon))
                                    if card[hand[3]].kind_of?(Magic)
                                        if card[hand[3]].mp <= player.mp
                                            Sound[:select].play 
                                            field << hand[3]
                                            hand_exist[3]=0
                                        end
                                    else
                                        Sound[:select].play
                                        field << hand[3]
                                        hand_exist[3]=0
                                    end
                                end
                            elsif hand_exist[3] == 0
                                Sound[:cancel].play
                                field.delete(hand[3])
                                hand_exist[3]=1
                            end
                        elsif x > 690 && x < 810
                            if hand_exist[4] == 1  && !card[hand[4]].kind_of?(Armor)
                                if field.size ==0 || field.size ==1 && card[hand[4]].class != card[field[0]].class&& !(card[hand[4]].kind_of?(Weapon) && card[field[0]].kind_of?(Item) || card[hand[4]].kind_of?(Item) && card[field[0]].kind_of?(Weapon))
                                    if card[hand[4]].kind_of?(Magic)
                                        if card[hand[4]].mp <= player.mp
                                            Sound[:select].play 
                                            field << hand[4]
                                            hand_exist[4]=0
                                        end
                                    else
                                        Sound[:select].play
                                        field << hand[4]
                                        hand_exist[4]=0
                                    end
                                end
                            elsif hand_exist[4] == 0
                                Sound[:cancel].play
                                field.delete(hand[4])
                                hand_exist[4]=1
                            end
                        end
                    
                    elsif y > 430 && y < 480 && x > 200 && x < 450 && field.size == 0#祈る　相手のターンへ
                        Sound[:change].play
                        5.times do |n| 
                            hand[n] = rand(12)
                            hand_exist[n] = 1
                        end
                        sleep 1
                        turn=1
                    elsif y > 100 && y < 500 && x > 150 && x < 500 && field.size > 0 #カードを使用し相手のターンへ
                        turn=3
                    end
                end
                    
                    
                    
                    
                ###############    com attack   ############
                elsif turn==1
                Window.draw_font(500, 20, "←", font, {:color => C_BLACK})
                num=0
                5.times do |n|
                    if card[comhand[n]].kind_of?(Magic)
                        num+=1
                    end
                end
                r=rand(100)
                a=r%5
                if r==0
                    5.times do |n| 
                        comhand[n] = rand(12)
                        comhand_exist[n] = 1
                    end
                    comfield.slice!(0,comfield.size) #配列を空に
                    sleep 1
                    turn=0
                    
                elsif comhand_exist[a] == 1 && !card[comhand[a]].kind_of?(Armor)
                    if comfield.size ==0
                        if card[comhand[a]].kind_of?(Magic)
                            if card[comhand[a]].mp <= com.mp
                                Sound[:select].play
                                comfield << comhand[a]
                                comhand_exist[a] = 0
                            end
                        else
                            Sound[:select].play
                            comfield << comhand[a]
                            comhand_exist[a] = 0
                        end
                        if num == 0
                            turn = 2
                        end
                    elsif num > 0 && comfield.size ==1 && card[comhand[a]].class != card[comfield[0]].class&& !(card[comhand[a]].kind_of?(Weapon) && card[comfield[0]].kind_of?(Item) || card[comhand[a]].kind_of?(Item) && card[comfield[0]].kind_of?(Weapon))
                        if card[comhand[a]].kind_of?(Magic)
                            if card[comhand[a]].mp <= com.mp
                                Sound[:select].play
                                comfield << comhand[a]
                                comhand_exist[a] = 0
                            end
                            turn=2
                        else
                            Sound[:select].play
                            comfield << comhand[a]
                            comhand_exist[a] = 0
                            turn=2
                        end
                    end
                end
                    
                    
            
                    
                    
                ############     player defense     ##########
                elsif turn==2
                    Window.draw_font(500, 20, "←", font, {:color => C_BLACK})
                    ###  カード選択  ###
                    if Input.mouse_push?(M_LBUTTON)
                        if y > 540 && y < 660
                            if x > 90 && x < 210
                                if hand_exist[0] == 1  && card[hand[0]].kind_of?(Armor)
                                    Sound[:select].play
                                    field << hand[0]
                                    hand_exist[0]=0
                                elsif hand_exist[0] == 0
                                    Sound[:cancel].play
                                    field.delete(hand[0])
                                    hand_exist[0]=1
                                end
                            elsif x > 240 && x < 360
                                if hand_exist[1] == 1  && card[hand[1]].kind_of?(Armor)
                                    Sound[:select].play
                                    field << hand[1]
                                    hand_exist[1]=0
                                elsif hand_exist[1] == 0
                                    Sound[:cancel].play
                                    field.delete(hand[1])
                                    hand_exist[1]=1
                                end
                            elsif x > 390 && x < 510
                                if hand_exist[2] == 1  && card[hand[2]].kind_of?(Armor)
                                    Sound[:select].play
                                    field << hand[2]
                                    hand_exist[2]=0
                                elsif hand_exist[2] == 0
                                    Sound[:cancel].play
                                    field.delete(hand[2])
                                    hand_exist[2]=1
                                end
                            elsif x > 540 && x < 660
                                if hand_exist[3] == 1  && card[hand[3]].kind_of?(Armor)
                                    Sound[:select].play
                                    field << hand[3]
                                    hand_exist[3]=0
                                elsif hand_exist[3] == 0
                                    Sound[:cancel].play
                                    field.delete(hand[3])
                                    hand_exist[3]=1
                                end
                            elsif x > 690 && x < 810
                                if hand_exist[4] == 1  && card[hand[4]].kind_of?(Armor)
                                    Sound[:select].play
                                    field << hand[4]
                                    hand_exist[4]=0
                                elsif hand_exist[4] == 0
                                    Sound[:cancel].play
                                    field.delete(hand[4])
                                    hand_exist[4]=1
                                end
                            end
                        
                        elsif y > 430 && y < 480 && x > 200 && x < 450 && field.size == 0 || y > 100 && y < 500 && x > 150 && x < 500 && field.size > 0 #カードを使用し相手のターンへ
                            attack=0
                            comfield.each do |n|
                                if card[n].kind_of?(Weapon)               #Weapon使用
                                    attack += card[n].attack
                                end
                            end
                            
                            defence=0
                            field.each do |n|
                                if card[n].kind_of?(Armor)                #Armor使用
                                    defence += card[n].defence
                                end
                            end
                            
                            magic=0
                            comfield.each do |n|
                                if card[n].kind_of?(Magic)               #Magic使用
                                    if card[n].type == 1
                                        attack=attack*2
                                        com.mp-=card[n].mp
                                    elsif card[n].type == 2
                                        magic=20
                                        com.mp-=card[n].mp
                                    end   
                                end
                            end
                            
                            if attack-defence > 0
                                Sound[:damage].play
                                player.hp -= attack-defence
                                Window.draw_font(1200, 500, "#{attack-defence}ダメージ!!!", font, {:color => C_RED})
                            end
                            if magic > 0
                                Sound[:damage].play
                                player.hp -= magic
                                Window.draw_font(1200, 500, "#{magic}ダメージ!!!", font, {:color => C_RED})
                            end
                            
                            comfield.each do |n|                          
                                if card[n].kind_of?(Item)                 #Item使用
                                    com.hp += card[n].hp
                                    com.mp += card[n].mp
                                    Sound[:heal].play
                                end
                            end
                            field.slice!(0,field.size) #配列を空に
                            comfield.slice!(0,comfield.size) #配列を空に
                            #足りない枚数手札を増やす
                            hand.each_with_index do |n,i|
                                if hand_exist[i] == 0
                                    hand[i]=rand(12)
                                    hand_exist[i]=1
                                end
                            end
                            comhand.each_with_index do |n,i|
                            if comhand_exist[i] == 0
                                    comhand[i]=rand(12)
                                    comhand_exist[i]=1
                                end
                            end
                            if Input.mouse_release?(M_LBUTTON)
                                sleep 1
                                turn=0
                            end
                        end
                    end
                    
                    
                    
                ###############    com defence   ############
                elsif turn==3
                    Window.draw_font(500, 20, "→", font, {:color => C_BLACK})
                    
                    a=rand(5)
                    if comhand_exist[a] == 1 && comfield.size < 2 && card[comhand[a]].kind_of?(Armor)
                        Sound[:select].play
                        comfield << comhand[a]
                        comhand_exist[a] = 0
                    end
                    attack=0
                    field.each do |n|
                        if card[n].kind_of?(Weapon)             #Weapon使用
                            attack += card[n].attack
                        end
                    end
                    
                    defence=0
                    comfield.each do |n|
                        if card[n].kind_of?(Armor)              #Armor使用
                            defence += card[n].defence
                        end
                    end
                    
                    magic=0
                    mp=0
                    field.each do |n|
                        if card[n].kind_of?(Magic)               #Magic使用
                            if card[n].type == 1
                                attack=attack*2
                                mp=card[n].mp
                            elsif card[n].type == 2
                                magic=20
                                mp=card[n].mp
                            end   
                        end
                    end
                            
                    if attack-defence > 0
                        Window.draw_font(1200, 500, "#{attack-defence}ダメージ!!!", font, {:color => C_RED}) 
                    end
                    if magic > 0
                        Window.draw_font(1200, 500, "#{magic}ダメージ!!!", font, {:color => C_RED})
                    end
                    if Input.mouse_push?(M_LBUTTON) #playerのターンへ
                        if attack-defence > 0
                            Sound[:damage].play
                            com.hp -= attack-defence
                        end
                        if magic > 0
                            Sound[:damage].play
                            com.hp -= magic
                        end
                        
                        player.mp-=mp
                        
                        field.each do |n|                          
                            if card[n].kind_of?(Item)                 #Item使用
                                player.hp += card[n].hp
                                player.mp += card[n].mp
                                Sound[:heal].play
                            end
                        end
                            
                        field.slice!(0,field.size) #配列を空に
                        comfield.slice!(0,comfield.size) #配列を空に
                        #足りない枚数手札を増やす
                        hand.each_with_index do |n,i|
                            if hand_exist[i] == 0
                                hand[i]=rand(12)
                                hand_exist[i]=1
                            end
                        end
                        comhand.each_with_index do |n,i|
                            if comhand_exist[i] == 0
                                comhand[i]=rand(12)
                                comhand_exist[i]=1
                            end
                        end
                        
                        turn=1
                    end 
                end



                ##############     表示    ############
                #手札の表示
                if turn==0 || turn==2 #playerのターン
                    hand.each_with_index do |n,i|
                        Window.draw(150*i+90,540,card[n].image,0)
                        if hand_exist[i] == 0
                            Window.draw_box(150*i+90, 540, 150*i+210, 660, C_RED, 0)
                        end
                    end
                elsif turn==1 || turn == 3 #comのターン
                    hand.each_with_index do |n,i|
                        if hand_exist[i] == 1
                            Window.draw(150*i+90,540,card[n].image,0)
                        else
                            Window.draw_box(150*i+90, 540, 150*i+210, 660, C_WHITE, 0)
                        end
                    end
                end
                
                
                if field.size == 0
                    Window.draw_box_fill(200, 430, 450, 480, C_WHITE, 0)#祈るボタン
                    if(turn == 2)
                        Window.draw_font(300, 445, "許す", font, {:color => C_BLACK})
                    else
                        Window.draw_font(300, 445, "祈る", font, {:color => C_BLACK})
                    end
                end
                #カードステータスの表示
                if y > 540 && y < 660
                    if x > 90 && x < 210
                        Window.draw_box_fill(1000, 300, 1350, 440, C_WHITE, 0)
                        Window.draw(1020,310,card[hand[0]].image,0)
                        Window.draw_font(1150, 320,card[hand[0]].name, font, {:color => C_BLACK})
                        if card[hand[0]].kind_of?(Weapon)
                            Window.draw_font(1150, 360,"攻撃力：#{card[hand[0]].attack}" , font, {:color => C_BLACK})
                        elsif card[hand[0]].kind_of?(Armor)
                            Window.draw_font(1150, 360,"防御力：#{card[hand[0]].defence}" , font, {:color => C_BLACK})
                        elsif card[hand[0]].kind_of?(Item)
                            Window.draw_font(1150, 360,"HP+#{card[hand[0]].hp}\nMP+#{card[hand[0]].mp}" , font, {:color => C_BLACK})
                        elsif card[hand[0]].kind_of?(Magic)
                            if card[hand[0]].type==1
                                Window.draw_font(1150, 360,"消費MP：#{card[hand[0]].mp}" , font, {:color => C_BLACK})
                                Window.draw_font(1150, 400,"攻撃力 2倍" , font, {:color => C_BLACK})
                            elsif card[hand[0]].type==2
                                Window.draw_font(1150, 360,"消費MP：#{card[hand[0]].mp}" , font, {:color => C_BLACK})
                                Window.draw_font(1150, 400,"20ダメージ" , font, {:color => C_BLACK})
                            end
                        end
                    elsif x > 240 && x < 360
                        Window.draw_box_fill(1000, 300, 1350, 440, C_WHITE, 0)
                        Window.draw(1020,310,card[hand[1]].image,0)
                        Window.draw_font(1150, 320,card[hand[1]].name, font, {:color => C_BLACK})
                        if card[hand[1]].kind_of?(Weapon)
                            Window.draw_font(1150, 360,"攻撃力：#{card[hand[1]].attack}" , font, {:color => C_BLACK})
                        elsif card[hand[1]].kind_of?(Armor)
                            Window.draw_font(1150, 360,"防御力：#{card[hand[1]].defence}" , font, {:color => C_BLACK})
                        elsif card[hand[1]].kind_of?(Item)
                            Window.draw_font(1150, 360,"HP+#{card[hand[1]].hp}\nMP+#{card[hand[1]].mp}" , font, {:color => C_BLACK})
                        elsif card[hand[1]].kind_of?(Magic)
                            if card[hand[1]].type==1
                                Window.draw_font(1150, 360,"消費MP：#{card[hand[1]].mp}" , font, {:color => C_BLACK})
                                Window.draw_font(1150, 400,"攻撃力 2倍" , font, {:color => C_BLACK})
                            elsif card[hand[1]].type==2
                                Window.draw_font(1150, 360,"消費MP：#{card[hand[1]].mp}" , font, {:color => C_BLACK})
                                Window.draw_font(1150, 400,"20ダメージ" , font, {:color => C_BLACK})
                            end
                        end
                    elsif x > 390 && x < 510
                        Window.draw_box_fill(1000, 300, 1350, 440, C_WHITE, 0)
                        Window.draw(1020,310,card[hand[2]].image,0)
                        Window.draw_font(1150, 320,card[hand[2]].name, font, {:color => C_BLACK})
                        if card[hand[2]].kind_of?(Weapon)
                            Window.draw_font(1150, 360,"攻撃力：#{card[hand[2]].attack}" , font, {:color => C_BLACK})
                        elsif card[hand[2]].kind_of?(Armor)
                            Window.draw_font(1150, 360,"防御力：#{card[hand[2]].defence}" , font, {:color => C_BLACK})
                        elsif card[hand[2]].kind_of?(Item)
                            Window.draw_font(1150, 360,"HP+#{card[hand[2]].hp}\nMP+#{card[hand[2]].mp}" , font, {:color => C_BLACK})
                        elsif card[hand[2]].kind_of?(Magic)
                            if card[hand[2]].type==1
                                Window.draw_font(1150, 360,"消費MP：#{card[hand[2]].mp}" , font, {:color => C_BLACK})
                                Window.draw_font(1150, 400,"攻撃力 2倍" , font, {:color => C_BLACK})
                            elsif card[hand[2]].type==2
                                Window.draw_font(1150, 360,"消費MP：#{card[hand[2]].mp}" , font, {:color => C_BLACK})
                                Window.draw_font(1150, 400,"20ダメージ" , font, {:color => C_BLACK})
                            end
                        end
                    elsif x > 540 && x < 660
                        Window.draw_box_fill(1000, 300, 1350, 440, C_WHITE, 0)
                        Window.draw(1020,310,card[hand[3]].image,0)
                        Window.draw_font(1150, 320,card[hand[3]].name, font, {:color => C_BLACK})
                        if card[hand[3]].kind_of?(Weapon)
                            Window.draw_font(1150, 360,"攻撃力：#{card[hand[3]].attack}" , font, {:color => C_BLACK})
                        elsif card[hand[3]].kind_of?(Armor)
                            Window.draw_font(1150, 360,"防御力：#{card[hand[3]].defence}" , font, {:color => C_BLACK})
                        elsif card[hand[3]].kind_of?(Item)
                            Window.draw_font(1150, 360,"HP+#{card[hand[3]].hp}\nMP+#{card[hand[3]].mp}" , font, {:color => C_BLACK})
                        elsif card[hand[3]].kind_of?(Magic)
                            if card[hand[3]].type==1
                                Window.draw_font(1150, 360,"消費MP：#{card[hand[3]].mp}" , font, {:color => C_BLACK})
                                Window.draw_font(1150, 400,"攻撃力 2倍" , font, {:color => C_BLACK})
                            elsif card[hand[3]].type==2
                                Window.draw_font(1150, 360,"消費MP：#{card[hand[3]].mp}" , font, {:color => C_BLACK})
                                Window.draw_font(1150, 400,"20ダメージ" , font, {:color => C_BLACK})
                            end
                        end      
                    elsif x > 690 && x < 810
                        Window.draw_box_fill(1000, 300, 1350, 440, C_WHITE, 0)
                        Window.draw(1020,310,card[hand[4]].image,0)
                        Window.draw_font(1150, 320,card[hand[4]].name, font, {:color => C_BLACK})
                        if card[hand[4]].kind_of?(Weapon)
                            Window.draw_font(1150, 360,"攻撃力：#{card[hand[4]].attack}" , font, {:color => C_BLACK})
                        elsif card[hand[4]].kind_of?(Armor)
                            Window.draw_font(1150, 360,"防御力：#{card[hand[4]].defence}" , font, {:color => C_BLACK})
                        elsif card[hand[4]].kind_of?(Item)
                            Window.draw_font(1150, 360,"HP+#{card[hand[4]].hp}\nMP+#{card[hand[4]].mp}" , font, {:color => C_BLACK})
                        elsif card[hand[4]].kind_of?(Magic)
                            if card[hand[4]].type==1
                                Window.draw_font(1150, 360,"消費MP：#{card[hand[4]].mp}" , font, {:color => C_BLACK})
                                Window.draw_font(1150, 400,"攻撃力 2倍" , font, {:color => C_BLACK})
                            elsif card[hand[4]].type==2
                                Window.draw_font(1150, 360,"消費MP：#{card[hand[4]].mp}" , font, {:color => C_BLACK})
                                Window.draw_font(1150, 400,"20ダメージ" , font, {:color => C_BLACK})
                            end
                        end
                    end
                end
                attack = 0
                defence =0
                hp = 0
                mp = 0
                #場のカードの表示
                field.each_with_index do |n,i|
                    Window.draw(240,125*i+100,card[n].image,0)
                    if card[n].kind_of?(Weapon)
                        attack += card[n].attack
                    elsif card[n].kind_of?(Armor)
                        defence += card[n].defence
                    elsif card[n].kind_of?(Item)
                        hp += card[n].hp
                        mp += card[n].mp
                    end
                    Window.draw_box_fill(200, 430, 450, 480, C_WHITE, 0)
                    if card[n].kind_of?(Weapon)
                        Window.draw_font(260, 435, "攻：#{attack}", font, {:color => C_BLACK})
                    elsif card[n].kind_of?(Armor)
                        Window.draw_font(260, 435, "防：#{defence}", font, {:color => C_BLACK})
                    elsif card[n].kind_of?(Item)
                        Window.draw_font(225, 435, "HP：#{hp},MP：#{mp}", font, {:color => C_BLACK})
                    elsif card[n].kind_of?(Magic)
                        if card[n].type==1
                            Window.draw_font(260, 435,"攻撃力 2倍", font, {:color => C_BLACK})
                        elsif card[n].type==2
                            Window.draw_font(260, 435,"20ダメージ", font, {:color => C_BLACK})
                        end
                    end
                end
                
                attack = 0
                defence = 0
                hp = 0
                mp = 0
                comfield.each_with_index do |n,i|
                    Window.draw(740,125*i+100,card[n].image,0)
                    if card[n].kind_of?(Weapon)
                        attack += card[n].attack
                    elsif card[n].kind_of?(Armor)
                        defence += card[n].defence
                    elsif card[n].kind_of?(Item)
                        hp += card[n].hp
                        mp += card[n].mp
                    end
                    Window.draw_box_fill(700, 430, 950, 480, C_WHITE, 0)#祈るボタン
                    if card[n].kind_of?(Weapon)
                        Window.draw_font(750, 435, "攻：#{attack}", font, {:color => C_BLACK})
                    elsif card[n].kind_of?(Armor)
                        Window.draw_font(750, 435, "防：#{defence}", font, {:color => C_BLACK})
                    elsif card[n].kind_of?(Item)
                        Window.draw_font(750, 435, "HP：#{hp},MP：#{mp}", font, {:color => C_BLACK})
                    elsif card[n].kind_of?(Magic)
                        if card[n].type==1
                                Window.draw_font(750, 435,"攻撃力 2倍", font, {:color => C_BLACK})
                        elsif card[n].type==2
                                Window.draw_font(750, 435,"20ダメージ", font, {:color => C_BLACK})
                        end
                    end
                end
            
            end

            end
        end
    end
end
