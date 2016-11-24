module Firebase
  class Client
    def secret_key=(secret_key)
      @auth = secret_key
    end
  end
end
