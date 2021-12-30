require_relative 'common'


class InsertionSorter < BaseSorter
    def initialize
        super('Insertion')
    end

    def sort(ary, count = nil)
        count = ary.size if count.nil?
        return if count < 2

        1.upto(count-1).each do |i|
            j, old = i - 1, ary[i]
            while j >= 0 and ary[j] > old
                ary.swap_values! j, j + 1
                j -= 1
            end
            shifted = j != i - 1
            # Need to compensate for the last decrement of j
            # in the loop above
            ary[j + 1] = old if shifted
        end
    end
end
