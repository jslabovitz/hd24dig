module HD24Dig

  module Parts

    class Channel < Part

      ATTRS = %i[
      ]
      attr_accessor *ATTRS
      attr_accessor :track

      def comparable_attributes
        super + ATTRS
      end

      def inspectable_attributes
        super + ATTRS
      end

      def full_name
        '%s %02d' % [@name, num]
      end

    end

  end

end