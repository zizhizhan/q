module Q
  class Promise
    def initialize(defer)
      @defer = defer
      @callbacks = []
    end

    def then(success, failure, progress)
      done(&success).fail(&failure).progress(&progress)
    end
  
    def done(&block)
      enqueue_and_call(block, :resolve)
    end

    def fail(&block)
      enqueue_and_call(block, :reject)
    end
    
    def progress(&block)
      enqueue_and_call(block, :notify)
    end

    def always(&block)
      done(block).fail(&block)
    end
    
    def status
      defer.status
    end

    def fulfill(type, result)
      @result = result
      @callbacks.each{|callback| callback.call(@result)}
    end

    private
      def enqueue_and_call(block, type)
        @callbacks << Callback.new(self, block, type)
        self
      end
      
  end
end