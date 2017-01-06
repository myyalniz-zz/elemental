module AuthElemental
  extend ActiveSupport::Concern

  def headers(restfull_url)

    curr_time = Time.now.getutc.to_i + 30
    
    result = Hash.new
    
    result["X-Auth-User"] = 'firatg@baranbilisim.com.tr'
    
    result['X-Auth-Expires'] =  curr_time.to_s
    
    to_digest = URI::parse(URI.escape(restfull_url)).to_s + 'firatg@baranbilisim.com.tr' + "HlkJKH0Z0ZClFCg10knh" + curr_time.to_s
    
    result['X-Auth-Key']  = Digest::MD5.hexdigest("HlkJKH0Z0ZClFCg10knh" + Digest::MD5.hexdigest(to_digest)) 
    
    return result
    
  end

end