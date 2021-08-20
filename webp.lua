-- Vars
local cf    = 80                       -- Compression Factor [0 - 100]
local image = string.gsub(ngx.var.request_filename, "%%20", " ") -- NGINX Requested File .jpg
local webp  = image .. '.webp'         --       Requested File .jpg.webp
local info  = webp .. '.info'          --       Requested File .jpg.webp.info

-- File Exists Function
function file_exists(name)
  local f=io.open(name, 'r')
  if f~=nil then io.close(f) return true else return false end
end

-- Convert JPG|PNG -> WEBP & Generate .webp.info (DateTime + Size | 20201210 4044441) & Return Generated .webp file
function convert()
  os.execute('cwebp -q ' .. cf .. ' ' .. '"'..image..'"' .. ' -o ' .. '"'..webp..'"')
  os.execute("stat -c '%y %s' " .. '"'..image..'"' ..  " | awk '{ print $1, $4 }' | sed 's/-//g' > " .. '"'..info..'"')
  ngx.exec(ngx.var.uri .. '.webp')
end

-- Check if Requested File Exists
if file_exists(image) then
  -- Check if .webp and .webp.info File Exists
  if file_exists(webp) and file_exists(info) then
    -- Generate Requested File Hash
    local new = assert(io.popen("stat -c '%y %s' " .. image .. " | awk '{ print $1, $4 }' | sed 's/-//g'", 'r'))
    -- Get Hash From File
    local old = io.open(info, 'r')
    -- Compare Files Hash
    if (new:read() == old:read()) then
      ngx.exec(ngx.var.uri .. '.webp')
    else
      -- Hash NOT Matching
      convert()
    end
  else
    -- .WEBP or .WEBP.INFO NOT Exists
    convert()
  end
else
  -- Requested File NOT Exists
  ngx.exit(404)
end
