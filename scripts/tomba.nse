local http = require "http"
local table = require "table"
local stdnse = require "stdnse"
local json = require "json"
local string = require "string"
-- local tomba = require "tomba" 

-- Set your Tomba API key and secret here to avoid typing it in every time:
local apiKey = ""
local apiSecret = ""

dependencies = {
    --  "tomba"
}

description = [[
Use Tomba API to lookup the website emails information.
It can be used to total email on webiste, total personal emails, total generic email and more.
You can get a free key from https://app.tomba.io/auth/register.
]] .. table.concat(dependencies, "\n* ") .. "\n"

---
-- @usage
-- nmap sV tomba <target> --script-args 'tomba.key=ta_xxxx,tomba.secret=ts_xxxx'
-- nmap sV tomba <target>
--
-- @args tomba.key     Tomba api key.
-- @args tomba.secret  Tomba api secret.
-- 
-- 
-- @output
-- | tomba: 
-- |   target: tomba.io
-- |   data: 
-- |     total 17
-- |     personal_emails 7
-- |     generic_emails 10
-- |     department: 
-- |       engineering 0
-- |       finance 0
-- |       hr 0
-- |       it 0
-- |       marketing 0
-- |       operations 0
-- |       management 0
-- |       sales 0
-- |       legal 0
-- |       support 1
-- |_      communication 3
-- 
-- @xmloutput
-- <elem key="target">tomba.io</elem>
-- <table key="data">
-- <elem>total 17</elem>
-- <elem>personal_emails 7</elem>
-- <elem>generic_emails 10</elem>
-- <table key="department">
-- <elem>engineering 0</elem>
-- <elem>finance 0</elem>
-- <elem>hr 0</elem>
-- <elem>it 0</elem>
-- <elem>marketing 0</elem>
-- <elem>operations 0</elem>
-- <elem>management 0</elem>
-- <elem>sales 0</elem>
-- <elem>legal 0</elem>
-- <elem>support 1</elem>
-- <elem>communication 3</elem>
-- </table>
-- </table>


author = "Tomba email finder"
license = "Same as Nmap--See https://nmap.org/book/man-legal.html"
categories = {"discovery","external","safe"}

hostrule = function(host)
    if host.targetname == nil then
        return nil
    end

    return true
end


local function fail(err)
    return stdnse.format_output(false, err)
end


local fetch_counter = function(host)
    local result
    local key = stdnse.get_script_args(SCRIPT_NAME .. ".key") or apiKey
    local secret = stdnse.get_script_args(SCRIPT_NAME .. ".secret") or apiSecret
    if string.len(key) < 39 then
        return fail("Invalid Tomba api key")
    end
    if string.len(secret) < 39 then
        return fail("Invalid Tomba api secret")
    end
    local options = {header = {}}
    options["header"]["Content-Type"] = "application/json"
    options["header"]["User-Agent"] = "Mozilla/5.0 (Windows NT 6.1; WOW64; rv:33.0) Gecko/20120101 Firefox/33.0"
    options["header"]["X-Tomba-Key"] = key
    options["header"]["X-Tomba-Secret"] = secret

    result = http.get("api.tomba.io", 443, "/v1/email-count?domain=" .. host.targetname, options)
    -- result = http.get_url("https://api.tomba.io/v1/email-count?domain=" .. host.targetname, options)
    if result.status ~= 200 then
        return fail("Request failed body " .. result.body)
    end

    if result.header == nil then
        return fail("Response didn't include a proper header")
    end

    local stat, resp = json.parse(result.body)
    if not stat then
        return fail("Error parsing Tomba response: " .. resp)
    end
    return resp
end


action = function(host)
    local data = fetch_counter(host)

    if data.data ~= nil then
        local output = stdnse.output_table()
        output.target = host.targetname
        output.data = {}
        output.data[#output.data + 1] = "total " .. data.data.total
        output.data[#output.data + 1] = "personal_emails " .. data.data.personal_emails
        output.data[#output.data + 1] = "generic_emails " .. data.data.generic_emails
        output.data.department = {}
        output.data.department[#output.data.department + 1] = "engineering " .. data.data.department.engineering
        output.data.department[#output.data.department + 1] = "finance " .. data.data.department.finance
        output.data.department[#output.data.department + 1] = "hr " .. data.data.department.hr
        output.data.department[#output.data.department + 1] = "it " .. data.data.department.it
        output.data.department[#output.data.department + 1] = "marketing " .. data.data.department.marketing
        output.data.department[#output.data.department + 1] = "operations " .. data.data.department.operations
        output.data.department[#output.data.department + 1] = "management " .. data.data.department.management
        output.data.department[#output.data.department + 1] = "sales " .. data.data.department.sales
        output.data.department[#output.data.department + 1] = "legal " .. data.data.department.legal
        output.data.department[#output.data.department + 1] = "support " .. data.data.department.support
        output.data.department[#output.data.department + 1] = "communication " .. data.data.department.communication
        return output
    end
    -- return stdnse.format_output(true, data.data)
end
