require "tire"
require "HTTParty"
require "debugger"

class UpdateServer
  Tire.configure { logger STDERR }

  INDEX_URL = "http://hKgdm99GdzKeWi34fDsf:beA3tNFfhTr2Xr6yhJkj@54.235.152.166:8080/qa_cities"
  USERNAME  = "hKgdm99GdzKeWi34fDsf"
  PASSWORD  = "beA3tNFfhTr2Xr6yhJkj"

  def self.run_update
    body = '{
      "index": {
        "store": {
          "throttle": {
            "max_bytes_per_sec": "5mb"
          }
        }
      }
    }'

    HTTParty.put([INDEX_URL, "/_settings"].join, body: body, basic_auth: { username: USERNAME, password: PASSWORD })
  end

  puts run_update
end
