local M = {}
local day_start = 7 -- 7am
local day_end = 17  -- 5pm

function M.is_daytime()
    local hour = os.date("*t").hour
    return (hour >= day_start and hour < day_end);
end

function M.get_date_key()
    local today = os.date("*t")
    return today.month .. "-" .. today.day
end

return M
