class Game
    def init
        player.hp = 20
        player.mp = 10
        com.hp = 20
        com.mp = 10
    end
    def player_turn(hand,hand_exist,field)
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
    end
    def com_turn(hand,hand_exist,field)
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