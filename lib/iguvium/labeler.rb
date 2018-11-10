# frozen_string_literal: true

module Iguvium
  NEIGHBORS = [[0, -1], [-1, -1], [-1, 0], [-1, 1]].freeze
  FLAT_THRESHOLD = 0.2

  private_constant :NEIGHBORS, :FLAT_THRESHOLD

  # Clusterizes connected pixels using two-pass connected component labelling algorithm (Hoshen-Kopelman),
  # 8-connectivity is used. Line-like groups are then flattened using simplified dispersion ratio
  class Labeler
    # @param image [Array<Boolean>] should be an Array, binarized image
    #    w/ falsy elements as background and anything truthy as pixels
    #
    def initialize(image)
      @image = image
      rows = image.count
      cols = image.first.count
      @labels = Array.new(rows) { Array.new(cols) }
      @equalities = []
    end

    # @return [Hash] vertical and horizontal lines detected
    def lines
      clusters.map { |cluster| flatten_cluster cluster }.compact
    end

    # @return [Array<Array>] coordinates of connected pixels grouped together
    def clusters
      accumulator = Hash.new { |h, k| h[k] = [] }
      label.each_index do |row|
        labels[row].each_index do |column|
          pix = labels[row][column]
          next unless pix

          accumulator[pix] << [row, column]
        end
      end
      accumulator.values
    end

    private

    attr_reader :image, :labels

    def label
      pass_one
      @equalities = @equalities.map { |a| resolve a }
      image.each_index do |row|
        image[row].each_index do |column|
          next unless labels[row][column]

          @labels[row][column] = @equalities[labels[row][column]]
        end
      end
      labels
    end

    def flatten_cluster(cluster)
      xs = cluster.map(&:last)
      ys = cluster.map(&:first)

      if xs.uniq.count / xs.count.to_f < FLAT_THRESHOLD
        [xs.max_by { |i| xs.count i }, ys.min..ys.max]
      elsif ys.uniq.count / ys.count.to_f < FLAT_THRESHOLD
        [xs.min..xs.max, ys.max_by { |i| ys.count i }]
      else
        Iguvium.logger.warn "NonFlattable, #{cluster.inspect}"
        nil
      end
    end

    def resolve(num)
      resolved = @equalities[num]
      resolved == num ? resolved : resolve(resolved)
    end

    def neighbors(row, col)
      NEIGHBORS.map { |roffset, coffset|
        r = row + roffset
        c = col + coffset
        labels.dig(r, c) unless [r, c].min < 0
      }.compact
    end

    def neighbors2(row, col)
      neighbors = []
      NEIGHBORS.each do |roffset, coffset|
        r = row + roffset
        c = col + coffset
        next if r < 0 || c < 0

        label = labels[r][c]
        neighbors << label if label
      end
      neighbors
    end

    def pass_one
      next_label = 0
      image.each_index do |row|
        image[row].each_index do |column|
          next unless image[row][column]

          neighbors = neighbors row, column

          if neighbors.empty?
            @equalities[next_label] = next_label
            @labels[row][column] = next_label
            next_label += 1
          else
            neighbors.uniq!
            neighbors.sort!
            min = neighbors.shift
            @labels[row][column] = min
            count = neighbors.length
            next if count == 0

            if count == 1
              @equalities[neighbors[0]] = min
            elsif count > 1
              neighbors.each do |neighbor|
                @equalities[neighbor] = min
              end
            end
          end
        end
      end
      self
    end
  end
end
