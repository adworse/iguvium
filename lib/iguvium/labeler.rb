# frozen_string_literal: true

module Iguvium
  NEIGHBORS = [[0, -1], [-1, -1], [-1, 0], [-1, 1]].freeze
  FLAT_THRESHOLD = 0.2

  # image should be an integer Array, binarized image w/ 0 (or falsy elements) and anything truthy
  class Labeler
    def initialize(image)
      @image = image
      rows = image.count
      cols = image.first.count
      @labels = Array.new(rows) { Array.new(cols) }
      @equalities = []
    end

    attr_reader :image, :labels

    def lines
      clusters.map { |cluster| flatten_cluster cluster }.compact
    end

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
        LOGGER.warn "NonFlattable, #{cluster.inspect}"
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
        labels.dig(r, c) unless [r, c].min.negative?
      }.compact
    end

    def pass_one
      next_label = 0
      image.each_index do |row|
        image[row].each_index do |column|
          pix = image[row][column]
          next unless pix
          next if pix.zero?

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
            neighbors.each do |neighbor|
              @equalities[neighbor] = min
            end
          end
        end
      end
      self
    end
  end
end
