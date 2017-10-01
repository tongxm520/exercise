class JsonWebToken
  # secret to encode and decode token
  #HMAC_SECRET=Rails.application.secrets.secret_key_base
  HMAC_SECRET=Exercise::Application.config.secret_token  

  class << self
    def encode(payload, exp=3.days.from_now)
      # set expiry to 24 hours from creation time
      payload[:exp]=exp.to_i
      # sign token with application secret
      JWT.encode(payload,HMAC_SECRET)
    end

    def decode(token)
      #segments = token.split('.');
      #if segments.count != 3
      #  raise ExceptionHandler::ExpiredSignature
      #end
      #Rails.logger.info("segments.count=>#{segments.count}")
      # get payload; first index in decoded Array
      body=JWT.decode(token,HMAC_SECRET)[0]
      HashWithIndifferentAccess.new body
      # rescue from expiry exception
    rescue JWT::DecodeError, JWT::ExpiredSignature, JWT::VerificationError => e
      # raise custom error to be handled by custom handler
      raise ExceptionHandler::ExpiredSignature, e.message
    end
  end
end


