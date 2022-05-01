module SessionsHelper

    # Returns the user corresponding to the remember token cookie.
    def current_merchant
      if (merchant_id = session[:merchant_id])
        @current_merchant ||= Merchant.find_by(id: merchant_id)
      elsif (merchant_id = cookies.signed[:merchant_id])
        merchant= Merchant.find_by(id: merchant_id)
        if merchant && merchant.authenticated?(cookies[:remember_token])
          log_in merchant
          @current_user = merchant
        end
      end
    end
  
   #logs the merchant in.I don't know what your log_in method does there in the    question, if it does the same, you are doing it two times.
  
   def log_in(merchant)
      session[:merchant_id] = merchant.id
   end
  
  
  end