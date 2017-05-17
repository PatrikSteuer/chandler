module Chandler
  module Refinements
    module VersionFormat
      # Version Class to be able to compare two objects for sorting versions
      class Version

        attr_accessor :version

        def initialize(version)
          @version = version
        end

        # Compare two versions
        def <=>(other)
          return unless Chandler::Refinements::VersionFormat::Version === other
          return 0 if self == other
          lhsegments = segments
          rhsegments = other.segments
          return compare_segments(lhsegments, rhsegments)
        end

        def compare_segments(lhsegments, rhsegments)
          limit = get_min_size(lhsegments.size, rhsegments.size)
          i = -1
          while i < limit
            i += 1
            lhs = lhsegments[i] || 0
            rhs = rhsegments[i] || 0
            next if lhs == rhs
            return compare_elements(lhs, rhs)
          end
        end

        def compare_elements(lhs, rhs)
          return -1 if String == lhs && Numeric == rhs
          return 1 if Numeric == lhs && String == rhs
          return lhs <=> rhs
        end

        def get_min_size(lhsize, rhsize)
          return (lhsize > rhsize ? lhsize : rhsize)
        end

        #
        # Split version string into segments
        def segments
          @segments ||= @version.scan(/#{VERSION_SEGMENT_PATTERN}+/i).map do |s|
            /^\d+$/ =~ s ? s.to_i : s
          end
        end
      end
    end
  end
end
