module HD24Dig

  module Parts

    class Channel < Part

      ATTRS = %i[
        pcm_file
        io
      ]
      attr_accessor *ATTRS
      attr_accessor :track

      def comparable_attributes
        super + ATTRS
      end

      def inspectable_attributes
        super + ATTRS
      end

    end

  end

end