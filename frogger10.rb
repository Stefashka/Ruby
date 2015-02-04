# Konstanten - werden groß geschrieben
# Datei wird ab jetzt über Git verwaltet
#DIes ist ein Test für Hanna

FENSTER_BREITE= 800
FENSTER_HOEHE = 480
BEGRENZUNG_OBEN = 40
BEGRENZUNG_UNTEN = 400
BEGRENZUNG_RECHTS = 720
BEGRENZUNG_LINKS = 40

Shoes.app width: FENSTER_BREITE, height: FENSTER_HOEHE do

  image "Frogger_Hintergrund_Gimp.png",width: FENSTER_BREITE, height: FENSTER_HOEHE

  class Sammelobjekt

    attr_accessor :y_position, :x_position

    def initialize (app, pfad)

      @app = app
      @image = @app.image pfad, width: 30, height: 30
      @x_position = rand(40..680)
      @y_position = rand(40..360)
      @image.move(@x_position, @y_position)


    end

    def neuer_ort
      @x_position = rand(40..680)
      @y_position = rand(40..360)
      @image.move(@x_position, @y_position)

    end


  end


#Klasse Frosch

  class Frosch

    attr_accessor :x_position, :y_position

    def initialize(app,apfel)
      #speichert die Referenz zum Shoes Objekt um auf dessen Methoden zuzugreifen
      @app = app
      #position initialisieren
      @x_position = 400
      @y_position = 440
      #sprungweite initialisieren
      @sprungweite = 40
      #anfangsposition initialisieren damit der Frosch bei Lebenverlust auf diese Position zurückgesetzt wird
      @start_position_x = 400
      @start_position_y = 440
      #Anzahl der Leben - fester Wert, da dieser sich nicht ändern soll
      @leben = 3
      #Bild dem Objekt zuweisen (@app.image da dies Shoes Syntax ist)
      @image = @app.image "frogger_spielfigur_up.png", width: 40, height: 40
      #Der Frosch erscheint an dieser Position
      @image.move(@x_position, @y_position)
      @lebensherz1 = @app.image "herz.png", width: 20, height: 20,  right: 100, top: 10
      @lebensherz2 = @app.image "herz2.png", width: 20, height: 20, right: 60, top: 10
      @lebensherz3 = @app.image "herz3.png", width: 20, height: 20, right: 20, top: 10
      @bluftfleck = @app.image "blut.png", width: 40, height: 40, left: 20, top: 10
      @bluftfleck2 = @app.image "blut2.png", width: 40, height: 40, left: 20, top: 10
      @sammelobjekt = apfel
      @punkte = 0


    end

    #Diese Methode soll aufgerufen werden, wenn der Frosch sein leben verliert
    def leben_verloren
      @leben -= 1

    #Bedingungen, was passieren soll, wenn der Frosch 1, 2 oder 3 Leben verliert:

      if(@leben <= 0)
        @app.image "gameover.jpg", width: 800, height: 480, left:0, right: 0

      elsif @leben == 1
        @bluftfleck2.move(@x_position,@y_position)
        @x_position = @start_position_x
        @y_position = @start_position_y
        @image.move(@x_position, @y_position)
        alert "Leben verloren. Du hast nur noch #{@leben} Leben!"
        @lebensherz2.remove
      else
        @bluftfleck.move(@x_position,@y_position)
        @x_position = @start_position_x
        @y_position = @start_position_y
        @image.move(@x_position, @y_position)
        alert "Leben verloren. Du hast nur noch #{@leben} Leben!"
        @lebensherz1.remove
      end


    end

    #Diese Methode soll Tastedruckevent anlegen (wie Animation). Je nach Tastendruck wird hier definiert was mit dem
    #Frosch passieren soll
    def start
      @app.keypress do |k|
        if k ==:down and @y_position <= BEGRENZUNG_UNTEN
          @y_position +=  @sprungweite
          @image.path = "frogger_spielfigur_down.png"
        elsif k ==:up and @y_position >= BEGRENZUNG_OBEN
          @y_position -=  @sprungweite
          @image.path = "frogger_spielfigur_up.png"
        elsif k ==:right and @x_position <= BEGRENZUNG_RECHTS
          @x_position += @sprungweite
          @image.path = "frogger_spielfigur_right.png"
        elsif k ==:left and @x_position >= BEGRENZUNG_LINKS
          @x_position -= @sprungweite
          @image.path = "frogger_spielfigur_left.png"
        end
        #bewege den frosch
        @image.move(@x_position, @y_position)
        #sind wir am Ziel?
        if @y_position <= BEGRENZUNG_OBEN
          alert "Gewonnen!!!!"
        end

        linker_rand = @sammelobjekt.x_position - 30
        rechter_rand = @sammelobjekt.x_position + 35
        oberer_rand = @sammelobjekt.y_position - 30
        unterer_rand = @sammelobjekt.y_position + 30

        if(@x_position >= linker_rand and @x_position <= rechter_rand) and (@y_position >= oberer_rand and @y_position <= unterer_rand)
          @punkte += 10
          @sammelobjekt.neuer_ort
        end

      end
    end
     #Bewegt den Frosch auf die bestimmte Position (z.B. Baumstamm) - Wichtig damit der Frosch auf dem Baumstamm
    #sitzen bleiben kann. Wird in der Klasse Schwimmobjekte verwendet.
    def bewegen(x, y)
      @x_position = x
      @y_position = y
      @image.move(@x_position, @y_position)
    end




  end

# Klasse Schwimmobjekt

  class Schwimmobjekt

    def initialize(app,pfad,x,y,geschwindigkeit,breite,hoehe)
      @app = app
      @x_position = x
      @y_position = y
      @geschwindigkeit = geschwindigkeit
      @direction = 1
      @breite = breite

      @hoehe = hoehe
      @image = @app.image pfad, width:breite, height:hoehe
    end

    #starte den Prozess vom Objekt (fängt etwas zu tun an)
    #Übergabeparameter wird benötigt um auf andere vorhandene Objekte zuzugreifen
    def start(frosch)
      @frosch = frosch
      zufallszahl = rand(5)
      @app.timer(zufallszahl) do
          @app.animate (60) do |i|
          if @x_position > 800 - @breite
            @direction = -1
          elsif @x_position < 0 then
            @direction = 1
          end

          @x_position = @x_position + @geschwindigkeit * @direction
          @image.move(@x_position,@y_position)

          #Prüfe ob der Frosch auf dem Baustamm sitzt und bewege ihn mit, wenn Bedingung erfüllt ist
          if @frosch.y_position == @y_position

            rand_rechts = @x_position + @breite - 20 # -20 ist eine Toleranzgrenze
            rand_links = @x_position - 20
            frosch_x = @frosch.x_position

            if frosch_x >= rand_links and frosch_x <= rand_rechts
              frosch_x += @geschwindigkeit * @direction
              @frosch.bewegen(frosch_x, @frosch.y_position)
            else
              @frosch.leben_verloren
            end

          end
        end
      end
    end

  end

  #Klasse Fahrzeug

  class Fahrzeug

    attr_accessor :x_position, :y_position

    def initialize(app, pfad, breite, hoehe, x, y, geschwindigkeit, direction, koll_object )
      @app = app
      @x_position = x
      @y_position = y
      @geschwindigkeit = geschwindigkeit
      @direction = direction
      @kollisionsobjekt = koll_object
      @startposition = x
      @breite = breite
      @image = @app.image pfad, width:breite, height:hoehe
    end

    def bewegung

      @app.timer(rand(1..4)) do
        @app.animate (60) do
          if @x_position > 700 or @x_position < 40
             @x_position = @startposition
          else
            @x_position = @x_position + @geschwindigkeit * @direction
            @image.move(@x_position,@y_position)

            linker_rand = @x_position
            rechter_rand = @x_position + @breite - 20

            #Kollisionsfunktion direkt eingebaut in die Methode. 
            if(@kollisionsobjekt.x_position >= linker_rand and @kollisionsobjekt.x_position <= rechter_rand) and (@y_position == @kollisionsobjekt.y_position)
              @kollisionsobjekt.leben_verloren
            end
          end

        end
        end
    end
  end



  #Hauptprogramm

#Erstellen der Baumstämme
  baumstamm1 = Schwimmobjekt.new(self,"Baumstamm.jpg",800,120,1,200,30)
  baumstamm2 = Schwimmobjekt.new(self,"Baumstamm.jpg",800,200,1,100,30)
  baumstamm3 = Schwimmobjekt.new(self,"fass.png",-250,80,2,150,30)
  baumstamm4 = Schwimmobjekt.new(self,"schildkroete.png",-250,160,1,100,50)

#Erzeugen der Sammelobjekte

  apfel = Sammelobjekt.new(self,"apfel.png")

#Erstellen des Frosches
  frosch = Frosch.new(self,apfel)




  #starte die Bausmtammanimation und übergebe das objekt frosch
  baumstamm1.start(frosch)
  baumstamm2.start(frosch)
  baumstamm3.start(frosch)
  baumstamm4.start(frosch)

  #starte die Froschanimation
  frosch.start



#Erstellen des Autos

  auto = Fahrzeug.new(self, "Frogger_Auto_gelb.png",60,30,700,280,2, -1, frosch)
  auto6 = Fahrzeug.new(self, "Frogger_Auto_gelb.png",60,30,700,280,2, -1, frosch)
  auto2 = Fahrzeug.new(self,"Frogger_Auto_Hellblau.png",60,30,60,320,4, 1, frosch)
  auto3 = Fahrzeug.new(self, "Frogger_Auto_gelb.png",60,30,700,360,2, -1, frosch)
  auto4 = Fahrzeug.new(self, "Frogger_Auto_Hellblau.png",60,30,60,400,1, 1, frosch)
  auto5 = Fahrzeug.new(self, "Frogger_Auto_Hellblau.png",60,30,60,400,1, 1, frosch)

  #starte die Autobewegung
  auto.bewegung
  auto2.bewegung
  auto3.bewegung
  auto4.bewegung
  auto5.bewegung
  auto6.bewegung







end