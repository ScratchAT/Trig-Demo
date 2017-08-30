SCREEN 12
_FULLSCREEN
' Origin in Cartesian coordinates. (Changes when mouse is clicked.)
OriginX = -100
OriginY = -100

' Point of interest in Cartesian coordinates. (Changes while mouse moves.)
x = _MOUSEX
y = _MOUSEY
IF x > 0 AND x < 640 AND y > 0 AND y < 480 THEN
    GOSUB unconvert
    OriginX = x
    OriginY = y
ELSE
    ThePointX = 100
    ThePointY = 100
END IF

' Main loop.
DO
    DO WHILE _MOUSEINPUT
        x = _MOUSEX
        y = _MOUSEY
        IF x > 0 AND x < 640 AND y > 0 AND y < 480 THEN

            GOSUB unconvert
            ThePointX = x
            ThePointY = y

            IF _MOUSEBUTTON(1) THEN
                x = _MOUSEX
                y = _MOUSEY
                GOSUB unconvert
                OriginX = x
                OriginY = y
            END IF

        END IF
    LOOP
    GOSUB DrawEverything

LOOP

END

DrawEverything:
CLS
' Make Cartesian grid.
FOR x = OriginX TO 640 STEP 10
    LINE (x, 0)-(x, 480), 8
NEXT
FOR x = OriginX TO 0 STEP -10
    LINE (x, 0)-(x, 480), 8
NEXT
FOR y = OriginY TO 480 STEP 10
    LINE (0, -y + 240)-(640, -y + 240), 8
NEXT
FOR y = OriginY TO -240 STEP -10
    LINE (0, -y + 240)-(640, -y + 240), 8
NEXT
x = OriginX
y = OriginY
GOSUB convert
LINE (0, y)-(640, y), 7
LINE (x, 0)-(x, 480), 7
_PRINTSTRING (640 - 8 * 6, y), "X-axis"
_PRINTSTRING (x, 0), "Y-axis"
_PRINTSTRING (x, y), "Origin"
' Draw the circle on which the position vector lives.
Radius = SQR((ThePointX - OriginX) ^ 2 + (ThePointY - OriginY) ^ 2)
x = OriginX
y = OriginY
GOSUB convert
CIRCLE (x, y), Radius, 7
' Draw the vertical component.
x = OriginX
y = OriginY
GOSUB convert
x1 = x
y1 = y
x = ThePointX
y = OriginY
GOSUB convert
x2 = x
y2 = y
LINE (x1, y1)-(x2, y2), 9
LINE (x1, y1 + 1)-(x2, y2 + 1), 9
LINE (x1, y1 - 1)-(x2, y2 - 1), 9
' Draw the horizontal component.
x = ThePointX
y = OriginY
GOSUB convert
x1 = x
y1 = y
x = ThePointX
y = ThePointY
GOSUB convert
x2 = x
y2 = y
LINE (x1, y1)-(x2, y2), 4
LINE (x1 - 1, y1)-(x2 - 1, y2), 4
LINE (x1 + 1, y1)-(x2 + 1, y2), 4
' Draw position vector (aka the Hypotenuse).
x = OriginX
y = OriginY
GOSUB convert
x1 = x
y1 = y
x = ThePointX
y = ThePointY
GOSUB convert
x2 = x
y2 = y
LINE (x1, y1)-(x2, y2), 10
LINE (x1 + 1, y1)-(x2 + 1, y2), 10
LINE (x1, y1 + 1)-(x2, y2 + 1), 10
' Write text.
COLOR 7
LOCATE 1, 60: PRINT "-------Origin-------"
LOCATE 2, 60: PRINT "Cartesian/Polar/Qb64:"
LOCATE 3, 61: PRINT "X=0   , Y=0"
LOCATE 4, 61: PRINT "R=0   , Ang=undef"
LOCATE 5, 61: PRINT "x="; OriginX + 320; ", "; "y="; -OriginY + 240
LOCATE 7, 60: PRINT "-------Cursor-------"
LOCATE 8, 60: PRINT "Cartesian/Polar/Qb64:"
LOCATE 9, 61: PRINT "X="; ThePointX - OriginX; ", "; "Y="; ThePointY - OriginY
' Deal with radius calculation.
Radius = SQR((ThePointX - OriginX) ^ 2 + (ThePointY - OriginY) ^ 2)
IF Radius < .0001 THEN Radius = .0001
LOCATE 10, 61: PRINT "R="; INT(Radius); ", "; "Ang="; TheAngle
' Deal with the anlge calculation.
xdiff = ThePointX - OriginX
ydiff = ThePointY - OriginY
IF xdiff > 0 AND ydiff > 0 THEN ' First quadrant
    TheAngle = INT((180 / 3.14159) * ATN(ydiff / xdiff))
END IF
IF xdiff < 0 AND ydiff > 0 THEN ' Second quadrant
    TheAngle = 180 + INT((180 / 3.14159) * ATN(ydiff / xdiff))
END IF
IF xdiff < 0 AND ydiff < 0 THEN ' Third quadrant
    TheAngle = 180 + INT((180 / 3.14159) * ATN(ydiff / xdiff))
END IF
IF xdiff > 0 AND ydiff < 0 THEN ' Fourth quadrant
    TheAngle = 360 + INT((180 / 3.14159) * ATN(ydiff / xdiff))
END IF
IF SQR(ydiff ^ 2) < .0001 THEN ydiff = .0001
IF SQR(xdiff ^ 2) < .0001 THEN xdiff = .0001
LOCATE 11, 61: PRINT "x="; ThePointX + 320; ", "; "y="; -ThePointY + 240
LOCATE 13, 60: PRINT "--------Trig--------"
LOCATE 14, 61: PRINT "sin(Ang)=";: COLOR 4: PRINT "Opp";: COLOR 7: PRINT "/";: COLOR 10: PRINT "Hyp";: COLOR 7
LOCATE 15, 61: PRINT "        ="; USING "##.###"; ydiff / Radius
LOCATE 16, 61: PRINT "cos(Ang)=";: COLOR 9: PRINT "Adj";: COLOR 7: PRINT "/";: COLOR 10: PRINT "Hyp";: COLOR 7
LOCATE 17, 61: PRINT "        ="; USING "##.###"; xdiff / Radius
LOCATE 18, 61: PRINT "tan(Ang)=";: COLOR 4: PRINT "Opp";: COLOR 7: PRINT "/";: COLOR 9: PRINT "Adj";: COLOR 7
LOCATE 19, 61: PRINT "        ="; USING "####.###"; ydiff / xdiff
_DISPLAY
RETURN

convert:
' Converts Cartesian coordinates to QB64 coordinates.
x0 = x: y0 = y
x = x0 + 320
y = -y0 + 240
RETURN

unconvert:
' Converts QB64 coordinates to Cartesian coordinates.
x0 = x: y0 = y
x = x0 - 320
y = -y0 + 240
RETURN



