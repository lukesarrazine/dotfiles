local function parse_and_save_frames(txt_filename)
    local frames = {}
    local current_frame = {}
    local line_count = 0
    local frame_length = 14
    local target_length = 66
    local frame_count

    local function pad_line(line)
        local extra_spaces = target_length - #line
        if extra_spaces > 0 then
            return line .. string.rep(" ", extra_spaces) -- Add spaces at the end
        else
            return line:sub(1, target_length)   -- Truncate if the line is too long
        end
    end

    -- Open the text file for reading
    local txt_file = io.open(txt_filename, "r")
    if not txt_file then
        error("Failed to open text file: " .. txt_filename)
    end

    -- Parse frames with 8 lines per frame
    for line in txt_file:lines() do
        if line_count ~= 0 then
            table.insert(current_frame, pad_line("|" .. line) .. "|")
        else
            frame_count = tonumber(string.match(line, "%d+"))
        end
        line_count = line_count + 1

        if line_count == frame_length then
            -- Add the current frame as a concatenated string
            if frame_count then
                for i = 1, frame_count do
                    table.insert(frames, table.concat(current_frame, "\n"))
                end
            else
                print("No valid number found in the string.")
            end

            current_frame = {} -- Reset for the next frame
            line_count = 0
        end
    end

    -- Add the last frame if it has remaining lines
    if #current_frame > 0 then
        table.insert(frames, table.concat(current_frame, "\n"))
    end

    txt_file:close()

    return frames
end

return parse_and_save_frames
