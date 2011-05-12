# encoding: utf-8
class HTMLEntities
  class Encoder #:nodoc:     
    def basic_entity_regexp
      @basic_entity_regexp ||= /[<>'"]|(\&(?!(\w+\;)))/
    end
  end
end