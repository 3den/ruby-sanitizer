class HTMLEntities
  class Encoder #:nodoc:     
    def basic_entity_regexp
      @basic_entity_regexp ||= (
        case @flavor
        when /^html/
          /[<>"]|(\&(?!\w))/
        else
          /[<>'"]|(\&(?!\w))/
        end
      )
    end
  end
end