-- Lua Height widget
--
--
--
-- widget display groessen
-- 3x3 Raster = 256x78
-- 3x1 = 256x294
-- 3x2 = 256x132
-- 2x2 = 388x132
-- 2x1 = 388x294
-- 1x2 = 784x132
-- 1x1 = 784x294
-- full 800x458
--


local function create()
    return {
        value=nil,
        menuSw = nil, -- Initialize menuSw with a default switch
        SteigrateActive = 800, -- Default value for SteigrateActive
        SteigrateMin = 100, -- Default value for SteigrateMin
        wHeightReset = nil, -- Initialize wHeightReset with a default switch
        modelName = model.name();

    }
    
end
local scriptVersion = "1.0.1"
local hedline = {de="Starthoehe "..scriptVersion,
                 en ="Startheight "..scriptVersion}
local waitForStart = {de= "Warte auf start",
                      en= "wait for Start"}
local menuL = {de = "Starthoehe zuruecksetzen",
               en = "reset Startheight"}
local configStgR = {de = "Steigrate für Starterkennung",
                    en = "climb rate for start detection"}
local configStgRmin = {de = "Steigrate höchster Punkt",
                       en = "climb rate highest point"}
local configResetSwitch = {de = "SW für Startreset",
                           en = "switch for start reset"}
local configMenuSwitch = {de = "SW für Flughistorie",
                           en = "switch to open last flights"}
local LastMenuL = {de = "Letzte Fluege anzeigen",
                           en = "Open last flights"}
local mainMenuL = {de = "Startseite",
                    en = "Main page"}
local headHistory = {de = "Letzte Starts",
                    en = "Last starts"}
local headHistoryPath = {de = "Historien Dateiname",
                    en = "history filename"}
local menuSwitch = "Default"
local HistoryMenu = 0


local function name(widget)
    locale = system.getLocale()
    return hedline[locale]
end

local function paint(widget)
    local w, h = lcd.getWindowSize()
    -- Widget größe bestimmen und anpassen
    local lcdBorder = 2
    local text_w, text_h = lcd.getTextSize("")
    local widgetSizeType = nil
    local calcSteigrateMin = widget.SteigrateMin /100
    local calcSteigrateActive = widget.SteigrateActive /100
    
    if HistoryMenu == 1 then
        local filePath = widget.modelName.."-startheight.txt"
        local entries = {}
        menuSwitch = mainMenuL[locale]

        -- Datei öffnen
        local file = io.open(filePath, "r")
        if file then
            while true do
                local success, line = pcall(function() return file:read("L") end) -- Liest eine Zeile
                if not success or not line then
                    break -- Beende die Schleife, wenn ein Fehler auftritt oder das Ende der Datei erreicht ist
                end
                table.insert(entries, line) -- Zeile zur Liste hinzufügen
            end
            file:close()
        else
            print("Datei konnte nicht geöffnet werden:", filePath)
        end


        if w <= 256 and h <= 78 
        then 
            widgetSizeType = "3x3"
            lcd.font(FONT_S_BOLD)        
            lcd.drawText(lcdBorder, lcdBorder, headHistory[locale], LEFT)
            lcd.font(FONT_S)
            -- Debug-Ausgabe der Einträge
            if #entries == 0 then
                lcd.font(FONT_S_BOLD)
                print("Keine Daten vorhanden")
                lcd.drawText(lcdBorder, text_h+5, "Keine Daten vorhanden", LEFT)
            else
                lcd.font(FONT_S)
                local y = text_h -- Startposition für die Anzeige auf dem LCD
                for _, entry in ipairs(entries) do
                    lcd.drawText(lcdBorder, y, entry, LEFT)
                    y = y + text_h+1 -- Abstand zwischen den Zeilen
                end
            end

            
        elseif w <= 256 and h <= 132 then 
            widgetSizeType = "3x2"
            lcd.font(FONT_S_BOLD)        
            lcd.drawText(lcdBorder, lcdBorder, headHistory[locale], LEFT)
            lcd.font(FONT_S)
            -- Debug-Ausgabe der Einträge
            if #entries == 0 then
                lcd.font(FONT_S_BOLD)
                print("Keine Daten vorhanden")
                lcd.drawText(lcdBorder, text_h+5, "Keine Daten vorhanden", LEFT)
            else
                lcd.font(FONT_S)
                local y = text_h -- Startposition für die Anzeige auf dem LCD
                for _, entry in ipairs(entries) do
                    lcd.drawText(lcdBorder, y, entry, LEFT)
                    y = y + text_h+1 -- Abstand zwischen den Zeilen
                end
            end
            
        elseif w <= 256 and h <= 294 then 
            widgetSizeType = "3x1"
            lcd.font(FONT_S_BOLD)        
            lcd.drawText(lcdBorder, lcdBorder, headHistory[locale], LEFT)
            lcd.font(FONT_S)
            -- Debug-Ausgabe der Einträge
            if #entries == 0 then
                lcd.font(FONT_S_BOLD)
                print("Keine Daten vorhanden")
                lcd.drawText(lcdBorder, text_h+5, "Keine Daten vorhanden", LEFT)
            else
                lcd.font(FONT_S)
                local y = text_h -- Startposition für die Anzeige auf dem LCD
                for _, entry in ipairs(entries) do
                    lcd.drawText(lcdBorder, y, entry, LEFT)
                    y = y + text_h+1 -- Abstand zwischen den Zeilen
                end
            end
            
        elseif w <= 388 and h <= 132 then 
            widgetSizeType = "2x2"
            lcd.font(FONT_L_BOLD)        
            lcd.drawText(lcdBorder, lcdBorder, headHistory[locale], LEFT)
            lcd.font(FONT_BOLD)-- Debug-Ausgabe der Einträge
            if #entries == 0 then
                lcd.font(FONT_L_BOLD)
                print("Keine Daten vorhanden")
                lcd.drawText(lcdBorder, text_h+5, "Keine Daten vorhanden", LEFT)
            else
                lcd.font(FONT_BOLD)
                local y = text_h+5 -- Startposition für die Anzeige auf dem LCD
                for _, entry in ipairs(entries) do
                    lcd.drawText(lcdBorder, y, entry, LEFT)
                    y = y + text_h + 1 -- Abstand zwischen den Zeilen
                end
            end
            
        elseif w <= 388 and h <= 294 then 
            widgetSizeType = "2x1"
            lcd.font(FONT_L_BOLD)        
            lcd.drawText(lcdBorder, lcdBorder, headHistory[locale], LEFT)
            lcd.font(FONT_BOLD)
            -- Debug-Ausgabe der Einträge
            if #entries == 0 then
                lcd.font(FONT_L_BOLD)
                print("Keine Daten vorhanden")
                lcd.drawText(lcdBorder, text_h+5, "Keine Daten vorhanden", LEFT)
            else
                lcd.font(FONT_BOLD)
                local y = text_h+5 -- Startposition für die Anzeige auf dem LCD
                for _, entry in ipairs(entries) do
                    lcd.drawText(lcdBorder, y, entry, LEFT)
                    y = y + text_h + 1 -- Abstand zwischen den Zeilen
                end
            end
            
        elseif w <= 784 and h <= 132 then 
            widgetSizeType = "1x2"
            lcd.font(FONT_L_BOLD)        
            lcd.drawText(lcdBorder, lcdBorder, headHistory[locale], LEFT)
            lcd.font(FONT_BOLD)
            -- Debug-Ausgabe der Einträge
            if #entries == 0 then
                lcd.font(FONT_L_BOLD)
                print("Keine Daten vorhanden")
                lcd.drawText(lcdBorder, text_h+5, "Keine Daten vorhanden", LEFT)
            else
                lcd.font(FONT_BOLD)
                local y = text_h+5 -- Startposition für die Anzeige auf dem LCD
                for _, entry in ipairs(entries) do
                    lcd.drawText(lcdBorder, y, entry, LEFT)
                    y = y + text_h + 1 -- Abstand zwischen den Zeilen
                end
            end
            
        elseif w <= 784 and h <= 294 then 
            widgetSizeType = "1x1"
            lcd.font(FONT_L_BOLD)        
            lcd.drawText(lcdBorder, lcdBorder, headHistory[locale], LEFT)
            lcd.font(FONT_BOLD)
            

            -- Debug-Ausgabe der Einträge
            if #entries == 0 then
                lcd.font(FONT_L_BOLD)
                print("Keine Daten vorhanden")
                lcd.drawText(lcdBorder, text_h+5, "Keine Daten vorhanden", LEFT)
            else
                lcd.font(FONT_BOLD)
                local y = text_h+5 -- Startposition für die Anzeige auf dem LCD
                for _, entry in ipairs(entries) do
                    lcd.drawText(lcdBorder, y, entry, LEFT)
                    y = y + text_h + 1 -- Abstand zwischen den Zeilen
                end
            end
            
        elseif w <= 800 and h <= 458 then 
            widgetSizeType = "full"
            lcd.font(FONT_L_BOLD)        
            lcd.drawText(lcdBorder, lcdBorder, headHistory[locale], LEFT)
            lcd.font(FONT_BOLD)
            

            -- Debug-Ausgabe der Einträge
            if #entries == 0 then
                lcd.font(FONT_L_BOLD)
                print("Keine Daten vorhanden")
                lcd.drawText(lcdBorder, text_h+5, "Keine Daten vorhanden", LEFT)
            else
                lcd.font(FONT_BOLD)
                local y = text_h+5 -- Startposition für die Anzeige auf dem LCD
                for _, entry in ipairs(entries) do
                    lcd.drawText(lcdBorder, y, entry, LEFT)
                    y = y + text_h + 1 -- Abstand zwischen den Zeilen
                end
            end
            
        else 
            widgetSizeType = "Default"
            lcd.font(FONT_L_BOLD)        
            lcd.drawText(lcdBorder, lcdBorder, headHistory[locale], LEFT)
            lcd.font(FONT_BOLD)
            

            -- Debug-Ausgabe der Einträge
            if #entries == 0 then
                lcd.font(FONT_L_BOLD)
                print("Keine Daten vorhanden")
                lcd.drawText(lcdBorder, text_h+5, "Keine Daten vorhanden", LEFT)
            else
                lcd.font(FONT_BOLD)
                local y = text_h+5 -- Startposition für die Anzeige auf dem LCD
                for _, entry in ipairs(entries) do
                    lcd.drawText(lcdBorder, y, entry, LEFT)
                    y = y + text_h + 1 -- Abstand zwischen den Zeilen
                end
            end
            
        end
        
    else
        menuSwitch = LastMenuL[locale]
        if w <= 256 and h <= 78 
        then 
            widgetSizeType = "3x3"
            lcd.font(FONT_XS)        
            lcd.drawText(lcdBorder, h-text_h-2, "Min:"..calcSteigrateMin.."m/s", LEFT)
            lcd.drawText(w-text_w-lcdBorder, h-text_h-2, "Active:"..calcSteigrateActive.."m/s", RIGHT)
            lcd.font(FONT_XL) 
            if widget.valueWurfhoehe ~= nil and widget.valueWurfhoehe ~= 0 and widget.valueWurfhoehe ~= "0" then
                lcd.drawText(w/2, h/2-text_h, widget.valueWurfhoehe, CENTERED)
            else
                lcd.drawText(w/2, h/2-text_h, waitForStart[locale], CENTERED)
            end
        elseif w <= 256 and h <= 132 then 
            widgetSizeType = "3x2"
            lcd.font(FONT_XS)        
            lcd.drawText(lcdBorder, h-text_h-2, "Min:"..calcSteigrateMin.."m/s", LEFT)
            lcd.drawText(w-text_w-lcdBorder, h-text_h-2, "Active:"..calcSteigrateActive.."m/s", RIGHT)
            lcd.font(FONT_XL) 
            if widget.valueWurfhoehe ~= nil and widget.valueWurfhoehe ~= 0 and widget.valueWurfhoehe ~= "0" then
                lcd.drawText(w/2, h/2-text_h, widget.valueWurfhoehe, CENTERED)
            else
                lcd.drawText(w/2, h/2-text_h, waitForStart[locale], CENTERED)
            end
        elseif w <= 256 and h <= 294 then 
            widgetSizeType = "3x1"
            lcd.font(FONT_XS)        
            lcd.drawText(lcdBorder, h-text_h-2, "Min:"..calcSteigrateMin.."m/s", LEFT)
            lcd.drawText(w-text_w-lcdBorder, h-text_h-2, "Active:"..calcSteigrateActive.."m/s", RIGHT)
            lcd.font(FONT_XL) 
            if widget.valueWurfhoehe ~= nil and widget.valueWurfhoehe ~= 0 and widget.valueWurfhoehe ~= "0" then
                lcd.drawText(w/2, h/2-text_h, widget.valueWurfhoehe, CENTERED)
            else
                lcd.drawText(w/2, h/2-text_h, waitForStart[locale], CENTERED)
            end
        elseif w <= 388 and h <= 132 then 
            widgetSizeType = "2x2"
            lcd.font(FONT_XS)        
            lcd.drawText(lcdBorder, h-text_h-2, "Min:"..calcSteigrateMin.."m/s", LEFT)
            lcd.drawText(w-text_w-lcdBorder, h-text_h-2, "Active:"..calcSteigrateActive.."m/s", RIGHT)
            lcd.font(FONT_XL) 
            if widget.valueWurfhoehe ~= nil and widget.valueWurfhoehe ~= 0 and widget.valueWurfhoehe ~= "0" then
                lcd.drawText(w/2, h/2-text_h, widget.valueWurfhoehe, CENTERED)
            else
                lcd.drawText(w/2, h/2-text_h, waitForStart[locale], CENTERED)
            end
        elseif w <= 388 and h <= 294 then 
            widgetSizeType = "2x1"
            lcd.font(FONT_XS)        
            lcd.drawText(lcdBorder, h-text_h-2, "Min:"..calcSteigrateMin.."m/s", LEFT)
            lcd.drawText(w-text_w-lcdBorder, h-text_h-2, "Active:"..calcSteigrateActive.."m/s", RIGHT)
            lcd.font(FONT_XL) 
            if widget.valueWurfhoehe ~= nil and widget.valueWurfhoehe ~= 0 and widget.valueWurfhoehe ~= "0" then
                lcd.drawText(w/2, h/2-text_h, widget.valueWurfhoehe, CENTERED)
            else
                lcd.drawText(w/2, h/2-text_h, waitForStart[locale], CENTERED)
            end
        elseif w <= 784 and h <= 132 then 
            widgetSizeType = "1x2"
            lcd.font(FONT_XS)        
            lcd.drawText(lcdBorder, h-text_h-2, "Min:"..calcSteigrateMin.."m/s", LEFT)
            lcd.drawText(w-text_w-lcdBorder, h-text_h-2, "Active:"..calcSteigrateActive.."m/s", RIGHT)
            lcd.font(FONT_XL) 
            if widget.valueWurfhoehe ~= nil and widget.valueWurfhoehe ~= 0 and widget.valueWurfhoehe ~= "0" then
                lcd.drawText(w/2, h/2-text_h, widget.valueWurfhoehe, CENTERED)
            else
                lcd.drawText(w/2, h/2-text_h, waitForStart[locale], CENTERED)
            end
        elseif w <= 784 and h <= 294 then 
            widgetSizeType = "1x1"
            lcd.font(FONT_XS)        
            lcd.drawText(lcdBorder, h-text_h-2, "Min:"..calcSteigrateMin.."m/s", LEFT)
            lcd.drawText(w-text_w-lcdBorder, h-text_h-2, "Active:"..calcSteigrateActive.."m/s", RIGHT)
            lcd.font(FONT_XL) 
            if widget.valueWurfhoehe ~= nil and widget.valueWurfhoehe ~= 0 and widget.valueWurfhoehe ~= "0" then
                lcd.drawText(w/2, h/2-text_h, widget.valueWurfhoehe, CENTERED)
            else
                lcd.drawText(w/2, h/2-text_h, waitForStart[locale], CENTERED)
            end
        elseif w <= 800 and h <= 458 then 
            widgetSizeType = "full"
            lcd.font(FONT_XS)        
            lcd.drawText(lcdBorder, h-text_h-2, "Min:"..calcSteigrateMin.."m/s", LEFT)
            lcd.drawText(w-text_w-lcdBorder, h-text_h-2, "Active:"..calcSteigrateActive.."m/s", RIGHT)
            lcd.font(FONT_XL) 
            if widget.valueWurfhoehe ~= nil and widget.valueWurfhoehe ~= 0 and widget.valueWurfhoehe ~= "0" then
                lcd.drawText(w/2, h/2-text_h, widget.valueWurfhoehe, CENTERED)
            else
                lcd.drawText(w/2, h/2-text_h, waitForStart[locale], CENTERED)
            end
        else widgetSizeType = "Default"
            lcd.font(FONT_XS)        
            lcd.drawText(lcdBorder, h-text_h-2, "Min:"..calcSteigrateMin.."m/s", LEFT)
            lcd.drawText(w-text_w-lcdBorder, h-text_h-2, "Active:"..calcSteigrateActive.."m/s", RIGHT)
            lcd.font(FONT_XL) 
            if widget.valueWurfhoehe ~= nil and widget.valueWurfhoehe ~= 0 and widget.valueWurfhoehe ~= "0" then
                lcd.drawText(w/2, h/2-text_h, widget.valueWurfhoehe, CENTERED)
            else
                lcd.drawText(w/2, h/2-text_h, waitForStart[locale], CENTERED)
            end
        end
    end   
        -- lcd.color(GREEN)
        -- lcd.font(FONT_XS)
        -- lcd.drawText(650, 100, "Debug1: "..(widget.debugValue1 or 0), LEFT)
        -- lcd.drawText(650, 110, "Debug2: "..(widget.debugValue2 or 0), LEFT)
        -- lcd.drawText(650, 120, "Debug3: "..(widget.debugValue3 or 0), LEFT)
        -- lcd.drawText(650, 130, "Debug4: "..(widget.debugValue4 or 0), LEFT)
        -- lcd.drawText(650, 140, "Debug5: "..(widget.debugValue5 or 0), LEFT)
        -- lcd.drawText(650, 150, "Debug6: "..(widget.debugValue6 or 0), LEFT)
        -- lcd.drawText(650, 160, "Debug7: "..(widget.debugValue7 or 0), LEFT) 
        -- lcd.drawText(650, 170, "MenuSW: "..(widget.debugValue8 or "0"), LEFT) 
end

local function wakeup(widget)
    local sensorFlughoehe = system.getSource({category=CATEGORY_TELEMETRY, appId=0x0100})
    local sensorSteigrate = system.getSource({category=CATEGORY_TELEMETRY, appId=0x0110})
    local valueSteigrateString = nil
    local valueFlughoheString = nil
    local redSteigRate = nil
    local multipRedSteigRate = nil
    widget.valueReset = valueReset
    -- widget.SteigrateActive = SteigrateActive
    -- widget.SteigrateMin = SteigrateMin
    -- widget.wHeightReset = wHeightReset
    -- widget.menuSw = menuSw 
    -- print("Modellname: " .. widget.modelName)

    -- Überprüfen, ob sensorSteigrate gültig ist
    valueSteigrateString = sensorSteigrate and sensorSteigrate:stringValue() or nil
    valueFlughoheString = sensorFlughoehe and sensorFlughoehe:stringValue() or nil

    -- Sicherstellen, dass valueSteigrateString gültig ist
    if valueSteigrateString and valueSteigrateString ~= "" and valueSteigrateString ~= nil then
        redSteigRate = tonumber((string.gsub(valueSteigrateString, "m/s", "")))
    else
        redSteigRate = 0 -- Standardwert, falls die Umwandlung fehlschlägt
    end

    -- Sicherstellen, dass redSteigRate nicht nil ist
    multipRedSteigRate = (redSteigRate or 0) * 100
    if sensorFlughoehe ~= nil then
        if multipRedSteigRate >= widget.SteigrateActive or start == 1 and widget.valueReset == 1 then
            start = 1  
            if multipRedSteigRate <= widget.SteigrateMin and widget.valueReset == 1 then
                widget.valueWurfhoehe = valueFlughoheString
                valueReset = 0
                start = 0
                widget.valueReset = valueReset
                highestPoint = multipRedSteigRate
                
            end
        end
    end
    -- print("ResetValue: " .. widget.wHeightReset:stringValue())
    if widget.wHeightReset ~= nil and type(widget.wHeightReset) == "userdata" and widget.wHeightReset:stringValue() ~= nil then
        
        if widget.wHeightReset:stringValue() == "100" then
            -- print("reset")
            if widget.valueWurfhoehe ~= nil then
                print("widget.valueWurfhoehe: " .. widget.valueWurfhoehe)
            else
                print("widget.valueWurfhoehe ist nil")
            end
            if widget.valueWurfhoehe ~= "0" and widget.valueWurfhoehe ~= 0 and widget.valueWurfhoehe ~= nil then 
                local filePath = widget.modelName.."-startheight.txt"
                local entries = {}

                -- Datei öffnen
                local file = io.open(filePath, "r")
                if file then
                    while true do
                        local success, line = pcall(function() return file:read("L") end) -- Liest eine Zeile
                        if not success or not line then
                            break -- Beende die Schleife, wenn ein Fehler auftritt oder das Ende der Datei erreicht ist
                        end
                        line = string.gsub(line, "\r?\n", "") -- Entfernt Zeilenumbrüche
                        if string.match(line, "%S") then -- Nur nicht-leere Zeilen hinzufügen
                            table.insert(entries, line)
                        end
                    end
                    file:close()
                else
                    print("Datei konnte nicht geöffnet werden:", filePath)
                end

                -- Debug-Ausgabe der Einträge
                if #entries == 0 then
                    print("Keine Daten vorhanden")
                else
                    for _, entry in ipairs(entries) do
                        print(entry)
                    end
                end

                -- Neuen Eintrag hinzufügen
                local timestamp = os.date("%d-%m-%Y %H:%M:%S")
                if widget.valueWurfhoehe and widget.valueWurfhoehe ~= "" then
                    local cleanedValue = string.gsub(widget.valueWurfhoehe, "m", "") -- Entfernt die Einheit "m"
                    local valueWithoutUnit = tonumber(cleanedValue) -- Konvertiert den bereinigten String in eine Zahl
                    if valueWithoutUnit then
                        local newEntry = string.format("%s - %.2f m", timestamp, valueWithoutUnit)
                        
                        -- Überprüfen, ob der Eintrag leer ist
                        if string.match(newEntry, "%S") then -- %S prüft, ob der String nicht nur aus Leerzeichen besteht
                            table.insert(entries, newEntry)
                        else
                            print("Leerer Eintrag wird nicht hinzugefügt.")
                        end
                    else
                        print("Ungültiger Wert für widget.valueWurfhoehe:", widget.valueWurfhoehe)
                    end
                else
                    print("widget.valueWurfhoehe ist nil oder leer")
                end
                -- Nur die letzten 10 Einträge behalten
                while #entries > 10 do
                    table.remove(entries, 1)
                end

                -- Datei überschreiben
                file = io.open(filePath, "w")
                if file then
                    for index, entry in ipairs(entries) do
                        if string.match(entry, "%S") then -- Überprüfen, ob die Zeile nicht leer ist
                            file:write(entry) -- Schreibe den Eintrag
                            if index < #entries then
                                file:write("\n") -- Füge nur zwischen den Einträgen einen Zeilenumbruch hinzu
                            end
                        end
                    end
                    file:close()
                else
                    print("Fehler beim Schreiben der Datei:", filePath)
                end
                widget.valueWurfhoehe = 0
                valueReset = 1
                start = 0
            end
            
        
        end
    end
    if widget.value ~= valueFlughoheString then
        widget.value = valueFlughoheString
        widget.valueReset = valueReset
        lcd.invalidate()
    end
    

    if widget.menuSw ~= nil and widget.menuSw:stringValue() ~= nil then
        if widget.menuSw:stringValue() == "100" then
            menuSWlastValue = widget.menuSw:stringValue()
            print("MenuSW lastValue 100: " .. menuSWlastValue)
        end
        if (widget.menuSw:stringValue() == "-100" or widget.menuSw:stringValue() == "0") and menuSWlastValue == "100" then
            print("MenuSW unterschied lastValue: " .. menuSWlastValue)
            if HistoryMenu == 0 then
                HistoryMenu = 1
            elseif HistoryMenu == 1 then
                HistoryMenu = 0
            end
            menuSWlastValue = widget.menuSw:stringValue()
            lcd.invalidate()
        end
    end
    



    -- -- Debug-Ausgaben
    -- widget.debugValue1 = multipRedSteigRate
    -- widget.debugValue2 = widget.SteigrateActive
    -- widget.debugValue3 = start
    -- widget.debugValue4 = widget.valueReset
    -- widget.debugValue5 = highestPoint
    -- widget.debugValue6 = widget.SteigrateMin
    -- widget.debugValue7 = widget.valueWurfhoehe



end

-- Menu Aneige bei touch Bedienung

local function menu(widget)
    return {
         {menuSwitch,
         function()
            if HistoryMenu == 0 then
                HistoryMenu = 1
            elseif HistoryMenu == 1 then
                HistoryMenu = 0
            end
         end},
         {menuL[locale],
         function()
             widget.valueWurfhoehe = 0
             valueReset = 1
             start = 0
         end}
            
    }
        --  {LastMenuL[locale],
        --  function()
        --     if HistoryMenu == 0 then
        --         HistoryMenu = 1
        --     elseif HistoryMenu == 1 then
        --         HistoryMenu = 0
        --     end
            
        --  end},
end

local function event(widget, category, value, x, y)
    print("Event received:", category, value, x, y)
    if category == EVT_KEY and value == KEY_ENTER_LONG then
        print("Board " .. system.getVersion().board .. " Version " .. system.getVersion().version)
        print("Date " .. os.date() .. " Time " .. os.time())
        lcd.invalidate()
        system.killEvent(value)
        return true
    else
        return false
    end
end


local function configure(widget)
    -- Steigraten erkennung
    lineStrgActive = form.addLine(configStgR[locale])
    local SteigrateActiveField = form.addNumberField(lineStrgActive, nil,40, 1000, function() return widget.SteigrateActive end, function(value) widget.SteigrateActive = value end)
    SteigrateActiveField:suffix("m/s")
    SteigrateActiveField:decimals(2)
    SteigrateActiveField:default(500)
    -- Steigrate höchster Punkt
    lineStrgMin = form.addLine(configStgRmin[locale])
    local SteigrateMinField = form.addNumberField(lineStrgMin, nil,40, 500, function() return widget.SteigrateMin end, function(value) widget.SteigrateMin = value end)
    SteigrateMinField:suffix("m/s")
    SteigrateMinField:decimals(2)
    SteigrateMinField:default(50)
    -- Reset Schalter
    line = form.addLine(configResetSwitch[locale])
    form.addSwitchField(line, form.getFieldSlots(line)[0], function() return widget.wHeightReset end, function(value) widget.wHeightReset = value end)
    -- Menu Schalter
    line = form.addLine(configMenuSwitch[locale])
    form.addSwitchField(line, form.getFieldSlots(line)[0], function() return widget.menuSw end, function(value) widget.menuSw = value end)
    -- History Dateiname
    lineHistoryPath = form.addLine(headHistoryPath[locale]) form.addStaticText(lineHistoryPath, nil, widget.modelName.."-startheight.txt")
    -- Version
    lineVersion = form.addLine("Script Version") form.addStaticText(lineVersion, nil, scriptVersion)
end

local function read(widget)

    widget.SteigrateActive = storage.read("A")
    widget.SteigrateMin = storage.read("B")
    widget.wHeightReset = storage.read("C") 
    widget.menuSw = storage.read("D") 
end

local function write(widget)
    storage.write("A", widget.SteigrateActive)
    storage.write("B", widget.SteigrateMin)
    storage.write("C", widget.wHeightReset)
    storage.write("D", widget.menuSw) 
end




local function init()
    system.registerWidget({key="STRT", name=name, create=create, paint=paint, event=event, menu=menu, wakeup=wakeup, configure=configure, read=read, write=write})
    valueReset = 1
    widget.valueWurfhoehe = 0
end

return {init=init}