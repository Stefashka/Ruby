Shoes.app width: 800, height: 480 do

  image "Frogger_Hintergrund_Gimp.png", width: 800, height: 480


  @position_frosch_x= 400
  @position_frosch_y= 440


  frosch_oben = image "frogger_spielfigur_up.png", width: 40, height: 40
  frosch_links = image "frogger_spielfigur_left.png", width: 40, height: 40
  frosch_rechts = image "frogger_spielfigur_right.png", width: 40, height: 40
  frosch_unten = image "frogger_spielfigur_down.png", width: 40, height: 40
  frosch_oben.move(400,440) #Damit der Frosch am Anfang an schon da sitzt

  animation= animate(60) do |i|

  keypress do |k|

    if k==:down
      frosch_unten.show.move(@position_frosch_x, @position_frosch_y + 40)
      @position_frosch_y += 40
      frosch_links.hide
      frosch_rechts.hide
      frosch_oben.hide

    elsif k==:up
      frosch_oben.show.move(@position_frosch_x, @position_frosch_y - 40)
      @position_frosch_y -= 40
      frosch_links.hide
      frosch_rechts.hide
      frosch_unten.hide

    elsif k==:right
      frosch_rechts.show.move(@position_frosch_x + 40, @position_frosch_y)
      @position_frosch_x += 40
      frosch_links.hide
      frosch_oben.hide
      frosch_unten.hide

    elsif k==:left
      frosch_links.show.move(@position_frosch_x - 40, @position_frosch_y)
      @position_frosch_x -= 40
      frosch_rechts.hide
      frosch_oben.hide
      frosch_unten.hide


    end


      end
    end





def baumstamm(x,y)

  speed = 1
  direction = 1 # Initialisierungswert - Ich bestimme die Anfangsrichtung
  baum = image "Baumstamm.jpg", width: 200, height: 30

  zufallszahl = rand(5)
  timer(zufallszahl) do

    animation = animation = animate (60) do |i|
      if x > 600 #abprallen Staemme am Rand
        direction = -1 #von rechts nach links
      elsif x < 0 #abprallen
        direction = 1
      end

      # Bewegungsrichtung
      x = x + speed * direction
      baum.move(x,y)

      linke_ecke_baum = x
      rechte_ecke_baum = x + 200
      linke_ecke_frosch = @position_frosch_x
      rechte_ecke_frosch = @position_frosch_x + 40

      if y == @position_frosch_y and
      @position_frosch_x > linke_ecke_baum and @position_frosch_x < rechte_ecke_baum
        baum.hide
        #animation.stop
        #para image "gameover.jpg"

      end




    end
  end
  end


baumstamm(-200,80) #Startpunkt außerhalb des Fensters
baumstamm(800,120)
baumstamm(-200,160)
baumstamm(800,200)


end




