-- title:   Make
-- author:  Jenna Martinez & Paris Kampel
-- desc:    dating sim
-- version: 0.1
-- script:  lua

--helper function for collison handler
function solid(x,y, building)
   return building[mget(((x)//8),((y)//8)+ screen)]
end

--collision handler
function map_collision()
    for i = 1, 9, 1 do
        if solid(p.x+p.vx,p.y+p.vy, buildings[i].id) or solid(p.x+7+p.vx,p.y+p.vy, buildings[i].id) or solid(p.x+p.vx,p.y+7+p.vy, buildings[i].id) or solid(p.x+7+p.vx,p.y+7+p.vy, buildings[i].id) then
            p.vx=0
            if state == "game" then
                state = "popup"
                curr_building = buildings[i].name
                curr_building_i = i
            end
        end

        if solid(p.x,p.y+8+p.vy, buildings[i].id) or solid(p.x+7,p.y+8+p.vy, buildings[i].id) then
            p.vy=0
            if state == "game" then
                state = "popup"
                curr_building = buildings[i].name
                curr_building_i = i
            end
        end

        if p.vy<0 and (solid(p.x+p.vx,p.y+p.vy, buildings[i].id) or solid(p.x+7+p.vx,p.y+p.vy, buildings[i].id)) then
            p.vy=0
            if state == "game" then
                state = "popup"
                curr_building = buildings[i].name
                curr_building_i = i
            end
        end
    end 
end

--chooses which map the player is currently on
function choose_map()
   if (p.y >= 120) and (screen == 0) then 
    p.y = p.y - 120 
    screen = 17
   elseif (screen == 17) and (p.y <= 0) then
    p.y = p.y + 120
    screen = 0
   elseif (screen == 17) and (p.y >= 120) then
    p.y = p.y - 120
    screen = 34
   elseif (screen == 34) and (p.y <= 0 ) then
    p.y = p.y + 120
    screen = 17
   end
end

--draws the building sprite
function draw_building()
    if curr_building == "Martin" then
        spr(64, 144, 0, 0, 3, 0, 0, 4, 6)
    elseif curr_building == "Singer" then
        spr(68, 144, 0, 0, 3, 0, 0, 4, 6)
    elseif (curr_building == "Kohlberg") then
        spr(72, 144, 0, 0, 3, 0, 0, 4, 6)
    elseif (curr_building == "LPAC") then
        spr(76, 144, 0, 0, 3, 0, 0, 4, 6)
    elseif (curr_building == "Sci") then
        spr(160, 144, 0, 0, 3, 0, 0, 4, 6)
    elseif (curr_building == "Lang Music") then
        spr(164, 144, 0, 0, 3, 0, 0, 4, 6)
    elseif (curr_building == "McCabe") then
        spr(168, 144, 0, 0, 3, 0, 0, 4, 6)
    elseif (curr_building == "Parrish") then
        spr(172, 144, 0, 0, 3, 0, 0, 4, 6)
    elseif (curr_building == "Narples") then
        spr(256, 144, 0, 0, 3, 0, 0, 4, 6)
    end
end

function draw_angry()
    if curr_building == "Martin" then
        spr(384, 144, 0, 0, 3, 0, 0, 4, 4)
    elseif curr_building == "Singer" then
        spr(388, 144, 0, 0, 3, 0, 0, 4, 4)
    elseif (curr_building == "Kohlberg") then
        spr(392, 144, 0, 0, 3, 0, 0, 4, 4)
    elseif (curr_building == "LPAC") then
        spr(396, 144, 0, 0, 3, 0, 0, 4, 4)
    elseif (curr_building == "Sci") then
        spr(448, 144, 0, 0, 3, 0, 0, 4, 4)
    elseif (curr_building == "Lang Music") then
        spr(452, 144, 0, 0, 3, 0, 0, 4, 4)
    elseif (curr_building == "McCabe") then
        spr(456, 144, 0, 0, 3, 0, 0, 4, 4)
    elseif (curr_building == "Parrish") then
        spr(460, 144, 0, 0, 3, 0, 0, 4, 4)
    end
end

--updates game state, including player movement and collission in the map
function update_game_state()
    choose_map()
    map(0, screen)

    if btn(2) and p.x > 0 then p.vx=-1
        elseif btn(3) and p.x < 232 then p.vx=1
        else p.vx=0
    end
    if btn(0) and p.y > 0 then p.vy=-1
        elseif btn(1) and p.y < 125 then p.vy=1
        else p.vy=0
    end
    map_collision()
    p.x=p.x+p.vx
    p.y=p.y+p.vy
    spr(5, p.x, p.y, 0)
end

--updates popup state, prompting for player input to begin conversation
function update_popup_state()
    map(0, screen)
    spr(5, p.x, p.y, 0)

    blocked = false

    if not story.ate and curr_building ~= "Narples" then
        if story.narp_phase == "breakfast" then
            print("It's breakfast time and you're hungry.", 9, 7)
        elseif story.narp_phase == "lunch" then
            print("It's lunchtime and you're hungry.", 9, 7)
        else
            print("It's dinnertime and you're hungry.", 9, 7)
        end
        print("Go to Narples.", 9, 17)
        blocked = true
    end

    if buildings[curr_building_i].today == 1 and curr_building ~= "Narples" and story.ate then
        print("You already studied with " .. curr_building .. " today!", 9, 7)
        blocked = true
    end

    if curr_building == "Narples" and story.ate then
        print("You're not hungry right now.", 9, 7)
        blocked = true
    end

    if not blocked then 
        print("Talk to " .. curr_building .. " ?", 9, 7)
    end

    if btnp(4) and (buildings[curr_building_i].today == 0 and blocked == false) then
        prev_screen = screen
        state = "talking"

        initialize_building(curr_building, curr_building_i)

        --reset typewriter
        timer = 0
        len = 0

        if curr_building == "Narples" then
            curr_diag = buildings[curr_building_i].script[story.day][story.narp_phase]
        else
            curr_diag = buildings[curr_building_i].script[buildings[curr_building_i].visits]
            --curr_diag = buildings[curr_building_i].script[1]
        end
        find_starting_message()
        load_curr_diag()
        if screen == 0 then
            screen = 51
        elseif screen == 17 then
            screen = 68
        elseif screen == 34 then
            screen = 85
        end
    elseif btnp(5) then
        state = "game"
    end
end

function find_starting_message()
    if buildings[curr_building_i].visits == 0 then 
        curr_msg = curr_diag.start
    elseif buildings[curr_building_i].points > 0 then
        curr_msg = curr_diag.positive
    elseif buildings[curr_building_i].points == 0 then
        curr_msg = curr_diag.zero
    elseif buildings[curr_building_i].points < 0 then
        curr_msg = curr_diag.negative
    end

end

--updates frienship points
function update_points()
    if curr_msg.point and updated_point then
        buildings[curr_building_i].points = buildings[curr_building_i].points + curr_msg.point
        updated_point = false
    end
end

--updates talking state by drawing building and ending conversation
function update_talking_state()
    map(0, screen)
    draw_building()

    if curr_msg.face then
        draw_angry()
    end


    update_points()
    converse()
    
    if curr_msg.choices and text_finished then --choices appear when dialouge is done
        if btnp(4) and curr_msg.choices[1] then --selecting top choice
            choice = curr_msg.choices[select_choice]
            updated_point = true
            if choice then
                curr_msg = curr_diag[choice.next]
                select_choice = 1
                load_curr_diag()
                return
            end
        end
    end

    if btnp(4) then
        if not text_finished then --skip typing
            skip_text()
            return
        end
        if next_page() then --go to next page if more pages exist
            return
        end
        if curr_msg.next then --advance dialouge
            curr_msg = curr_diag[curr_msg.next]
            if string.find(curr_msg.text, "Right now your predicted grade is: ") then
                curr_msg.text = "Right now your predicted grade is: "
                grade = calculate_grade()
                curr_msg.text = curr_msg.text ..  grade
            end
            load_curr_diag()
        else
            advance_story()
            if state ~= "calendar" and state ~= "end" then 
                state = "game" --exit dialouge
            end
            screen = prev_screen
        end
        return
    end
end

function update_calendar_state()
    cls(12)
    if story.day ~= 3 then
        print((4 - story.day) .." days until finals...", 65, 68, 1)
    else
        print("1 day until finals...", 65, 68, 1)
    end
    if btnp(4) then
        state = "game"
    end
end

--show ending screen
function update_end_state()
    cls(12)
    grade = calculate_grade()
    spr(172, 144, 0, 0, 3, 0, 0, 4, 6)
    if grade == "F" then
        spr(460, 144, 0, 0, 3, 0, 0, 4, 4)
        print("You failed.", 10, 68, 7, 0, 2)
    else 
        print("You got a:", 10, 58, 7, 0, 2)
        print(grade, 30, 70, 7, 0, 2)
    end
end

--show title screen
function update_title_state()
    cls(12)
    spr(8, 70, 30, 0, 6, 0, 0, 2, 2)
    print("Campus Cupid", 50, 68, 1, 0, 2)
    print("By Jenna Martinez and Paris Kampel", 20, 80, 1, 0, 1)
    --resemblance disclaimer
    --our names
    if btnp(4) then
        state = "disclaimer"
    end
end

function update_disclaimer_state()
    cls(12)
    print("DISCLAIMER", 57, 40, 1, 0, 2)
    print("All characters in this game are", 22, 60, 1, 0, 1)
    print("fictional. Any resemblance to real", 17, 70, 1, 0, 1)
    print("Swarthmore students or faculty", 24, 80, 1, 0, 1)
    print("is completely coincedental.", 27, 90, 1, 0, 1)
    if btnp(4) then
        state = "calendar"
    end
end

--handles conversation between player and building
function converse()
    spr(266, 0, 2, 0, 3, 0, 0, 6, 4) --text box
    typewriter()
    if curr_msg.choices and text_finished then --choices appear only when text is done typing
        draw_choices()
    end
end

--draws the player response choices
function draw_choices()
    spr(324, 0, 102, 0, 2, 0, 0, 12, 2)
    if btnp(1) then
        if select_choice < 2 then
            select_choice = select_choice + 1
        end
    end
    if btnp(0) then
        if select_choice > 1 then
            select_choice = select_choice - 1
        end
    end
    if #curr_msg.choices > 1 then
        for i = 1, #curr_msg.choices do
            if select_choice == i then
                print(curr_msg.choices[i].text, 10, 100 + i*10, 4)
            else
                print(curr_msg.choices[i].text, 10, 100 + i*10, 12)
            end
        end
    else
        print(curr_msg.choices[1].text, 10, 110, 4)
    end
end

--skips typewriter effect for text
function skip_text()
    len = total_len
    text_finished = true
end

--wraps text in dialogue box to prevent text from going outside of the box
--referenced from "A Spell of Snow"
function wrap_text(text, max_chars)
    lines = {}
    line = ""
    for word in text:gmatch("%S+") do --iterate over text by word
        if #line + #word + 1 <= max_chars then --check to see if adding word to line will fit
            if line == "" then --fist word in a line
                line = word
            else
                line = line .. " " .. word --adding word to line
            end
        else  --create new line if word doesn't fit on previous line
            lines[#lines + 1] = line
            line = word
        end
    end

    if line ~= "" then --add any leftover text
        lines[#lines + 1] = line
    end
    return lines
end

--makes text move into the next dialouge box if it overflows the current one
--breaks message into pages of 22 characters max, 10 lines max per box
function overflow_text(text, max_chars, max_lines)
    wrapped = wrap_text(text, max_chars)
    pages = {}
    curr_page = {}
    for i = 1, #wrapped do
        curr_page[#curr_page+1] = wrapped[i] --add line to current page
        if #curr_page >= max_lines then --page is full, start a new one
            pages[#pages+1] = curr_page
            curr_page = {}
        end
    end
    if #curr_page > 0 then --put leftover lines in final page
        pages[#pages + 1] = curr_page
    end
    return pages
end

--resets the typerwriter if pages overflow
function next_page()
    if text_page < #pages then
        text_page = text_page + 1
        lines = pages[text_page]
        len = 0
        timer = 0
        text_finished = false
        return true
    end
    return false
end

--creates typewriter effect for dialogue
function typewriter()
    if text_finished then --skipping typewriter, make all text appear immediately 
        for i=1, #lines do
          print(lines[i], 10, 10 + (i-1)*8)
        end
        return
    end

    timer = timer + 1
    if timer > speed then
        len = len + 1 --reveal one more character per frame
        timer = 0
    end
    remain_chars = len --characters left to print
    for i=1, #lines do
        line = lines[i]
        if remain_chars > 0 then
            --math.min from https://www.codecademy.com/resources/docs/lua/mathematical-library/min
            --indexing into string https://www.lexaloffle.com/bbs/?tid=1819
            visible = string.sub(line, 1, math.min(remain_chars, #line))
            print(visible, 10, 10 + (i-1)*8)
            remain_chars = remain_chars - (#line + 1)
        end
    end
    if len >= total_len then
        text_finished = true
    end
end

--processes text for conversation
function load_curr_diag()
    msg = curr_msg.text
    pages = overflow_text(msg, 22, 10)
    text_page = 1
    lines = pages[text_page] --load first page
    total_len = #msg
    len = 0
    timer = 0
    text_finished = false
end

-- for lazy initialization design pattern
function initialize_building(name, id)
    local tab = buildings[id].script
    if buildings[id].init == 0 then 
        if name == "McCabe" then
            init_mccabe()
            tab[0] = mccabe_day_1
            tab[1] = mccabe_day_2
            tab[2] = mccabe_day_3
        elseif name == "Parrish" then
            init_parrish()
            tab[0] = parrish_day_1
            tab[1] = parrish_day_2
            tab[2] = parrish_day_3
        elseif name == "Kohlberg" then
            init_kohl()
            tab[0] = kohl_day_1
            tab[1] = kohl_day_2
            tab[2] = kohl_day_3
        elseif name == "LPAC" then
            init_lpac()
            tab[0] = lpac_day_1
            tab[1] = lpac_day_2
            tab[2] = lpac_day_3
        elseif name == "Lang Music" then
            init_langmu()
            tab[0] = langmu_day_1
            tab[1] = langmu_day_2
            tab[2] = langmu_day_3
        elseif name == "Martin" then
            init_martin()
            tab[0] = martin_day_1
            tab[1] = martin_day_2
            tab[2] = martin_day_3
        elseif name == "Sci" then
            init_sci()
            tab[0] = sci_day_1
            tab[1] = sci_day_2
            tab[2] = sci_day_3
        elseif name == "Singer" then
            init_singer()
            tab[0] = singer_day_1
            tab[1] = singer_day_2
            tab[2] = singer_day_3
        end
        buildings[id].init = 1
    end
end

--advances the story for the next dialouge progression
function advance_story()

    --progress narples dialogue
    if curr_building == "Narples" then
        story.ate = true
        if story.narp_phase == "breakfast" then
            story.narp_phase = "lunch"
        elseif story.narp_phase == "lunch" then
            story.narp_phase = "dinner"
        end
    end

    --Track visited buildings
    if curr_building ~= "Narples" then
        buildings[curr_building_i].visits = buildings[curr_building_i].visits + 1  
        buildings[curr_building_i].today = 1
        story.visited = story.visited + 1
        story.ate = false
    end
    
    --reset day and change state to calendar
    if story.visited == 3 then
        story.day = story.day + 1
        story.narp_phase = "breakfast"
        story.visited = 0
        p.x = 120
        p.y = 68
        screen = 34
        prev_screen = screen
        for build = 1, #buildings do
            if buildings[build].today == 1 then
                buildings[build].today = 0
            end
        end
        if story.day == 4 then 
            state = "end"
        else
            state = "calendar"
        end
        --CODE THAT HAPPENS WHEN THE DAYS ADVANCE GOES HERE
    end

end

--calculates total grade based on all friendship points
function calculate_grade()
    local total_grade = 0
    for i = 1, 9, 1 do
        total_grade = total_grade + buildings[i].points
    end
    letter_grade = ""
    if total_grade >= 15 then
        letter_grade = "A"
    elseif total_grade >= 10 then
        letter_grade = "B"
    elseif total_grade >= 5 then
        letter_grade = "C"
    elseif total_grade > 0 then
        letter_grade = "D"
    else
        letter_grade = "F"
    end
    return letter_grade
end

function init_narples()
    narples_day1_breakfast = {
        start = {
            text = "Hey did you enjoy your breakfast? It's important not to skip during finals week (or ever). By the way, what do you plan on doing after this?",
            choices = {
                {
                    text = "I'm going to study.",
                    next = "study_reply"
                }
            }
        },
        study_reply = {
            text = "OMG WHERE? Will there be food?! You better come back here for lunch. It's really important to get a full three meals per day if you want to do well on your exams.",
            choices = {
                {
                    text = "Relax, I'll be back for lunch.",
                    next = "lunch_yes"
                },
                {
                    text = "I'm not sure where I'm going yet.",
                    next = "unsure"
                }
            }
        },
        lunch_yes = {
            text = "GREAT! I will make sure to make something really good! Maybe some flank steak, or some crab rangoon...",
            next = "ending"
        },
        unsure = {
            text = "Well, you have to figure that out soon. The sooner you pick a building, the sooner you can start studying, and the sooner you start studying, the sooner you can take a break for a study snack.",
            next = "ending"
        },
        ending = {
            text = "Anyways, no matter where you study now, you can always choose to study in another building after lunch. However, make sure you pick wisely. These other buildings have some attachment issues (which might impact your exam scores if you make them upset). Well, get to it! Those exams are not going to study themselves? You know what I mean. See you at lunch!"
        }
    }
    narples_day1_lunch = {
        start = {
            text = "Soooooooo, how was your post-breakfast study sesh?",
            choices = {
                {
                    text = "Pretty good.",
                    next = "honest"
                },
                {
                    text = "Kinda weird.",
                    next = "honest"
                }
            }
        },
        honest = {
            text = "Well to be honest it doesn't matter how it went because you're gonna go study again after lunch.",
            next = "still"
        },
        still = {
            text = "You still have two more places to study today, so choose wisely. Also, make sure you come back here for dinner, I'll make sure to whip up something really good."
        }
    }

    narples_day1_dinner = {
        start = {
            text = "Phew, it's been a long day.",
            choices = {
                {
                    text = "I still have more work to do.",
                    next = "rough"
                }
            }
        },
        rough = {
            text = "That's rough buddy. I guess I'll leave you to it.",
            next = "sure"
        },
        sure = {
            text = "Make sure you keep coming back for meals 3 times a day, you won't do well on your exams on an empty stomach.",
            next= "help"
        },
        help ={
            text = "Also you know what might help? When you come back for meals I'll tell you how well your studying is going.",
            next = "weirdos"
        },
        weirdos = {
            text = "Maybe that'll help you choose between all these weirdos..."
        }
    }
    narples_reg = {
        start = {
            text = "Hey, let's see how you're doing.",
            next = "grade"
        },
        grade = {
            text = "Right now your predicted grade is: "
        }
    }
end

function init_mccabe()
    mccabe_day_1 = {
        start = {
            text = "Hey.",
            next = "what"
        },
        what = {
            text = "What brings you here?",
            choices = {
                {text = "I'm here to study.",
                next = "study"}
            }
        },
        study = {
            text = "Sounds good. How are you doing?",
            choices = {
                {
                    text = "Not bad.",
                    next = "not_bad"
                },
                {
                    text = "Stressed.",
                    next = "stress"
                }
            }
        },
        not_bad = {
            text = "That's good. If your studying is going well and you have some extra time you should pick up some light reading.",
            next = "bell_jar"
        },
        stress ={
            text = "That sucks man. I find that reading always helps me destress.",
            next = "bell_jar"
        },
        bell_jar = {
            text = "If you want I could lend you my copy of The Bell Jar.",
            choices = {
                {
                    text = "I'm ok.",
                    next = "ok"
                },
                {
                    text = "Sure.",
                    next = "sure"
                }
            }
        },
        ok = {
            text = "That's ok i guess. Feminist literature isn't for everyone.",
            next = "book_recs",
            face = 0,
            point = -1
        },
        sure = {
            text = "Great. However, just ignore all the annotations in my copy. I like to mark up my books, it just makes me feel more connected to the literature.",
            next = "book_recs",
            point = 1
        },
        book_recs = {
            text = "Anyways do you have any book recs for me?",
            choices = {
                {
                    text = "I don't really read",
                    next = "dont_read"
                },
                {
                    text = "Yeah.",
                    next = "amazing"
                }
            }
        },
        dont_read = {
            text = "Maybe you should start. I guess I could draft a reading list for you, but you would need to put the work in and actually read them.",
            face = 0,
            point = -1
        },
        amazing = {
            text = "Amazing! What's your favorite genre?",
            choices = {
                {text = "I like fantasy.",
                next = "fantasy"},
                {text = "I like memoirs",
                next = "memoirs"}
            }
        },
        fantasy = {
            text = "Oh, I typically like my books to be based in the real world and in real issues. I guess we have different priorities.",
            face = 0,
            point = -1
        },
        memoirs = {
            text = "Me too. We have so much to discuss. I hope you come back again tomorrow. Maybe I'll bring my signed copy of Unraveling by Peggy Orenstein.",
            point = 1
        }
    }

    mccabe_day_2 = {
        positive = {
            text = "Hey, do you want to discuss some feminist literature with me. I'm about half way through The Second Sex and it's so engaging.",
            next = "anyways"
        },
        zero = {
            text = "Hey, have you thought about any of my book recs? I always have more if your interested.",
            next = "anyways"
        },
        negative = {
            text = "Finally willing to try reading something new? A good book can change your life.",
            next = "anyways"
        },
        anyways = {
            text = "Anyways, what brings you back here?",
            choices = {
                {text = "Studying again.",
                next = "studying"}
            }
        },
        studying = {
            text = "Makes sense. Finals can be kinda rough.",
            next = "snack"
        },
        snack = {
            text = "By the way, how about we grab a study snack? Some brain food will help spark some creativity for our final papers.",
            next = "what"
        },
        what = {
            text = "What should we get?",
            choices = {
                {
                    text = "Some matcha.",
                    next = "matcha"
                },
                {
                    text = "Some chips.",
                    next = "chips"
                }
            }
        },
        matcha = {
            text = "Great choice. A good matcha and a good book is the best combination. It really helps me think about life, you know.",
            next = "after",
            point = 1
        },
        chips = {
            text = "Not my first choice. If we have to get chips what if we get some dried fruit or some nuts to go along with them.",
            next = "after",
            face = 0,
            point = -1
        },
        after = {
            text = "Ok, after we grab our snack what are you going to study for?",
            choices = {
                {
                    text = "My linear exam.",
                    next = "linear"
                },
                {
                    text = "I'll write my english paper",
                    next = "english"
                }
            }
        },
        linear = {
            text = "I don't really think that spending so much time in math is going to help you be a better person. Maybe next semester you should add an English class to your schedule.",
            face = 0,
            point = -1
        },
        english = {
            text = "Exciting! Maybe I could proofread it for you when you're done drafting. My professors always tell me I have perfect prose.",
            point = 1
        }
    }

    mccabe_day_3 = {
        positive = {
            text = "You're back! I'm so excited to hang out with someone who loves literature as much as I do!",
            next = "again",
            point = 2
        },
        zero = {
            text = "Hey.",
            next = "again"
        },
        negative = {
            text = "You're really back here? Maybe you should go study somewhere else that's better aligned with your interests. I need to lock in on The Feminine Mystique and I don't want anyone bothering me.",
            face = 0,
            point = -2
        },
        again = {
            text = "Are you here to study for your exams again?",
            choices = {
                {
                    text = "Yeah.",
                    next = "yeah"
                },
                {
                    text = "I'm here to read.",
                    next = "read"
                }
            }
        },
        yeah = {
            text = "Great! There's a nice sunlit spot in the corner over there that I think would be great for you. Let me know if you need anything and good luck!"
        },
        read = {
            text = "Amazing! Did you bring your own book or did you want me to recommend something?",
            point = 2,
            choices = {
                {
                    text = "I brought my own.",
                    next = "own"
                },
                {
                    text = "Reccomend something.",
                    next = "rec"
                }
            }
        },
        own = {
            text = "What is it?",
            choices = {
                {
                    text = "A fantasy book.",
                    next = "ohok"
                },
                {
                    text = "A memoir.",
                    next = "wow"
                }
            }
        },
        rec = {
            text = "Ok. Maybe something by Joan Didion or Sally Rooney. There's just so much to pick from I could go on forever."
        },
        ohok = {
            text = "Oh, ok.",
            face = 0,
            point= -2
        },
        wow = {
            text = "Wow! When you're done let me know and lets talk about it. For now, I'll let you get to it.",
            point = 2
        }   
    }
end

function init_parrish()
    parrish_day_1 = {
        start = {
            text = "Hello there.",
            choices = {
                {text = "Hi",
                next = "brings"},
                {text = "Who are you?",
                next = "confidential"}
            }
        },
        confidential = {
            text = "That's confidential.",
            face = 0,
            point = -1,
            next = "brings"
        },
        brings = {
            text = "What brings you to my hall?",
            choices = {
                {text = "I'm here to study",
                next = "great"}
            }
        },
        great = {
            text = "Great! It is important that you do well on your exams. However, it is just as important that you take some time to yourself and pursue your interests",
            next = "spare"
        },
        spare = {
            text = "What do you like to do in your spare time?",
            choices = {
                {text = "I like to read",
                next = "me_too"},
                {text = "I like to paint",
                next = "interesting"}
            }
        },
        me_too = {
            text = "Ah, me too. I love to study literature, I just find the written word so fascinating.",
            next = "anyway",
            point = 1
        },
        interesting = {
            text = "Interesting.",
            face = 0,
            point = -1,
            next = "anyway"
        },
        anyway = {
            text = "Anyways, enough with your extracurricular activities, what academic ventures interest you so much that you are taking time out of your day to study them?",
            choices = {
                {text = "What?",
                next = "course"},
                {text = "Uhh.. linear algebra",
                next = "math"}
            }
        },
        course = {
            text = "What course are you studying for?",
            choices = {
                {text = "Linear Algebra",
                next = "math"}
            },
            face = 0,
            point = -1
        },
        math = {
            text = "Ah a mathematician. I wish you the best of luck in your field. However, make sure you expand your horizons and explore the humanities and social sciences as well. This is a liberal arts school after all.",
            next = "keep"
        },
        keep = {
            text = "Well I won't keep you from your studies any longer. And please feel free to come back and study here another day."
        }
    }

    parrish_day_2 = {
        positive = {
            text = "Good day Swarthmore community member.",
            choices = {
                {text = "Hi...",
                next = "back"}
            }
        },
        zero = {
            text = "Hello again",
            choices = {
                {text = "Hi...",
                next = "back"}
            }
        },
        negative = {
            text = "Hi...",
            choices = {
                {text = "Hi...",
                next = "back"}
            }
        },
        back = {
            text = "You have come back",
            choices = {
                {text = "Yeah...",
                next = "today"},
                {text = "I think I'll go now",
                next = "oh"}
            }
        },
        oh = {
            text = "I condemn your actions.",
            face = 0,
            point = -1
        },
        today = {
            text = "So what have you come here for today?",
            point = 1,
            choices = {
                {text = "I'm here to study",
                next = "amazing"}
            }
        },
        amazing = {
            text = "Amazing...",
            next = "minute"
        },
        minute = {
            text = "However, do you have a minute to assist me with something before you begin your studies?",
            choices = {
                {text = "Sure",
                next = "great"},
                {text = "No",
                next = "see"}
            }
        },
        great = {
            text = "Great! Please sort that large stack of articles over there into alphabetical order",
            point = 1,
            choices = {
                {text = "Alright.",
                next = "thanks"}
            }
        },
        thanks = {
            text = "Thank you."
        },
        see = {
            text = "I see how it is. Go study then.",
            face = 0,
            point = -1
        }
    }

    parrish_day_3 = {
        positive = {
            text = "Hello again! I am delighted to see you have come back to enrich your mind and prepare for your exams.",
            point = 2,
            choices = {
                {text = "You remind me of someone",
                next = "no"}
            }
        },
        zero = {
            text = "Hello there, I presume you have come back to study again.",
            choices = {
                {text = "You remind me of someone",
                next = "no"}
            }
        },
        negative = {
            text = "Parrish Hall is closed for renovations today. Please don't come back.",
            face = 0,
            point = -2
        },
        no = {
            text = "No I don't",
            choices = {
                {text = "yes you do",
                next = "yes"},
                {text = "I guess not",
                next = "good"}
            }
        },
        good = {
            text = "Good.",
            point = 2,
            next = "well"
        },
        yes = {
            text = "No I don't. Any resemblance is simply coincidental.",
            point = -2, 
            face = 0,
            next = "well"
        },
        well = {
            text = "Well, I shall not keep you here. I wish you the best of luck on your exams. Make me proud",
            choices = {
                {text = "Alright",
                next = "dots"}
            }
        },
        dots = {
            text = "...",
            choices = {
                {text = "...",
                next = "go"}
            }
        },
        go = {
            text = "Go study already!"
        }
    }
end

function init_kohl()
    kohl_day_1 = {
        start = {
            text = "Sup",
            choices = {
                {text = "Hi",
                next = "what"}
            }
        },
        what = {
            text = "What'cha here for?",
            choices = {
                {text = "I'm here to study",
                next = "cool"}
            }
        },
        cool = {
            text = "Cool, me too. What'cha studying?",
            choices = {
                {text = "History",
                next = "rough"},
                {text = "Chemistry",
                next = "rough"}
            }
        },
        rough = {
            text = "Sounds rough, are you stressed about it?",
            choices = {
                {text = "Yeah",
                next = "sorry"},
                {text = "No",
                next = "seems"}
            }
        },
        sorry = {
            text = "Sorry about that. You know, I could lend you the amethyst I keep in my bag. It's really helpful for stress relief",
            choices = {
                {text = "Thanks",
                next = "no_problem"},
                {text = "I'm ok",
                next = "helpful"}
            }
        },
        no_problem = {
            text = "No problem. I keep extras on me for this reason.",
            point = 1,
            choices = {
                {text = "What are you working on?",
                next = "making"}
            }
        },
        helpful = {
            text = "Ok. I was just trying to be helpful.",
            point = -1,
            face = 0,
            choices = {
                {text = "What are you working on?",
                next = "making"}
            }
        },
        seems = {
            text = "Seems like you got this figured out then",
            choices = {
                {text = "What are you working on?",
                next = "making"}
            }
        },
        making = {
            text = "I'm making some posters for events happening on campus this week.",
            choices = {
                {text = "Can I see?",
                next = "sure"}
            }
        },
        sure = {
            text = "Sure.",
            choices = {
                {text = "Looks great",
                next = "design"},
                {text = "Looks Terrible",
                next = "what_2"}
            }
        },
        design = {
            text = "Thanks. I've been told I have an eye for design. That's why I'm the social media manager for 8 different clubs on campus.",
            next = "alright",
            point = 1
        },
        what_2 = {
            text = "What! I think they look great. You just don't have an eye for design like I do.",
            next = "alright",
            point = -1,
            face = 0
        },
        alright = {
            text = "Alright I should stop yapping and actually get to work."
        }
    }

    kohl_day_2 = {
        positive = {
            text = "Hey girlie! I was hoping you would come back. The vibes in the room just get better when you walk in.",
            next = "again"
        },
        zero = {
            text = "Sup again",
            next = "again"
        },
        negative = {
            text = "Oh, you came back. . .",
            next = "again"
        },
        again = {
            text = "You here to study again?",
            choices = {
                {text = "Yeah",
                next = "cool"}
            }
        },
        cool = {
            text = "Cool",
            next = "nothing"
        },
        nothing = {
            text = ". . .",
            next = "hey"
        },
        hey = {
            text = "Hey you know what. I could really use a latte right now. Do you wanna come with me to get one?",
            choices = {
                {text = "Sure",
                next = "amazing"},
                {text = "I'm good",
                next = "myself"}
            }
        },
        amazing = {
            text = "Amazing! What do you usually get? I'm usually a chai girlie, but today just feels like a matcha day you know.",
            point = 1,
            choices = {
                {text = "Water",
                next = "healthy"},
                {text = "Chai",
                next = "twin"}
            }
        },
        myself = {
            text = "I'll just go get one by myself then..",
            point = -1,
            face = 0
        },
        healthy = {
            text = "Oh, how healthy of you. . .",
            face = 0,
            point = -1
        },
        twin = {
            text = "Twinsies!",
            point = 1,
            next = "common"
        },
        common = {
            text = "I'm excited to see what else we have in common.",
            next = "tomorrow"
        },
        tomorrow = {
            text = "Please come back again tomorrow to study with me. We can take another chai break together!"
        }
    }

    kohl_day_3 = {
        positive = {
            text = "Bestie! You're back! I'm excited to see you!",
            choices = {
                {text = "Me too!",
                next = "yippee"}
            }
        },
        yippee = {
            text = "Yippee! Ok, so how're you doing?",
            point = 2,
            choices = {
                {text = "Pretty good",
                next = "great"},
                {text = "Pretty bad",
                next = "too_bad"}
            }
        },
        zero = {
            text = "Sup, how're you doing?",
            choices = {
                {text = "Pretty good",
                next = "great"},
                {text = "Pretty bad",
                next = "too_bad"}
            }
        },
        negative = {
            text = "Uhhhh you're really back here. I don't like your aura, it's bringing negative energy into the space. Just go study somewhere else, I need to protect my peace...",
            point = -2,
            face = 0
        },
        great = {
            text = "That's great! Wanna get a sweet treat to celebrate?",
            choices = {
                {text = "Sounds fun",
                next = "knew"},
                {text = "I'm ok",
                next = "aww"}
            }
        },
        too_bad = {
            text = "Aw that's too bad. Maybe getting a sweet treat will make you feel better.",
            choices = {
                {text = "Sounds fun",
                next = "knew"},
                {text = "I'm ok",
                next = "aww"}
            }
        },
        knew = {
            text = "I knew it! We're literally the same person.",
            next = "getting",
            point = 2
        },
        aww = {
            text = "Aww. Well I'm gonna go get one anyway. See you later i guess...",
            face = 0,
            point = -2
        },
        getting = {
            text = "Sooo what are you thinking about getting. Maybe I'll get a muffin or a bag of gummy bears. There's just so much to choose from. . .",
            point = 2
        }
    }
end

function init_lpac()
    lpac_day_1 = {
        start = {
            text = "Hi! What are you doing here?",
            choices = {
                {text = "I'm here to study.",
                next = "really"}
            }
        },
        really = {
            text = "Really? In the Performing Arts Building?",
            next = "thought"
        },
        thought = {
            text = "I thought you were here to see a show or something. You know I'll be performing in all of the upcoming events here. Are you gonna come see any of them?",
            choices = {
                {text = "Yeah.",
                next = "yay"},
                {text = "No",
                next = "aww"}
            }
        },
        yay = {
            text = "Yay. I'm so excited.",
            next = "anyway",
            point = 1
        },
        aww = {
            text = "Aww, why not? It's good for you to take a study break and go experience the theatre.",
            next = "anyway",
            face = 0,
            point = -1
        },
        anyway = {
            text = "Anyway, I know you're studying but what are you even studying for?",
            choices = {
                {text = "My music theory exam",
                next = "theory"},
                {text = "My linear exam",
                next = "linear"}
            }
        },
        theory = {
            text = "I don't really know that much about music theory, but I heard that listening to music when you study can help. It doesn't really help me that much though. I'll try listening to music and then I just end up choreographing random stuff in my head rather than actually paying attention to my work.",
            next = "also"
        },
        linear = {
            text = "Oh, I took that class for one of my stem requirements, but I've been done with those for a while. Most of my schedule now is theatre and dance classes.",
            next = "also"
        },
        also = {
            text = "Also, I'm not really used to studying for my exams. Actually last semester one of my finals was a 15 minute improv performance where I did an interpretive dance as a plastic bag.",
            next = "also2"
        },
        also2 = {
            text = "I got an A in that class",
            choices = {
                {text = "Impressive",
                next = "thanks"
                },
                {text = "What?",
                next = "ok"}
            }
        },
        thanks = {
            text = "Thanks! You can see some of that impressive acting if you come back someday and see a show that I'm in.",
            next = "studying",
            point = 1
        },
        studying = {
            text = "Anyways, I'll leave you to your studying right now. Hopefully I'll see you again soon!"
        },
        ok = {
            text = "It's ok. Some people just don't see talent when it's right in front of them. Maybe you should come back and see one of my shows. Then you might be able to understand what true talent is",
            face = 0,
            point = -1
        }
    }

    lpac_day_2 = {
        positive = {
            text = "Hey! Welcome back! I'm excited to see you here!",
            next = "again"
        },
        zero = {
            text = "Hey!",
            next = "again"
        },
        negative = {
            text = "Hi, you're back. I'm surprised",
            next = "again"
        },
        again = {
            text = "Are you here to study again?",
            choices = {
                {text = "Yeah",
                next = "too_bad"}
            }
        },
        too_bad = {
            text = "Too bad, I really hoped you were here to see a show or take a class. Oh well maybe next time.",
            choices = {
                {text = "Maybe",
                next = "think"},
                {text = "I'm good",
                next = "aww"}
            }
        },
        think = {
            text = "You really should think about it. It might help get your creative juices flowing for finals season",
            next = "chat",
            point = 1
        },
        aww = {
            text = "Aww. It could be fun.",
            next = "chat",
            face = 0,
            point = -1
        },
        chat = {
            text = "Well do you want to chat a little before you start studying",
            choices = {
                {text = "No.",
                next = "well"},
                {text = "Yes",
                next = "cool"}
            }
        },
        well = {
            text = "Oh well. Have fun studying I guess.",
            face = 0, 
            point = -1
        },
        cool = {
            text = "Cool. I want to know a little more about you and scope out the vibes you know.",
            point = 1,
            next = "interested"
        },
        interested = {
            text = "Would you be interested in auditioning for one of the shows coming up? I think you'd do great",
            choices = {
                {text = "I'm interested",
                next = "great"},
                {text = "I'm not interested",
                next = "oh"}
            }
        },
        great = {
            text = "Great I'll send you the audition info when it comes out. Well, I'll leave you to it now.",
            point = 1
        },
        oh = {
            text = "Oh, that's ok. Have fun studying I guess.",
            point = -1,
            face = 0
        },
    }

    lpac_day_3 = {
        positive = {
            text = "Heyy!! You're back! Finally considering participating in the arts? I know you would be great!",
            choices = {
                {text = "Yeah",
                next = "amazing"}
            }
        },
        amazing = {
            text = "AMAZING! We always love getting new performers!",
            point = 2,
            next = "so"
        },
        zero = {
            text = "Hi! Nice to see you again",
            next = "so"
        },
        negative = {
            text = "Oh. Sorry but the study areas are closed today and are being used as a reception space after my performance. You could come to that but I don't really know if it's your vibe. Maybe you should just go somewhere else",
            face = 0,
            point = -2
        },
        so = {
            text = "Sooooo, regardless of why you're here today. You're gonna study right?",
            choices = {
                {text = "Yeah",
                next = "omg"}
            }
        },
        omg = {
            text = "OMG I know you so well. I mean I guess I have seen you here a couple times so it's not that far of a jump to assume that you're going to study again. How long have you been studying for so far?",
            choices = {
                {text = "A long time",
                next = "breaks"},
                {text = "Not that long",
                next = "early"}
            }
        },
        breaks = {
            text = "Well you really should take a study break then, are you down?",
            choices = {
                {text = "Sure",
                next = "great"},
                {text = "I'm ok",
                next = "oh"}
            }
        },
        early = {
            text = "It's never too early to take a study break though why don't you take one now?",
            choices = {
                {text = "Sure",
                next = "great"},
                {text = "I'm ok",
                next = "oh"}
            }
        },
        great = {
            text = "Great! I know some amazing exercises we can do! What if we do some wall handstands or we could do some sight specific improv, there's just so many possibilities. . .",
            point = 2
        },
        oh = {
            text = "Oh, I guess I'll just dance by myself. . .",
            point = -2,
            face = 0
        }
    }
end

function init_langmu()
    langmu_day_1 = {
        start = {
            text = "...",
            choices = {
                {text = "...",
                next = "start"
                },
                {
                    text = "um.. hello.",
                    next = "hello"
                }
            },  
        },
        hello = {
            text = "Can't you see I'm busy?",
            choices = {
                {
                    text = "Doesn't look like it.",
                    next = "doing_anything"
                },
                {
                    text = "Doing what?",
                    next = "what"
                }
            }
        },
        what = {
            text = "Some light analysis of classical music. But I wouldn't expect someone like you to know anything about that.",
            choices = {
                {text = "uh, i guess not.",
                next = "guess_not"},
                {text = "I know about classical music.",
                next = "classical"}
            }
        },
        doing_anything = {
            text = "UM ACTUALLY I'm doing a full analysis of Paganini's 24 Caprices in my head, but you wouldn't even know what that is would you?",
            choices = {
                {text = "uh, i guess not.",
                next = "guess_not"},
                {text = "I know about classical music.",
                next = "classical"}
            },
            face = 0,
            point = -1
        },
        guess_not = {
            text= "Exactly, it takes a very particular set of skills to truly understand the beauty of music's early Romantic period and to understand the splendor that a full orchestra can bring to a room. Modern music just does not compare.",
            next = "anyways"
        },
        classical = {
            text = "Oh really. It's rare for me to find someone with such complex interests as me. Maybe we should spend some time together and discuss the lost art of the harpsichord.",
            next = "anyways",
            point = 1
        },
        anyways = {
            text = "Anyways, why have you come to disturb me?",
            choices = {
                {text = "I need to study for my finals",
                next = "study"}
            }
        },
        study = {
            text = "Oh, well in that case I guess you could study here. How do you feel about some serene study music? I was meaning to practice oboe anyway and it would be nice to play for someone rather than by myself.",
            choices = {
                {
                    text = "Sure.",
                    next = "sure"
                },
                {
                    text = "I'd rather study in silence",
                    next = "silence"
                }
            }
        },
        sure = {
            text = "Prepare to be entranced by Mozart's Oboe Concerto in C Major",
            point = 1
        },
        silence = {
            text = "Well I guess not everyone has an ear for excellence...",
            point = -1,
            face = 0
        }
    }

    langmu_day_2 = {
        positive = {
            text = "Are you here to discuss the wonders of classical music and the genius of Tchaikovsky?",
            choices = {
                {text = "I'm here to study again",
                next = "may"
                }
            }
        },
        zero = {
            text = "Were you so entranced by my genius last time that you have come to give classical music a chance?",
            choices = {
                {text = "I'm here to study again",
                next = "may"
                }
            }
        },
        negative = {
            text = "Why are you here? Someone like you with such common taste in music shouldn't step foot in these halls.",
            choices = {
                {text = "I'm here to study again",
                next = "may"
                }
            } 
        },
        may = {
            text = "May I ask what you are studying for?",
            choices = {
                {text = "My music theory exam",
                next = "theory"
                },
                {text = "My algorithms exam",
                next = "algo"
                }
            }
        },
        theory = {
            text = "Well I got an A+ in that class so if you have any questions on counterpoint please feel free to ask.",
            next = "interest",
            point = 1
        },
        algo = {
            text = "Hmmm. Doesn't seem like a class worth studying for.",
            next = "interest",
            face = 0,
            point = -1
        },
        interest = {
            text = "So, can I interest you again in some study music. I have a new viola composition I've been dying to play for someone.",
            choices = {
                {text = "No.",
                next = "deserve"
                },
                {text = "Yeah",
                next = "wonderful"
                }
            }
        },
        deserve = {
            text = "Well I didn't actually want to play for you anyway. You don't deserve to hear such magnificence",
            face = 0,
            point = -1
        },
        wonderful = {
            text = "Wonderful! Sit back, relax, and enjoy my magnum opus",
            next = "screeches",
            point = 1
        },
        screeches = {
            text = "*Screeches out some viola notes*",
            next = "think"
        },
        think = {
            text = "So, what did you think",
            choices = {
                {text = "It was interesting",
                next = "thanks"},
                {text = "It was bad",
                next = "ear"}
            }
        },
        thanks = {
            point = 1,
            text = "Thank You! Please come back again tomorrow. I'll make some revisions to my piece and play it again so that you can hear it in its truest form."
        },
        ear = {
            text = "I knew you didn't have a good ear for music",
            point = -1,
            face = 0
        }
    }

    langmu_day_3 = {
        positive = {
            text = "Welcome back. Did you want to pick up and play my spare harp, we can play Marcel Grandjany's Eleanor and Marcia Duet together.",
            choices = {
                {text = "Of course",
                next = "perfect"}
            }
        },
        zero = {
            text = "...",
            choices = {
                {text = "...",
                next = "zero"},
                {text = "Analyzing music again?",
                next = "yes"}
            }
        },
        negative = {
            text = "Why have you come back?",
            choices = {
                {text = "To study",
                next = "somewhere"}
            }
        },
        somewhere = {
            text = "Well go study somewhere else, you have shown that you don't appreciate the artistry being produced in these halls to even step foot into this building.",
            face = 0,
            point = 2
        },
        yes = {
            text = "Yes, how did you know? I'm thinking about the excellent use of counterpoint in Rachmaninoff's Piano Concerto No. 2 in C minor",
            next = "anyways"
        },
        perfect = {
            text = "Perfect, give me a minute and I'll get us set up",
            next = "anyways",
            point = 2
        },
        anyways = {
            text = "Anyways, how is your finals studying going?",
            choices = {
                {text = "Pretty good",
                next = "time"},
                {text = "Pretty weird",
                next = "bad"}
            }
        },
        time = {
            text = "That's probably because you've been spending time with me. I've been told that my excellence rubs off onto others.",
            next = "help",
            point = 2
        },
        bad = {
            text = "That's too bad. I'm sure that spending some time with me will help fix that.",
            next = "help"
        },
        help = {
            text = "Well, to help with your exams I'll make this offer one last time.",
            next = "music"
        },
        music = {
            text = "Did you want some study music?",
            choices = {
                {text = "Yes",
                next = "excellent"},
                {text = "No",
                next = "go"}
            }
        },
        excellent = {
            text = "Excellent. I shall serenade you towards success",
            point = 2
        },
        go = {
            text = "Well go study somewhere else then. Your reluctance to appreciate the artistry being produced in these halls shows you are not worthy of even stepping foot into this building.",
            point = -2,
            face = 0
        }

    }
end

function init_martin()
    martin_day_1 = {
        start = {
            text = "Uhhh hi...",
            choices = {
                {
                    text = "Hello",
                    next = "wait"
                },
                {
                    text ="...",
                    next = "dots"
                }
            }
        },
        wait = {
            text = "Hi. Wait I already said that didn't I?",
            next = "sorry"
        },
        dots = {
            text = "...",
            next = "sorry"
        },
        sorry = {
            text = "Sorry I'm probably in your way. You want to sit here right? Give me a second and I can move.",
            choices = {
                {
                    text = "No, it's ok.",
                    next = "ok"
                },
                {
                    text = "Please move.",
                    next = "move"
                }
            }
        },
        ok = {
            text = "Great, we can study together. Wait, I'm studying for my exams but I never asked you what you were doing. I just assumed you were studying because I'm studying and why else would you be here during reading week if",
            point = 1,
            next = "ifnot"
        },
        ifnot = {
            text = " not to study and oh no, I'm rambling again I'm sorry and...",
            choices = {
                {
                    text = "I'm studying for my exams",
                    next = "phew"
                }
            }
        },
        move = {
            text = "Ok please just give me one more second. Bye.",
            face = 0,
            point = -1
        },
        phew = {
            text = "Phew I got it right. What are you studying for?",
            choices = {
                {
                    text = "I'm studying for algorithms.",
                    next = "algos"
                },
                {
                    text = "I'm studying for music theory.",
                    next = "music"
                }
            }
        },
        algos = {
            text = "OMG, I took that class! I didn't do that well though so I don't know if I could help you that much.",
            point = 1,
            next = "distract"
        },
        music = {
            text = "Oh, I don't really know that much about music theory, but I hope you do really well.",
            next = "distract"
        },
        distract = {
            text = "I don't really wanna distract you any more. Sorry for taking up your time. Good luck with your studying!"
        }
    }

    martin_day_2 = {
        positive = {
            text = "YOU'RE BACK! Oops sorry, I meant you're back.",
            next = "sooo"
        },
        zero = {
            text = "Uhhhh, hi again.",
            next = "sooo"
        },
        negative = {
            text = "You came back, sorry I'm just surprised",
            next = "sooo"
        },
        sooo = {
            text = "Soooooo why are you here this time?",
            choices = {
                {
                    text = "I'm here to study.",
                    next = "again"
                }
            }
        },
        again = {
            text = "Again? Well I guess it is reading week which happens right before finals happen and you need to study for your finals and you need to start kind of early so you have enough time to really know all the material and to get",
            next = "get"
        },
        get = {
            text = "your papers and projects done if you have any and...",
            choices = {
                {
                    text = "You're rambling again.",
                    next = "rambling"
                },
                {
                    text = "...",
                    next = "moredots"
                }
            }
        },
        rambling = {
            text = "Ooops. I'll try not to do that again",
            face = 0,
            point = -1,
            next = "together"
        },
        moredots = {
            text = "Those kinds of things take a lot of time too, especially if you have to do research or if you're working with a group and then you need to find time to meet with them and that takes up even more of your time so yeah it really makes sense that you're here to study right now.",
            next = "together"
        },
        together = {
            text = "Do you want to study together?",
            choices = {
                {
                    text = "Yes.",
                    next = "yes"
                },
                {
                    text = "No.",
                    next = "no"
                }
            }
        },
        yes = {
            text = "Yay. I'll make sure to stay quiet.",
            point = 1,
            next = "dotsthree"
        },
        no = {
            text = "Oh, well that's ok. I'll just go move over there then.",
            face = 0,
            point = -1
        },
        dotsthree = {
            text = "...",
            next = "talk"
        },
        talk= {
            text = "Actually, do you think there's something we could talk about real quick...?"
        }
    }

    martin_day_3 = {
        positive = {
            text = "HEY! How are you doing? I'm so excited you're back. Are you here to study again?",
            point = 2,
            choices = {
                {text = "Yeah",
                next = "mind"}
            }
        },
        zero = {
            text = "Uhh hi, are you here to study again",
            choices = {
                {text = "Yeah",
                next = "mind"}
            }
        },
        negative = {
            text = "Ummm you came back? I thought you had a bad time here last time. Maybe it's better if you go, I'm kinda busy right now and I don't know if there's space for you to study here.",
            face = 0,
            point = -2
        },
        mind = {
            text = "Do you mind if we chat a little before we study together?",
            choices = {
                {text = "Sounds good",
                next = "yay"},
                {text = "I'm ok",
                next = "oh"}
            }
        },
        oh = {
            text = "Oh, ok. I guess we can just sit here quietly and study then",
            face = 0,
            point = -2
        },
        yay = {
            text = "Yay! I don't even really know what to talk about I just think its fun to talk and get everything out before we sit here quietly for a while and study such boring material. Actually its not thattt boring, like I chose to be in these classes and everything I just don't want to be all stressed for my exams, like why can't my professors just trust that I know the material and not give us an exam.",
            next = "feel",
            point = 2
        },
        feel = {
            text = "How do you feel about your exams?",
            choices = {
                {text = "Stressed",
                next = "me_too"},
                {text = "Pretty good",
                next = "great"}
            }
        },
        me_too = {
            text = "Mee too. And I don't know about you but I tend to talk a lot when I'm stressed, so I don't know if you can tell but I'm definitely feeling the pressure of finals right now. Maybe I'll feel less stressed if I actually start studying. Studying is so boring though, but I guess with you here it won't be that bad.",
            next = "yap"
        },
        great = {
            text = "That's great. I'm a little stressed about mine. Maybe if we study here together some of your confident and smart energy will transfer to me and then I'll do really well on my exams.",
            next = "yap"
        },
        yap = {
            text = "Ok, I'm done yapping and I'm ready to lock in. We got this!"
        }
    }
end

function init_sci()
    sci_day_1 = {
        start = {
            text = "Um you weren't planning on sitting there were you?",
            choices = {
                {
                    text = "I was.",
                    next = "was"
                },
                {
                    text = "I wasn't.",
                    next = "wasnt"
                }
            }
        },
        was = {
            text = "Oh, well are you sure about that? You can go sit somewhere else. I need to study for my chem exam here.",
            face = 0,
            point = -1,
            choices = {
                {
                    text = "I'm studying too",
                    next = "too"
                }
            }
        },
        wasnt = {
            text = "Oh good. You can go sit over there. I'm going to study for my chem exam here.",
            point = 1,
            choices = {
                {
                    text = "I'm studying too",
                    next = "too"
                }
            }
        },
        too = {
            text = "Well I'm sure whatever you're studying isn't as hard as my chem exam. I'm so cooked if I can't memorize these amino acids.",
            choices = {
                {
                    text = "I'm studying chem too.",
                    next = "chem"
                },
                {
                    text = "I'm studying history",
                    next = "history"
                }
            }
        },
        chem = {
            text = "Oh, what chem are you in? I'm in advanced biochemistry right now, it's really chopped bro dude I'm cooked. Literally nothing is harder than this.",
            point = 1,
            choices = {
                {
                    text = "I'm in that class too.",
                    next = "class_too"
                },
                {
                    text = "Intro chem.",
                    next = "intro"
                }
            }
        },
        history = {
            text = "Social slop-  I mean like sure I guess. Do you even need to study for that?",
            point = -1,
            face = 0,
            choices = {
                {
                    text = "I actually need to study",
                    next = "actually"
                }
            }
        },
        class_too = {
            text = "Oh.. What'd you get on test 2?",
            choices = {
                {
                    text = "I did well.",
                    next = "well"
                },
                {
                    text = "I'm not telling you.",
                    next = "telling"
                }
            }
        },
        intro = {
            text = "Dude that's so easy do you even need to study for that?",
            choices = {
                {
                    text = "I actually need to study",
                    next = "actually"
                }
            }
        },
        well = {
            text = "Uhhh me too yeah. So if you're doing fine, like I totally am, do you even need to study?",
            face = 0,
            point = -1,
            choices = {
                {
                    text = "I actually need to study",
                    next = "actually"
                }
            }
        },
        telling = {
            text = "Like everyone did bad on that test. We're all cooked anyway so do you even need to study?",
            choices = {
                {
                    text = "I actually need to study",
                    next = "actually"
                }
            }    
        },
        actually = {
            text = "Me too I need to lock in bro. So if you're not gonna move and I'm not gonna move I guess we'll just sit here together.",
            next = "noise"
        },
        noise = {
            text = "Just don't talk or anything, I can't lock in with any noise."
        }
    }

    sci_day_2 = {
        positive = {
            text = "Hey you're back bro! Did you want me to tutor you before your exam? I'm a pretty good chem tutor. None of my tutees have ever gotten below a 30 on their exams.",
            choices = {
                {
                    text = "I'm here to study.",
                    next = "study"
                }
            }
        },
        zero = {
            text = "Hey. What are you doing here?",
            choices = {
                {
                    text = "I'm here to study.",
                    next = "study"
                }
            }
        },
        negative = {
            text = "Why are you back here? Shouldn't you be at the library goofing off or something. You shouldn't be here unless you actually have something to study for.",
            choices = {
                {
                    text = "I'm here to study.",
                    next = "study"
                }
            }
        },
        study = {
            text = "Before you start can you quiz me on my Anki set? I'm cooked if I don't have this stuff memorized.",
            choices = {
                {
                    text = "No, i need to study.",
                    next = "no"
                },
                {
                    text = "Sure.",
                    next = "sure"
                }
            }
        },
        no = {
            text = "Ok fine bro. I'll just do it myself.",
            face = 0,
            point = -1,
            next = "pka"
        },
        sure = {
            text = "Great! Ask me the first question",
            point = 1,
            next = "pka"
        },
        pka = {
            text = "The pKa of histidine is 6.07!",
            choices = {
                {
                    text = "...",
                    next = "dots"
                },
                {
                    text = "Can you please be quiet?",
                    next = "quiet"
                }
            }
        },
        dots = {
            text = "The pKa of arginine is 11.54..."
        },
        quiet = {
            text = "Fine bro. But if I get a bad grade on this exam I'm blaming it on you.",
            face = 0,
            point = -1
        }
    }

    sci_day_3 = {
        positive = {
            text = "What's up bro? Turns out I might not be cooked after all cuz my professor just sent out an email saying he's gonna curve my chem exam",
            choices = {
                {
                    text = "That's great.",
                    next = "know"
                }
            }
        },
        zero = {
            text = "Hey bro. How have your exams been going?",
            choices= {
                {
                    text = "Pretty good.",
                    next = "good"
                },
                {
                    text = "Pretty bad.",
                    next = "bad"
                }
            }
        },
        negative = {
            text = "You're really back here again? You're not locked in enough to even be here. Just go somewhere else already, I cant get through all 1000 of my Anki cards if you're here.",
            fact = 0,
            point = -2
        },
        know = {
            text = "I know, it means I can spend more time also studying for my physics exam. By the way, how are your exams going?",
            point = 2,
            choices= {
                {
                    text = "Pretty good.",
                    next = "good"
                },
                {
                    text = "Pretty bad.",
                    next = "bad"
                }
            }
        },
        good = {
            text = "That's great man. I still need to study for like 1,000,000 hours. Are you gonna sit here and study?",
            choices = {
                {
                    text = "Yeah.",
                    next = "yeah"
                },
                {
                    text = "Nah.",
                    next = "nah"
                }
            }
        },
        bad = {
            text = "Me too bro. Anyways, are you gonna sit here and study?",
            choices = {
                {
                    text = "Yeah.",
                    next = "yeah"
                },
                {
                    text = "Nah.",
                    next = "nah"
                }
            }
        },
        yeah = {
            text = "Great, we can lock in together.",
            point = 2,
            next = "snack"
        },
        nah = {
            text = "Well I wanted to study by myself anyway.",
            face = 0,
            point = -2
        },
        snack = {
            text = "Actually before we lock in do you want to grab a snack?",
            choices = {
                {
                    text = "Yeah, sure.",
                    next = "yeahsure"
                },
                {
                    text = "I'm good.",
                    next = "imgood"
                }
            }
        },
        yeahsure = {
            text = "Lit, let's go. I think I'll get a diet coke. Did you know that they ran a study on mice where they gave them 1000 times their body weight in diet coke...",
            point = 2
        },
        imgood = {
            text = "Oh ok, I'll just go get something by myself then.",
            face = 0,
            point = -2
        }
    }
end


function init_singer()
    singer_day_1 = {
        start = {
            text = "Oh Hi. Please just give me a moment",
            next = "nothing"
        },
        nothing = {
            text = "...",
            next = "done"
        },
        done = {
            text = "And done. Ok sorry you have my attention now, I was just finishing up my applications for summer internships for summer 2030.",
            next = "what"
        },
        what = {
            text = "So, what are you here for?",
            choices = {
                {text = "I'm here to study",
                next = "of_course"}
            }
        },
        of_course = {
            text = "Of course. It is reading week after all. How's your studying going?",
            choices = {
                {text = "Pretty well",
                next = "great"},
                {text = "Not great",
                next = "too_bad"}
            }
        },
        great = {
            text = "Sounds great. Maybe you could share some of your study tips with me, I'm always looking for new ways to improve.",
            choices = {
                {text = "Sure",
                next = "sounds"},
                {text = "No",
                next = "oh_well"}
            }
        },
        sounds = {
            text = "Sounds Great!",
            point = 1,
            next = "sit"
        },
        oh_well = {
            text = "Oh, well I guess I'll just stick to my methods",
            face = 0,
            point = -1,
            next = "sit"
        },
        too_bad = {
            text = "Aw that's too bad. If you want I can send you a spreadsheet full of academic resources to help you with your exam",
            choices = {
                {text = "Thank you!",
                next = "email"},
                {text = "I'm ok",
                next = "figured"}
            }
        },
        figured = {
            text = "Oh, I guess you have everything figured out then",
            face = 0,
            point = -1,
            next = "sit"
        },
        email = {
            text = "Great I'll email you right now",
            point = 1,
            next = "sit"
        },
        sit = {
            text = "Well, sit down. Get comfortable, but not too comfortable, and hit the books.",
            next = "wait"
        },
        wait = {
            text = "Wait, before you start do you have an extra usb-c cable? Mine is being used right now in my research lab.",
            choices = {
                {text = "Yeah",
                next = "thanks"},
                {text = "No",
                next = "prepared"}
            }
        },
        thanks = {
            text = "Thank you so much. I'll be sure to repay the favor someday",
            point = 1
        },
        prepared = {
            text = "That's ok, I'll be more prepared next time"
        }
    }

    singer_day_2 = {
        positive = {
            text = "Hi. It's so nice to see you again. Please just wait like one second while I finish this email.",
            next = "nothing"
        },
        zero = {
            text = "Hi, I'll be free to talk to you in one second",
            next = "nothing"
        },
        negative = {
            text = "Sorry, give me a second I'm just finishing an email.",
            next = "nothing"
        },
        nothing = {
            text = "...",
            choices = {
                {text = "Sorry if I'm in your way",
                next = "no_problem"}
            }
        },
        no_problem = {
            text = "No problem, I love talking to people, I just have a lot going on right now. But please, sit down and study with me.",
            choices = {
                {text = "Ok",
                next = "great"},
                {text = "I'll move",
                next = "own"}
            }
        },
        own = {
            text = "Oh, well good luck studying on your own. . .",
            point = -1,
            face = 0
        },
        great = {
            text = "Great! I usually find it helpful to study with other people. It helps me stay focused.",
            point = 1,
            next = "exams"
        },
        exams = {
            text = "Sooo, how many exams are you studying for?",
            choices = {
                {text = "Just one",
                next = "good"},
                {text = "A lot",
                next = "too"}
            }
        },
        good = {
            text = "That's good, but one test can still be intimidating. Like, when I was studying for the MCAT I was so stressed even though it's just one test. You got this though.",
            choices = {
                {text = "Thanks I guess",
                next = "lock_in"},
                {text = "Uhhhh",
                next = "sorry"}
            }
        },
        too = {
            text ="Me too. I have so many exams to study for I'm kinda scared. But it's ok, we got this! Studying will be so much easier with you by my side.",
            choices = {
                {text = "Thanks I guess",
                next = "lock_in"},
                {text = "Uhhhh",
                next = "sorry"}
            }
        },
        lock_in = {
            text = "Ok, lets lock in!",
            point = 1
        },
        sorry = {
            text = "Sorry, I was just trying to make you feel better...",
            face = 0,
            point = -1
        },
    }

    singer_day_3 = {
        positive = {
            text = "Hey study buddy! I just got my med school acceptance so I'm finally free for a little bit. Do you want to hang out if you have a second?",
            choices = {
                {text = "Congrats!",
                next = "thanks"}
            }
        },
        thanks = {
            text = "Thank you! I'm so excited to go. Maybe I should take on some extra courses next semester to help prepare me for the med school work load.",
            point = 2,
            choices = {
                {text = "You're locked in",
                next = "know"},
                {text = "You're stupid",
                next = "mean"}
            }
        },
        zero = {
            text = "Hi there. Please give me a sec, I just got my second med school acceptance and now I need to choose between Harvard and Stanford.",
            choices = {
                {text = "You're locked in",
                next = "know"},
                {text = "You're stupid",
                next = "mean"}
            }
        },
        negative = {
            text = "Oh, I'm surprised you're back here. You seemed like you didn't want to study with me. Well, I'm kinda busy right now so maybe it's better if you go somewhere else.",
            face = 0,
            point = -2
        },
        know = {
            text = "I know I could always be trying harder. You seem to be doing pretty well though, and good things happen to me when I'm around you. We should totally study together more often!",
            choices = {
                {text = "Sounds great!",
                next = "yay"},
                {text = "I'm good",
                next = "oh"}
            },
            point = 2
        },
        mean = {
            text = "What? That's kind of a mean thing to say.",
            point = -2,
            face = 0
        },
        yay = {
            text = "Yay! Well lets look at what you brought to study today...",
            point = 2
        },
        oh = {
            text = "Oh, I thought you wanted to spend time with me. I guess not. Good luck with your finals I guess...",
            face = 0,
            point = -2
        }
    }
end

function init()
    --STORY PROGRESSION
    story = {
        day = 1,
        visited = 0,
        narp_phase = "breakfast",
        ate = false
        --lunch
        --dinner
    }

    --DIALOGUE GLOBALS
    curr_diag = nil
    curr_msg = nil
    text_finished = false
    select_choice = 1

    --BUILDING GLOBALS
    parrish = {[22]=true}
    narples = {[37]= true}
    mccabe = {[38] = true}
    kohl = {[0] = true}
    lpac = {[34] = true}
    langmu = {[23] = true}
    martin = {[35] = true}
    singer = {[21] = true}
    sci = {[7] = true}

    buildings = {
        {name = "Narples", id = narples, init = 0, points = 0, visits = 0, today = 0,
        script = {
                [1] = {
                    breakfast = narples_day1_breakfast, points = 0,
                    lunch = narples_day1_lunch,
                    dinner = narples_day1_dinner
                },
                [2] = {
                    breakfast = narples_reg, points = 0,
                    lunch = narples_reg,
                    dinner = narples_reg
                },
                [3] = {
                    breakfast = narples_reg, points= 0,
                    lunch = narples_reg,
                    dinner = narples_reg
                }
                    
            }
        }, 

        {name = "Parrish", id = parrish, init = 0, points = 0, visits = 0, today = 0,
        script = {}
        },       
        
        {name = "McCabe", id = mccabe, init = 0, points = 0, visits = 0, today = 0,
        script = {}
        },
        
        {name = "Kohlberg", id = kohl, init = 0, points = 0, visits = 0, today = 0,
        script = {}
        },
        
        {name = "LPAC", id = lpac, init = 0, points = 0, visits = 0, today = 0,
        script = {}
        },
        
        {name = "Lang Music", id = langmu, points = 0, init = 0, visits = 0, today = 0,
        script = {}
        },
        
        {name = "Martin", id = martin, init = 0, points = 0, visits = 0, today = 0,
        script = {}
        },
        
        {name = "Singer", id = singer, init = 0, points = 0, visits = 0, today = 0,
        script = {}
        },
        
        {name = "Sci", id = sci, init = 0, points = 0, visits = 0, today = 0,
        script = {}
        }
    }

    curr_building = ""
    curr_building_i = -1
    
    --PLAYER GLOBALS
    p={
    x=120,
    y=68,
    vx=0, --Velocity X
    vy=0, --Velocity Y
    }

    --SCREEN GLOBALS
    screen = 34
    prev_screen = screen

    --TEXT WRITING GLOBALS
    timer = 0 
    speed = 2 
    len = 0 --how many characters are shown per line
    text_page = 1 --page of wrapped text
    pages = {}
    lines = {}
    total_len = 0

    --POINT TRACKING GLOBALS
    updated_point = true

    --GAME STATE
    state = "title" 
end

init_narples()
init()

function TIC()

    cls()

    if state == "game" then --game state, movement in map
        update_game_state()
    elseif state == "popup" then --popup state, player is being prompted
        update_popup_state()
    elseif state == "talking" then --talking state, player is in conversation
        update_talking_state()
    elseif state == "calendar" then 
        update_calendar_state()
    elseif state == "title" then
        update_title_state()
    elseif state == "end" then
        update_end_state()
    elseif state == "disclaimer" then
        update_disclaimer_state()
    end

end
-- <TILES>
-- 001:666666666677776667744776674cc476674cc476677447766677776666666666
-- 002:ddddddddddeeeedddeeddeeddedccdeddedccdeddeeddeedddeeeedddddddddd
-- 003:666666666666a666666a666666a6666666a666a666a66a6666666a6666666a66
-- 004:ddddddddddddeddddddeddddddedddddddedddedddeddedddddddedddddddedd
-- 005:0244442024444442499499944cf44fc474444447444444f4244fcc4202444420
-- 006:eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee
-- 007:9999999999999999999999999999999999999999999999999999999999999999
-- 008:ccc777ccc777777cc77777777777777777777777777777777777777777777777
-- 009:cc777cccc777777c7777777c7777777777777777777777777777777777777777
-- 016:6666666666666666666666666666666666666666666666666666666666666666
-- 017:6666666666111166611dd11661d44d1661d44d16611dd1166611116666666666
-- 018:ddddddddddffffdddffeeffddfeddefddfeddefddffeeffdddffffdddddddddd
-- 019:6666666666a66666666a66666666a666a666a6666a66a6666a6666666a666666
-- 020:ddddddddddeddddddddeddddddddedddedddeddddeddeddddedddddddedddddd
-- 021:dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd
-- 022:cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
-- 023:bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
-- 024:77777777c7777777cc777777ccc77777cccc7777ccccc777cccccc77ccccccc7
-- 025:777777777777777c777777cc77777ccc7777cccc777ccccc77cccccc7ccccccc
-- 032:1111111111111111111111111111111111111111111111111111111111111111
-- 033:2222222222222222222222222222222222222222222222222222222222222222
-- 034:3333333333333333333333333333333333333333333333333333333333333333
-- 035:4444444444444444444444444444444444444444444444444444444444444444
-- 036:5555555555555555555555555555555555555555555555555555555555555555
-- 037:aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
-- 038:8888888888888888888888888888888888888888888888888888888888888888
-- 064:00c000000c8c000c0c88ccc80c8a888a0c8aa9aa0c88a99800c8aa990c8aaa89
-- 065:0cccccccc88888888aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa9aaaaaaa99999999
-- 066:c0cccccc8c888999a8aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa999999999999
-- 067:cccc00009888c000a9988c00aa9988c0aa9998c0999998c09999998c9999998c
-- 068:00000000000000000000000c000000cb00000cb80000cbbb000cb8b800cbbb88
-- 069:00ccccccccbbbbbbbbb8b88bb88b88b8bbbb88bb88888b888bbb88bbbaaabbaa
-- 070:ccccc00cbbbbbccb88b88bb88b888b8bbbb8b88b888b88babb88bbaaaab8abaa
-- 071:ccc00000bbbcc0008abbbc00888abbc08bbaaabcb88b8abcab88b8bcbbb88bbc
-- 072:00000000000000000000000c000000c900000c940000c9440000c944000c9444
-- 073:00cccccccc99999999444444c4444444c4444444c44444494cc44493444c9933
-- 074:c0cccccc9c999999494444444444444449444444949444443949944439c93994
-- 075:c00000009cc00000499c000044c9c00044c9c00044cc9c004c4cc9c04c44c9c0
-- 076:000000000000000c000000ca00000ca90000ca440000ca44000ca444000ca444
-- 077:ccccccccaaaaaaa9999999999999aaaa99aa333a4a3333334a333333a3333333
-- 078:cccccccc9aaaaaaa999999999999999999a99999a9aa9999a4a3a944a4a33a94
-- 079:00000000c0000000ac0000004ac0000044ac0000444ac0004444ac004444ac00
-- 080:c8aaaa8ac8aaaa8acba8aa8acb8c8a8ac8cc8a880c0c8aa8000cffff0c0cfaaf
-- 081:aaaa9999a88aaaaaa88aaaaa898aaaaa8988888899888999fffff99f9888f99f
-- 082:99999999aa8aaaaaaa8aaaaaa898aaaa8898888888889999ffffffff9888889f
-- 083:9aaaaa8c8aaaaa8c8aaaaa8c8aaaaa8c8aaaaa8c8aaaaa8c8998aa8c8998aa8c
-- 084:00cb8bab00cbba8b00cbbaba00cbaaba00cbabbb0cbaabaa0cb8abaa0cbbbbbb
-- 085:aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaabbaaaaaabbbaaaabaaaaaaaabaaaaaaa
-- 086:aaab88bbaaaabab8aaaabaabaaaaabaabbbbbbbabbaaaabaaaaaaaababbbbbbb
-- 087:88bb88bc8bbb88bcb88b88bcb88b88bcabbbb8bcab8bb8bcab8bb8bcabbbb8bc
-- 088:000c944400c9444400c9444400c9444400c9444400c9494400c9994900c93949
-- 089:444933334493333349333333493d333993399933933333933bbbb333bcaaab33
-- 090:39c9339439c933399449333344933333993399933339333333333bbb3333baaa
-- 091:c444c9c0444449c09444449c9444449c3944449c3394449cb394499ccb9493dc
-- 092:000ca999000ca99a000ca99a00c8999a00c899a300c899a800c899a800c899a3
-- 093:a3333333aaa33333333a3333333333338883333ac8883333c8a88333cca83333
-- 094:a4a333a9a9a999a9aaa3333aaa33333aa3388883338c8888333c8a88333cca83
-- 095:9994ac0099994ac099999ac099999ac0a9999ac0a9999ac0a9999ac0a9999ac0
-- 096:c8ccfaafc888faafc8aafaaf0c8aafaf00c88fff000c88a8000c8aa800c8aaa8
-- 097:8c88ffff8c8cf99f8ca9f99f9888f99fffff9999999999999999899999999899
-- 098:8c888c8f9c88cc8f9caa9c8f988888f9ffffff989999998a9999988899999999
-- 099:8aa8888c8aa8988c8aa8998c8aa8998caa89998ca899988c899988c09888a8c0
-- 100:0cb8bccb0cb8bcc80cb8bbcb0cb8b2bb0cb8bbab0cb8baaa0cb8baaa0cb8baaa
-- 101:bbaaaaaa8caaaaaa8abaaaabbbaaaaaaabaaaaaaaaaaaaaaaabaaaaaaaabbbaa
-- 102:bcbbbcbbcc88ccbbccb8ab2babbbb2bbbababaabaaaaaaabaaaaaaabaaaaaaab
-- 103:abbaabbc8baaabbcabaaabbc8baaabbc8baab8bc8babb8bc8bb8b8bc8bb8b8bc
-- 104:0cddd39900ca333b000ca333000ca3330000ca3a0000c9aa0000c94a0000c944
-- 105:bcc11cb3bc911c333aaaa3337773333333333333333333333333333aa3333333
-- 106:333bcc113333c91133333aaa33333337333333333333333333333333aa333333
-- 107:cb9433accbb333dca3333aac77a3dac033aaac0033a49c0033a49c003a449c00
-- 108:00c899a300c899a300c899a700c899a300c899a300c899a300c899a800c899a8
-- 109:c8983333aaaa33337733333333333333333333a33333333a3333333333333333
-- 110:333c8983333aaaa3333337773333333333333333333333333333333333333333
-- 111:a9999ac0a9999ac0a9999ac089999ac089999ac089999ac089999ac089999ac0
-- 112:00c8aa8800c8a88c00c8a8c000c888c0000c88c00000c8c000000c0000000000
-- 113:8999999989998888c8999aaa0c89998800c8999900c8899900c8a8880c8aa888
-- 114:9999999988999999a99999989999998999999899999889998889999988999999
-- 115:8aaa8c008aa888c08aaaa88c8aaaaa8c8aaaaa8c8aaaaa8c8aaaaa8c88aaaa8c
-- 116:0cb8bbaa0cb8bbaa0cb8bcba0cb8bccb0cb8bccb0cb8bc0c0cb8bc000cb8bc00
-- 117:aaaaaaaaaaaaaaaaaaabbbbbaaaa222aaaaabbbabaaaaaaacbbaaaaa0cbbbbbb
-- 118:aaaaaaabaaaaaabbaaaaaabbaaaaab8baaaabb8baaabbb8babbabb8bbaaabb8b
-- 119:8bb8b8bc8bb8b8bc8bb8b8bc8bb8b8bc8bb8b8bc8bb8b8bc8bb8b8bc8bb8b8bc
-- 120:0000c94400000c9400000c99000000c9000000c9000000c90000000c000000c9
-- 121:a33333334a33333344a3333a444a33334444a33d44449a3394c9caaa94c9caaa
-- 122:3333333333333333aaa3333a333333a933d33acc3333aac9aaaa3ac9aa333ac9
-- 123:3a449c00a44c9c0044c99c0044c9c0009499c00094c9c00044c9c0009499c000
-- 124:00c899a800c899a900c899a900c899a900c899a900c894a900c894a900c894a9
-- 125:83333a33833333aa883333339883333399883333999988339999888899998888
-- 126:33a33333aa33333a333333a833333aa83333a99833aaa9988a33a9983333a998
-- 127:89999ac089999ac099999ac099999ac0994999ac944a99ac944a99ac944a99ac
-- 128:00000000000000000000000c0000ccc8000c888800c888220c228222c8282222
-- 129:00c88c88000ccc89ccc88899888c89998ccc888888cccccc2288888822222222
-- 130:899999999999999999999998999988888888cccccccccc888888882222222222
-- 131:98aaaa8c988888c08888c000ccc88c00c88228c08222228c2222228c2222228c
-- 132:0cb8bc000cb8bc000cb8bc0c00cbc0cb000c0cff000ccfff00cfffff0cffffff
-- 133:0cbbbbaacbbbbaaabcbaaaaaccbaaaaacccbaaaaccccbaabcccbbbbbfccbcccc
-- 134:aaaabb8baaaabcbbaaabcccbaabcccffbbcccfffcccccfffccccffffbccfffff
-- 135:8bb8b8bc8bb8b8bc8bb8b8bcbfb8cbc0fff8c000fffffcc0fffffffcfffffffc
-- 136:000000c90000000c0000000c00000cca0000ca3f000ca33f00ca333f0ca3333f
-- 137:444aafaa94af3fa3aa3f3f33a33f33f3a333f33fa333f333a333f333a3333f33
-- 138:a3333fca33333ffa3333f3f3333f33f31cf333f311333f331133f3333333f333
-- 139:9499c000a49c0000faac0000fa3ac000fa33ac00fa333ac0f1a333acf1a333ac
-- 140:00c894890c8994890c8989980c8989980c898998c8998998c8998998c8928898
-- 141:9999883399998333999883339888333323333333723333337722333377772222
-- 142:3333a9983333a99833333a98333333a833333338333332283333227822227778
-- 143:944899ac999899ac998999ac998999ac998999ac998229ac998722ac9877772c
-- 144:c8282222c8282222c8822222c8822222c8822222c8822222c8822222c8822222
-- 145:2222222222222222222222222222222222222222222222222222222222222222
-- 146:2222222222222222222222222222222222222222222222222222222222222222
-- 147:2222228c2222288c2222288c2222288c2222888c2222828c2222828c2222828c
-- 148:cfffffffcfffffffcfffffffcfffffffcfffffffcfffffffcfffffffcfffffff
-- 149:fcbbbbbbffbbdddbffcbdddbfffcbbbcfffcbdbcffffbdbfffffdddffffffdff
-- 150:bcffffffbcffffffcfffffffffffffffffffffffffffffffffffffffffffffff
-- 151:fffffffcfffffffcfffffffcfffffffcfffffffcfffffffcfffffffcfffffffc
-- 152:ca38333fc888833fc83383f1ca8383f1ca8883f1ca3333f1ca8833f1ca3383f1
-- 153:aa333f331a3333f31a33333a1a33333911a3333911a33339111a3333111aa333
-- 154:333f333333ff3333acf3333f4c33333f493333f199333ff133333f113333f111
-- 155:f1a338acf1a3888c11a338ac11a333ac11a338ac111a33ac111a338c111aa3ac
-- 156:c8277898c8277898c8327789c8332788c8332278c8333277c8333227c8333327
-- 157:7777777777777777877777778777777788777777888777777777777777777777
-- 158:7777777877777789777777887777778877777887777888777777777777777777
-- 159:9877772c8777722c8777222c7777232c7772332c7772332c7772332c7723332c
-- 160:000000c000000c8c00000ca800000caa00000c8a0000cc8a000c8aaa00c8aa99
-- 161:0000cccccccc88888888aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa8aa8aa98899
-- 162:cccccccc88aa8888aaaaaaaaaaaaaaaaaaaaaaaaaaa88aaaaa858aaa9a558aa9
-- 163:cc00000088cc0000aa88c000aaaa8c00aaa998c0aaaa998caaaa998c8a99999c
-- 164:000000000000000c00000ccf0000cfff0000cfff000cffff000cddff000cdddf
-- 165:0ccccccccfffffffffffffffffffffffffffffffffffffffff55fffff5555ddd
-- 166:cc0cccccffcfffffffffffffffffffffffffffffffffffffffffffdddddddddf
-- 167:00000000ccc00000ffdcc000ffdddc00ffddddc0fdddddfcdddffdfcfffffffc
-- 168:000000000000000c000000cb00000cb80000cba80000cbaa000cb8aa000cb888
-- 169:0cccccc0cbbbbbbcb88888888888888888888bbbaababbbbaab8b99988b8b999
-- 170:ccccccccbbbbbbbb8bb8888888888888bbb88b88bbbbabba999b8bbb999b8b9b
-- 171:00000000cc000000bbccc0008b8bbc008888abc0aaaaabc0aaaaaabc888aaabc
-- 172:000000000000000c000000cb00000cbe0000cbee000cbeee000cbeeb000cbeeb
-- 173:ccccccccbeeeeeedeeeeedeeeeeeeeeeeebbbbbbbbaaaaaaaaaaaaaaaaacaaaa
-- 174:ccccccccedeeeedddededeedeeedeedebbbbbbbdaaaaaaabaaaaaaaaaaacccaa
-- 175:c0000000bc000000ebc00000ddbc0000eedbc000bdedbc00abdebc00abedbc00
-- 176:0c8aaaaac8aaaaaac8aaaaaac88aaa110c8aa1880c8aa1ff0c8aa1ff00c8a1fb
-- 177:8aaa888a88aa858aaaaaa55a11111111bbbbddddddddddddbbbbddddddc8bdda
-- 178:a8558aa8a855888aaaa5555a11111111ddbbbbbddddddddddddbbbbbddbdc88d
-- 179:89999a9c8aa8aa9c8aa8aa8c1188aa8cd158aa8cdd1ffffcdd1ff88cbd1f858c
-- 180:00cfffdd00cfffff0cffffffcffffff50cfffff500cfffff000cfff5000cafff
-- 181:f5555ffff55555fff55555fff555555555555555ffff555555555555ffff5555
-- 182:ffffffff5fffffff55f5ffff55555555555555555ffffff55555555555fffff5
-- 183:fffffffcfffffffcfffffffc5ffffffc5ffffffc55fffffc55faaafc55aa5aac
-- 184:000cb888000cb888000cb888000cb8b8000cbbb8000cbbb8000cbcb80000ccb8
-- 185:88b8b99988b888998bb888998b99999988bbb99988c88b9988ccaa9988ca9a99
-- 186:9998899b9988888899888888999999999999bbbb999bc8889999ccaa9999ca9a
-- 187:888888bc888888bc888888bcb888b8bcb8bbb8bcb89b88bcc9b8bbbcc99b9bbc
-- 188:000cbeba000cbeba000cbeba000cbeba000cbeba000cbebb000cb111000cbe1a
-- 189:aacaaaaaaaaaaaaaaaaa22aaaaaaaa22bbbbaaaaaaabbbaa1111111aabbbbb11
-- 190:aaaaaccaaaaaaaaaaaa22aaa222aaaaaaaaaabbbaaabbbaaaa111111a11bbbbb
-- 191:aabebc00aabebc00aabdbc00aabebc00babebc00abbebc001111bc00aa1ebc00
-- 192:00c8a18b0cc8a188c888a1880c88a18800cc88180000ccc1000000c80000ccc8
-- 193:cca9bdddb888dddddddd1111ddd15555ddd15855111558555555558555555555
-- 194:dbccaa9cddbb888bdddddddd1ddddddd51dddddd551111115555555555555555
-- 195:bd15558cdd15558cdd15558cd155558c1155588c555888c07558a8c05558a8c0
-- 196:00ca5ff500ca5ff500ca5ff500ca555500ca5555000ca5a50000caa500000ca5
-- 197:ccfff555c8885555aaaa55555555555555555555555555555555555555555aaa
-- 198:5fccffcf55c888c555aaaaa55555555555555555555555555555555555555555
-- 199:55a555ac555555ac555555ac555555ac55a55ac055a55ac055aaac0055acc000
-- 200:00000cb800000cb8000000cb0000000c0000000c000000000000000000000000
-- 201:8888889988999999bb999999bb999999bb999989cb999998cbb99999cbb99999
-- 202:9999888899999999999999999999999999999999899999999999999999998999
-- 203:899999bc999999bc999999bc999999bc99999bbc999bbbc099babc009b8abc00
-- 204:00cbab1a00cbaa1a00cbaa1a00cbaa1a00cbaaa1000cbaa2000cbb22000c4cb2
-- 205:bccbbcb1ac88aca1888888a1aaaaa82122a882121111112a22a8abba2a8aaaab
-- 206:11bccbbca1ac88aca1a888882128aaaa221288a2aa211111aabba8a2bbaaaa8a
-- 207:ba1babc0aa1aabc08a1aabc0aa1aabc021aaabc012aabc00222bbc0022bc4c00
-- 208:000c88880000c8aa0000c88800000ccc000000000000000c0000000000000000
-- 209:555555558555588888555555cc855558c8a855558aaa8855c88aa8880ccccd88
-- 210:5558555588855555555555558555555555755555555555888888885588885555
-- 211:5558a8c05588a8c0558aa8c05888aa8c88c8888c58ccccc0581cc00058c11c00
-- 212:000000ca000000ca0000000c0000000c00000000000000000000000000000000
-- 213:5555555555555555a5555aaaa5555555ca5555aa0ca5555500ca5555000cbbbb
-- 214:5555555555555555aa5555555555555aa55555aa55555aac5555aaacbbba55ac
-- 215:5ac000005ac00000ac000000ac000000c0000000000000000000000000000000
-- 216:0000000c000000cb0000000c0000000000000000000000000000000c000000ca
-- 217:bbbb9998bbbbb999cbbcb9990cc0cb99000cbbbb00ccbcbbccbbccbbaabcccbb
-- 218:88889999999999998889999b999999b99999bb99bbbb999bbb99999b99999bbc
-- 219:9b88bc00bbb8bbc0bbcbcc00bbbc0000bcbc0000bccbc000ccccbc00cccccbc0
-- 220:000c4cba000c4cba0000c0cb000000cb0000000c000000000000000000000000
-- 221:aa8aaaaaaaaabb22aaaaa2bbaaa8aa22baaa8aa8cbaaaaaa0cbbaaaacccbbbaa
-- 222:aaaaaa8a222bbaaabbb2aaaa222aa8aa88aa8aaaaaaaaaabaaaaabbcaaabbbcc
-- 223:aabc4c00aabc4c00abc0c000abc00000bc000000c000000000000000c0000000
-- 224:000000000000000c000000cc00000cff0000cffd000cfdfd00cfdddf0cfddddf
-- 225:cfffdd88ffdddf88fddddf85ddddf585ddddf555ddddf555ddddff55ddddfff5
-- 226:888555558855555555555555555555555555555555555555555555505555550c
-- 227:58cc11c058ccc1c0551ccc1c511ccc1c51cccc1c0ccccc1ccccccc1cccccc11c
-- 228:000000000000000000000000000000cc0000ccbb00ccbb660cbb66660cb66666
-- 229:000cbbbb000cbbbbcccbbb55bbb6b5556666b55566666bb56666666b66666666
-- 230:bb5555acb55555ac555555bb55555bb65555bb66555bb666b5bb66666bb66666
-- 231:0000000000000000cc000000bbc0000066bcc000666bbc0066666bc066666bc0
-- 232:00000ca40000ca4400ccaa4a0cbba44acbb1a44acb11a44acb11a44acb11a44a
-- 233:4bbcccb9bccccccbbbcccccc11bccccb11bcccbb111bcbb1111bbb1111111111
-- 234:999bbccc99bbccccbbbcccccb1bccccc111bcccc1111bccb1111bbbb11111111
-- 235:ccccbbc0cccbbbbcccbb1bbccbb111bcbb1111bcb11111bc111111bc111111bc
-- 236:0000000c0000000c0000000c000000cc00000cbb0000cbb1000cbb11000cb111
-- 237:bbbbaabbb111bbaab11111bab11111bcb11111ba1b11111b11bb111b1111b111
-- 238:bbbaabbbaaabb111aab11111acb11111cab11111ab11111bab111bb1b111b111
-- 239:bc000000bc000000bc000000bcc00000bbbc000011bbc000111bbc001111bc00
-- 240:cfddddddcfddddddcfddddddcfddddddcfdddddfcfdddddfcfddddddcfdddddd
-- 241:fdddffffdfdcffffdfccffffffccfffffcccffffcccccffcfccccfccdfccfccc
-- 242:ffffffccfffffcccffffccccfffccc11fcccc1ccccccfccccccffcccfffccccc
-- 243:ccc11c1ccc1ccc1c11cccc1ccccccc1ccccccc1ccccccc1ccccccc1ccccccc1c
-- 244:cb666666cb666666cb666666cb666666cb666666cb666666cb666666cb666666
-- 245:6666666666666666666666666666666666666666666666666666666666666666
-- 246:666b66666b6b6666666b6666666b6666666b6666666b66666b6b6666666b6666
-- 247:666666bc666666bc666666bc666666bc666666bc666666bc666666bc666666bc
-- 248:cb11a44acb11a44acb11a44acb11a44acb11a44acb11a44acb11a44acb11a44a
-- 249:1111111111111111111111111111111111111111111111111111111111111111
-- 250:1111111111111111111111111111111111111111111111111111111111111111
-- 251:111111bc111111bc111111bc111111bc111111bc111111bc111111bc111111bc
-- 252:00cb111100cb11110cb111110cb111110cb111110cb111110cb1111100b11111
-- 253:11111b11111111b1111111b11111111b1111111b111111111111111111111111
-- 254:b11b1111b1b11111b1b11111bb111111bb111111b1111111b1111111b1111111
-- 255:11111bc011111bc0111111bc111111bc111111bc111111bc111111bc111111bc
-- </TILES>

-- <SPRITES>
-- 000:00000000000000cc00000cbb0000cb88000cb88800cba88800cbaaaa000cb888
-- 001:ccccccccbbbbbbbb88888888888888888888888888888888aa88aaaaaa888888
-- 002:ccccccccbbbbbbbb8888888a8888888a88888888888888aaaaaaaaaa8888aaa8
-- 003:00000000c0000000bc000000abc00000aabc0000aaabc000aaaabc00888abc00
-- 010:0ccccccccc111111c1111111c1111111c1111111c1111111c1111111c1111111
-- 011:cccccccc11111111111111111111111111111111111111111111111111111111
-- 012:cccccccc11111111111111111111111111111111111111111111111111111111
-- 013:cccccccc11111111111111111111111111111111111111111111111111111111
-- 014:cccccccc11111111111111111111111111111111111111111111111111111111
-- 015:cccccc0011111cc0111111c0111111c0111111c0111111c0111111c0111111c0
-- 016:00cb888800cb888800cb8b8b00cb8b8b000cbb8b00cbb8b300cb88b30cb888bb
-- 017:888888888b8b888b3383b88333333bb38888333333888338bbb33333c88b3333
-- 018:888888883b888b8833388388333333b888888838883338833bbbb333bcc88b33
-- 019:8888bc0088888bc088888bc088888bc08888bbc08888abc0b8ba3aacb8b333ac
-- 026:c1111111c1111111c1111111c1111111c1111111c1111111c1111111c1111111
-- 027:1111111111111111111111111111111111111111111111111111111111111111
-- 028:1111111111111111111111111111111111111111111111111111111111111111
-- 029:1111111111111111111111111111111111111111111111111111111111111111
-- 030:1111111111111111111111111111111111111111111111111111111111111111
-- 031:111111c0111111c0111111c0111111c0111111c0111111c0111111c0111111c0
-- 032:0cbb88b300ccb8b3000cb8b3000cb8b30000cbb300000cb3000000ca000000ca
-- 033:cc8a7773ca9a77333bbb7733333a7333333a7333333a333a333aaaa333333333
-- 034:3ccc8a333cca9a333bbbb33333333333333333333333333333333333333a3333
-- 035:b8b333acbb3333ac333333ac33a33ac033b3ac003b8bc0003b8bc000b88bc000
-- 042:c1111111c1111111c1111111c1111111c1111111c1111111c1111111c1111111
-- 043:1111111111111111111111111111111111111111111111111111111111111111
-- 044:1111111111111111111111111111111111111111111111111111111111111111
-- 045:1111111111111111111111111111111111111111111111111111111111111111
-- 046:1111111111111111111111111111111111111111111111111111111111111111
-- 047:111111c0111111c0111111c0111111c0111111c0111111c0111111c0111111c0
-- 048:0000000c0000000c00000000000000000000000000000000000000000000000c
-- 049:a33aaaaaa333aaccca3333aa0ca3383300ca88880cff8888cf222f88f2222f33
-- 050:aaa33333cca3333baa3333b833333bcb3333bbcc88ab3fff8333f222333f2222
-- 051:b88bc00088bbbc008bccc000bc000000ccc00000fffc0000222fc000222fc000
-- 058:c1111111c1111111c1111111c1111111c1111111c1111111cc1111110ccccccc
-- 059:11111111111111111111111111111111111111111111111111111111cccccccc
-- 060:11111111111111111111111111111111111111111111111111111111cccccccc
-- 061:11111111111111111111111111111111111111111111111111111111cccccccc
-- 062:11111111111111111111111111111111111111111111111111111111cccccccc
-- 063:111111c0111111c0111111c0111111c0111111c0111111c011111cc0cccccc00
-- 064:0000000c0000000c000000cf00000cf20000cf2f000cf22f00cf222f00cf22f2
-- 065:f22222f3ff22222ff2f2222ff22f22f2222ff2f2222fcfff222fcf22222fcf22
-- 066:3ff22222f22222222222ff22222ff2222ff22222fcf22222fcf22222fcf22222
-- 067:222fc000222fc0002ffc0000222fc0002222fc0022222fc022222fc0222222fc
-- 068:0cccccccccffffffcfffffffcfffffffcfffffffcfffffffcfffffffcfffffff
-- 069:ccccccccffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 070:ccccccccffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 071:ccccccccffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 072:ccccccccffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 073:ccccccccffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 074:ccccccccffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 075:ccccccccffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 076:ccccccccffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 077:ccccccccffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 078:ccccccccffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 079:cccccc00fffffcc0ffffffc0ffffffc0ffffffc0ffffffc0ffffffc0ffffffc0
-- 080:0cc222f20cf222f20cf222f2cf222f22cf222f22cf222f22cf222f22cf222f22
-- 081:222fcf22222fcf22222fcf22222fcf22222fcf22222fcf222222f22222222222
-- 082:fcf22222fcf22222fcf22222fcf22222fcf22222fcf222222f22222222222222
-- 083:222222fc222222fc22f222fc22f222fc22f222fc2f2222fc2f2222fc2f2222fc
-- 084:cfffffffcfffffffcfffffffcfffffffcfffffffcfffffffccffffff0ccccccc
-- 085:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffcccccccc
-- 086:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffcccccccc
-- 087:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffcccccccc
-- 088:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffcccccccc
-- 089:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffcccccccc
-- 090:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffcccccccc
-- 091:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffcccccccc
-- 092:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffcccccccc
-- 093:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffcccccccc
-- 094:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffcccccccc
-- 095:ffffffc0ffffffc0ffffffc0ffffffc0ffffffc0ffffffc0fffffcc0cccccc00
-- 128:00c000000c8c000c0c88ccc80c8a888a0c8aa9aa0c88a99800c8aa990c8aaa89
-- 129:0cccccccc88888888aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa9aaaaaaa99999999
-- 130:c0cccccc8c888999a8aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa99999999999d
-- 131:cccc00009888c000a9988c00aa9988c0da9998c0d99998c0cd99998ccd99998c
-- 132:00000000000000000000000c000000cb00000cb80000cbbb000cb8b800cbbb88
-- 133:00ccccccccbbbbbbbbb8b88bb88b88b8bbbb88bb88888b888bbb88bbbaaabbaa
-- 134:ccccc00cbbbbbccb88b88bb88b888b8bbbb8b88b888b88babb88bbaaaab8abaa
-- 135:ccc00000bbbcc0008abbbc00888abbc08bbaaabcb88b8abcab88b8bcbbb88bbc
-- 136:00000000000000000000000c000000c900000c940000c9440000c944000c9444
-- 137:00cccccccc99999999444444c4444444c4444444c44444494cc44493444c9933
-- 138:c0cccccc9c999999494444444444444449444444949444443949944439c93994
-- 139:c00000009cc00000499c000044c9c00044c9c00044cc9c004c4cc9c04c44c9c0
-- 140:000000000000000c000000ca00000ca90000ca440000ca44000ca444000ca444
-- 141:ccccccccaaaaaaa9999999999999aaaa99aa33aa4a3333a34a3333a4a33333a4
-- 142:cccccccc9aaaaaaa999999999999999999a99999a33a9999a333a944a3333a94
-- 143:00000000c0000000ac0000004ac0000044ac0000444ac0004444ac004444ac00
-- 144:c8aaaadac8aaaadacba8adcacb8c8dcdc8cc8ddd0c0c8ad8000cffff0c0cfaaf
-- 145:aaaa9999a88aaaaaa88aaaaa898aaaaa8988888899988988fffff98faa88f99f
-- 146:9999999daa8aaaaaaa8aaaaaa898aaaa8898888899999999ffffffff8888aaaf
-- 147:ddadaa8cdaadaa8c8aacda8c8adcda8c8addda8c8aadaa8c8998aa8c8998aa8c
-- 148:00cb8bab00cbba8b00cbbaba00cbaaba00cbabbb0cbaabbb0cb8abaa0cbbbbbb
-- 149:aaaaaaaaaaaaaaaaaaaaaaaabbbaaaabbbaaaaa2222aaaa2a22aaaaaba2aaaaa
-- 150:aaab88bbaaaabab8aaaabaabbbaaabaabbbbaaba22bbbbba2aaaaaababbbbbab
-- 151:88bb88bc8bbb88bcb88b88bcb88b88bcabbbb8bcab8bb8bcab8bb8bcabbbb8bc
-- 152:000c944400c9444400c9444400c9444400c9444400c9494400c9994900c93949
-- 153:444933334493333349333333493333399339d33393339333bbb33933bdabb393
-- 154:39c9339439c93339944933334493333399333333333333933333993b33993bba
-- 155:c444c9c0444449c09444449c9444449c3944449c3394449cbb94499cdb9493dc
-- 156:000ca999000ca99a000ca99a00c8999a00c899a700c899ab00c899ab00c899ad
-- 157:a33333a4933333a3399339aa3339933abbb3b333db8b3333cca8b333c8a83333
-- 158:a33333a9a33333a9a393399aa3b9933aaa3bbbb733bdb88b333cca8b33dc8add
-- 159:9994ac0099994ac099999ac099999ac0a9999ac0a9999ac0a9999ac0a9999ac0
-- 160:c8ccfaafc888faafc8aafaaf0c8aafaf00c88fff000c88a8000c8aa800c8aaa8
-- 161:8888ffff8d8df99f8ca9f9afa8aaf99fffff9aa99999aa9a9999899999999899
-- 162:8888888f98d88d8facca9a8f9aaaa8f9ffffff989999998a9999988889999999
-- 163:8aa8888c8aa8988c8aa8998c8aa8998caa89998ca899988c899988c09888a8c0
-- 164:0cb8bbdb0cb8bbd80cb8bbcb0cb8b2bb0cb8bb2b0cb8baaa0cb8baaa0cb8baaa
-- 165:bbaaaaaa8caaaaaa8abaaaabbbaaaaaaabaaaaaaaaaaaaaaaabaaaaaaaabbbaa
-- 166:bdbbbdbbdd88ccbbdcb8ab2babbbb2bbbabab22baaaaaaabaaaaaaabaaaaaaab
-- 167:abbaabbc8baaabbcabaaabbc8baaabbc8baab8bc8babb8bc8bb8b8bc8bb8b8bc
-- 168:0cddd39900ca3339000ca333000ca3330000ca3a0000c9aa0000c94a0000c944
-- 169:cccaab73bc911cb77bbaaa997773997773393777333333333333333aa3333333
-- 170:3337baac337bc9113399aaab97779937777773933333333333333333aa333333
-- 171:cc9433accb9333dcb7333aac77a3dac037aaac0033a49c0033a49c003a449c00
-- 172:00c899d700c899d700c899d700c899d300c899d300c899ad00c899ad00c899ad
-- 173:b222d7337dd77377d3333777333333a7333333da333333d33333333333388888
-- 174:37d2222d337777777333337d333333333333333333333333333333338833333d
-- 175:d9999ac0a9999ac0a9999ac089999ac089999ac089999ac089999ac089999ac0
-- 176:00c8aa8800c8a88c00c8a8c000c888c0000c88c00000c8c000000c0000000000
-- 177:8998999989988cccc899aaaa0c89988800c8aa9900c8899900c8a8880c8aa888
-- 178:98999999c8999999aa99d9989999d989a999cd9999adcd99888ddd998899d999
-- 179:8aaa8c008aa888c08aaaa88c8aaaaa8c8aaaaa8c8aaaaa8c8aaaaa8c88aaaa8c
-- 180:0cb8bbaa0cb8bbaa0cb8bcba0cb8bccb0cb8bccb0cb8bc0c0cb8bc000cb8bc00
-- 181:aaaaaaaaaaaaaaaaaabbbbbaaab2222baaaabbaabaaaaaaacbbaaaaa0cbbbbbb
-- 182:aaaaaaabaaaaaabbaaaaaabbaaaaab8baaaabb8baaabbb8babbabb8bbaaabb8b
-- 183:8bb8b8bc8bb8b8bc8bb8b8bc8bb8b8bc8bb8b8bc8bb8b8bc8bb8b8bc8bb8b8bc
-- 184:0000c94400000c9400000c99000000c9000000c9000000c90000000c000000c9
-- 185:a33333334a333aaa44a333aa444a333a4444a33d44449a3394c9caaa94c9caaa
-- 186:33aaa333aaccca33ccccaa3aaaaa33a933d33acc3333aac9aaaa3ac9aa333ac9
-- 187:3a449c00a44c9c0044c99c0044c9c0009499c00094c9c00044c9c0009499c000
-- 188:00c899a800c899a900c899a900c899a900c899a900c894a900c894a900c894a9
-- 189:33388cdcd3338888d8333777988399339d88333399d988339999888899998888
-- 190:dc83333d888333dd733333d899933ad83333a99833aaad988a33a9983333a998
-- 191:89999ac089999ac099999ac099999ac0994999ac944a99ac944a99ac944a99ac
-- 192:000000c000000c8c00000ca800000caa00000c8a0000cc8a000c8aaa00c8aa99
-- 193:0000cccccccc88888888aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa8aa8aa98899
-- 194:cccccccc88aa8888aaaaaaaaaaaaaaaaaaaaaaaaaaa88aaaaa858aaa9a558aa9
-- 195:cc00000088cc0000aa88c000aaaa8c00aaa998c0aaaa998caaaa998c8a99999c
-- 196:000000000000000c00000ccf0000cfff0000cfff000cffff000cddff000cdddf
-- 197:0ccccccccfffffffffffffffffffffffffffffffffffffffff55fffff5555ddd
-- 198:cc0cccccffcfffffffffffffffffffffffffffffffffffffffffffdddddddddf
-- 199:00000000ccc00000ffdcc000ffdddc00ffddddc0fdddddfcdddffdfcfffffffc
-- 200:000000000000000c000000cb00000cb80000cba80000cbaa000cb8aa000cb888
-- 201:0cccccc0cbbbbbbcb88888888888888888888bbbaababbbbaab8baa988b8ba99
-- 202:ccccccccbbbbbbbb8bb8888888888888bbb88b88bbbbabba999b8bbb999b8b9b
-- 203:00000000cc000000bbccc0008b8bbc008888abc0aaaaabc0aaaaaabc888aaabc
-- 204:000000000000000c000000cb00000cbe0000cbee000cbeee000cbeeb000cbeeb
-- 205:ccccccccbeeeeeedeeeeedeeeeeeeeeeeebbbbbbbbaaaaaaaaaaaaaaaaacaaaa
-- 206:ccccccccedeeeedddededeedeeedeedebbbbbbbdaaaaaaabaaaaaaaaaaacccaa
-- 207:c0000000bc000000ebc00000ddbc0000eedbc000bdedbc00abdebc00abedbc00
-- 208:0c8aaaaac8aaaaaac8aaaaaac88aaa110c8aa1880c8aa1ff0c8aa1ff00c8a1fb
-- 209:8aaa888a88aa858aaaaaa55a11111111bbdbdddddbbbddddeeeeddddbbbbedda
-- 210:a8558aa8a855888aaaa5555a11111111dbddbbdddbbbbdddeeeeeedddebbbbbb
-- 211:89999a9c8aa8aa9c8aa8aa8c1188aa8cd158aa8cdd1ffffcdd1ff88cbd1f858c
-- 212:00cfffdd00cfffff0cffffffcffffff50cfffff500cffff5000cffff000cafff
-- 213:f5555ffff55555fff55555fff55555555f55555555f5f55fff5ff555dfff5555
-- 214:ffffffff5fffffff55f5ffff5555555555555555555fff55fff5555555ffffff
-- 215:fffffffcfffffffcfffffffc5ffffffc5ffffffc55fffffc55faaafc55aa5aac
-- 216:000cb888000cb888000cb888000cb8b8000cbbb8000cbbb8000cbcb80000ccb8
-- 217:88b8b89988bbb8898bb888898baaa8898bbbaaa98bbbbba98bdd88b988cc98a9
-- 218:9998899b989889889888888899888889a9999bbba999bbbb9a9bdd889999cc98
-- 219:888888bc888888bc888888bcb888b8bcbbbbb8bcbb9b88bcb9b8bbbcbaab9bbc
-- 220:000cbeba000cbeba000cbeba000cbeba000cbeba000cbebb000cb111000cbe1a
-- 221:aacaaaaaaaaaaaaaaaaa22aaabbaaa22babbaaaaaaabbbaa1111111aabbbbb11
-- 222:aaaaaccaaaaaaaaaaaa22aaa222aaabbaaaaabbaaaabbbaaaa111111a11bbbbb
-- 223:aabebc00aabebc00aabdbc00aabebc00babebc00abbebc001111bc00aa1ebc00
-- 224:00c8a18b0cc8a188c888a1880c88a18800cc88180000ccc1000000c80000ccc8
-- 225:daa9bdddb88bdddddddd1111ddd18555ddd18555111558555555555555888888
-- 226:ebddaa9dddbb888bddeddddd1ddeeddd51dddddd551111115555555588885555
-- 227:bd15558cdd15558cdd15558cd155558c1155588c555888c07558a8c05558a8c0
-- 228:00ca5ff500ca5ff500ca5ff500ca555a00ca5555000ca5a50000caa500000ca5
-- 229:cdfff555c8885555aaaa55555555555355555535555555555555aaa555555555
-- 230:5fddffdf55c888c55aaaaaa53555777755555555555555555555555555555555
-- 231:55a555ac555555ac555555ac555555ac55a55ac055a55ac055aaac0055acc000
-- 232:00000cb800000cb8000000cb0000000c0000000c0000000000000c0c0000cdcd
-- 233:8bb8889988aa9999bba99999bba99999bb999989cb999998cbb99999cbb99888
-- 234:99aa88889a99aaaa999999999999999999999999899999999999999989999999
-- 235:a99999bcaa9999bc999999bc999999bc99999bbc999bbbc099babc009b8abc00
-- 236:00cbab1a00cbaa1a00cbaa1a00cbaa1a00cbaaa1000cbaa2000cbb22000c4cb2
-- 237:bddbbdb1ac88aca1888888a1aaaaa82122a882121111112a22a8abba2a8aaaab
-- 238:11bddbbda1ac88aca1a888882128aaaa221288a2aa211111aabba8a2bbaaaa8a
-- 239:ba1babc0aa1aabc08a1aabc0aa1aabc021aaabc012aabc00222bbc0022bc4c00
-- 240:000c88880000c8aa0000c88800000ccc000000000000000c0000000000000000
-- 241:558ccccc858cdccd88588888cc855555c8a855888aaa8855c88aa8880ccccd88
-- 242:cdcd8555ccdd8555888855555555555588575555555555888888885588885555
-- 243:5558a8c05588a8c0558aa8c05888aa8c88c8888c58ccccc0581cc00058c11c00
-- 244:000000ca000000ca0000000c0000000c00000000000000000000000000000000
-- 245:55555555555aaaa5a55a555aa5555555ca5355350ca5555300ca5555000cbbbb
-- 246:5555555555555555a55555555a55555a555555aa35555aac5555aaacbbba55ac
-- 247:5ac000005ac00000ac000000ac000000c0000000000000000000000000000000
-- 248:00000cdc000000cd00000cdc000000c000000000000000000000000c000000ca
-- 249:dddd988cddbbb9ffcbbcbaa90cc0cb9a000cbbbb00ccbcbbccbbccbbaabcccbb
-- 250:c88a9999fa9999999999999baaa999b99999bb99bbbb999bbb99999b99999bbc
-- 251:9b88bc00bbb8bbc0bbcbcc00bbbc0000bcbc0000bccbc000ccccbc00cccccbc0
-- 252:000c4cba000c4cba0000c0cb000000cb0000000c000000000000000000000000
-- 253:aa8aaaaaaaaaaa22aaaaa2bbaaaabb22baaaaaa8cbaa88aa0cbbaaaacccbbbaa
-- 254:aaaaaa8a222aaaaabbb2aaaa222bbaaa88aaaaaaaaa88aabaaaaabbcaaabbbcc
-- 255:aabc4c00aabc4c00abc0c000abc00000bc000000c000000000000000c0000000
-- </SPRITES>

-- <MAP>
-- 000:010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101
-- 001:010101010101010131707070707070707070707070700101515151515151010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101
-- 002:010130010101010131707070707070707070707070700101515151515151010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101
-- 003:010101010101100101707070707070707070707070703001515151515151010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101
-- 004:010101010101011101010160600101016060017070700101515151515151010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101
-- 005:010110011101013001010160600101306060017070700111515151515151010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101
-- 006:010101300101310101013232323201316060017070700101515151515151010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101
-- 007:010101010101010110013232323201016060310101010101016060010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101
-- 008:017171717171010101013232323201016060606060606060606060310101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101
-- 009:317171717171010101013232323260606060606060606060606060310101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101
-- 010:317171717171606060603232323260606060011111010101016060011001010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101
-- 011:017171717171606060603232323201016060011011013001016060010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101
-- 012:017171717171016060013232323210016060010101010110016060010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101
-- 013:017171717171016060013001110101016060010131010101016060010130010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101
-- 014:010101010101016060606060606060606060606060606060606060010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101
-- 015:010101300101016060606060606060606060606060606060606060010110010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101
-- 016:010110110101010101010131010160600101010110013001016060011101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101
-- 017:010101013101011101010101010160600131010101010101016060010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101
-- 018:010101310101010101010101013060600101310101011101016060010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101
-- 019:010122222222222201311001010160600101010101011001016060013001010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101
-- 020:300122222222222201010100000000000000000101010101016060010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101
-- 021:010122222222222260606000000000000000000130010101016060310101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101
-- 022:010122222222222260606000000000000000000101010101016060010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101
-- 023:013122222222222201310100000060600000000101010101016060011101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101
-- 024:010122222222222201010101010160600101010111110131016060010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101
-- 025:011022222222222201011011010160600101011001010101016060011011010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101
-- 026:010101606001010101010101310160600101010131010101016060010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101
-- 027:310101606001010101016161616161616161616101010101016060010131010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101
-- 028:011101606060606060606161616161616161616160606060606060013101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101
-- 029:010101606060606060606161616161616161616160606060606060010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101
-- 030:010101010160600101016161616161616161616101010101110101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101
-- 031:010101010160600111013001010160600101010101011001010130010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101
-- 032:010101010160600101010101010160600101010101010101013001010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101
-- 033:010130010160600101011001010160600101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101
-- 034:010101010160600101010101010160600101010110010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101
-- 035:011001010160600101010111010160600101300111010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101
-- 036:010101010160600101010101010160600101013001016262626262620101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101
-- 037:300101010160606060606060606060606060606060606262626262623101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101
-- 038:010101110160606060606060606060606060606060606262626262623101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101
-- 039:010101300160600111010101010160600101010101016262626262620101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101
-- 040:011101010160600101010101010160600101100101016262626262620111010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101
-- 041:010101010160600101011010010160600101010101016262626262620101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101
-- 042:010152525252525252010101010160600101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101
-- 043:010152525252525252010101010160600130010101010130010101010131010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101
-- 044:300152525252525252606060606060600101010101010101010101013101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101
-- 045:010152525252525252606060606060600101011101010101310101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101
-- 046:010152525252525252010101010101010101010130010110010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101
-- 047:010152525252525252010101010101010101010101010111010101011001010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101
-- 048:013101010101010101010131110101300101010101010101010131010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101
-- 049:010101011101010101010101010101010101111001010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101
-- 050:010101010101013131010101010101010131010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101
-- 051:515151515151515151515151515151515151515151515151515151515151010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101
-- 052:515151515151515141000000000000000000000000005151000000000000010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101
-- 053:515140515151515141000000000000000000000000005151000000000000010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101
-- 054:515151515151205151000000000000000000000000004051000000000000010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101
-- 055:515151515151512151515160605151516060510000005151000000000000010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101
-- 056:515120512151514051515160605151406060510000005121000000000000010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101
-- 057:515151405151415151510000000051416060510000005151000000000000010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101
-- 058:515151515151515120510000000051516060415151515151516060515151010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101
-- 059:510000000000515151510000000051516060606060606060606060415151010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101
-- 060:410000000000515151510000000060606060606060606060606060415151010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101
-- 061:410000000000606060600000000060606060512121515151516060512051010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101
-- 062:510000000000606060600000000051516060512021514051516060515151010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101
-- 063:510000000000516060510000000020516060515151515120516060515151010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101
-- 064:510000000000516060514051215151516060515151515151516060515140010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101
-- 065:515151515151516060606060606060606060606060606060606060515151010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101
-- 066:515151405151516060606060606060606060606060606060606060515120010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101
-- 067:515120215151515151515141515160605151515120514051516060512151010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101
-- 068:515151515151515151515151515160605151515151515151516060515151010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101
-- 069:515151415151515151515151514060605151415151512151516060515151010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101
-- 070:515100000000000051412051515160605151515151512051516060514051010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101
-- 071:405100000000000051515100000000000000005151515151516060515151010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101
-- 072:515100000000000060606000000000000000005151515151516060415151010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101
-- 073:515100000000000060606000000000000000005151515151516060515151010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101
-- 074:514100000000000051415100000060600000005151515151516060512151010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101
-- 075:515100000000000051515151515160605151515121215151516060515151010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101
-- 076:512000000000000051512021515160605151512051515151516060512021010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101
-- 077:515151606051515151515151415160605151515141515151516060515151010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101
-- 078:415151606051515151510000000000000000000051515151516060515141010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101
-- 079:512151606060606060600000000000000000000060606060606060514151010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101
-- 080:515151606060606060600000000000000000000060606060606060515151010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101
-- 081:515151515160605151510000000000000000000051515151215151515151010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101
-- 082:515151515160605121514051515160605151515151512051515151405151010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101
-- 083:515151515160605151515151515160605151515151515151515140515151010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101
-- 084:515140515160605151512051515160605151515151515151515151515151010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101
-- 085:515151515160605151515151515160605151515120515151515151515151010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101
-- 086:512051515160605151515121515160605151405121515151515151515151010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101
-- 087:515151515160605151515151515160605151514051510000000000005151010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101
-- 088:405151515160606060606060606060606060606060600000000000004151010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101
-- 089:515151215160606060606060606060606060606060600000000000004151010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101
-- 090:515151405160605121515151515160605151515151510000000000005151010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101
-- 091:512151515160605151515151515160605151205151510000000000005121010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101
-- 092:515151515160605151512020515160605151515151510000000000005151010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101
-- 093:515100000000000000515151515160605151515151515151515151515151010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101
-- 094:515100000000000000515151515160605140515151515140515151515141010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101
-- 095:405100000000000000606060606060605151515151515151515151514151010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101
-- 096:515100000000000000606060606060605151512151515151415151515151010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101
-- 097:515100000000000000515151515151515151515140515120515151515151010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101
-- 098:515100000000000000515151515151515151515151515121515151512051010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101
-- 099:514151515151515151515141215151405151515151515151515141515151010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101
-- 100:515151512151515151515151515151515151212051515151515151515151010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101
-- 101:515151515151514141515151515151515141515151515151515151515151010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101
-- 102:010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101
-- 103:010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101
-- 104:010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101
-- 105:010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101
-- 106:010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101
-- 107:010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101
-- 108:010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101
-- 109:010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101
-- 110:010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101
-- 111:010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101
-- 112:010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101
-- 113:010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101
-- 114:010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101
-- 115:010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101
-- 116:010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101
-- 117:010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101
-- 118:010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101
-- 119:010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101
-- 120:010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101
-- 121:010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101
-- 122:010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101
-- 123:010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101
-- 124:010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101
-- 125:010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101
-- 126:010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101
-- 127:010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101
-- 128:010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101
-- 129:010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101
-- 130:010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101
-- 131:010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101
-- 132:010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101
-- 133:010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101
-- 134:010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101
-- 135:010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101
-- </MAP>

-- <WAVES>
-- 000:00000000ffffffff00000000ffffffff
-- 001:0123456789abcdeffedcba9876543210
-- 002:0123456789abcdef0123456789abcdef
-- </WAVES>

-- <SFX>
-- 000:000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000304000000000
-- </SFX>

-- <TRACKS>
-- 000:100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- </TRACKS>

-- <PALETTE>
-- 000:1a1c2c405dc273301cefba99ffcd75f2ded6698d3ceea1ae4c2820b26d34814820382428f5f4f494b0c2566c86101020
-- </PALETTE>

