require_relative 'common'


class SelectionSorter < BaseSorter
    def initialize
        super('Selection')
    end

    def sort(ary, count = nil)
        count = ary.size if count.nil?
        return if count < 2

        0.upto(count-2).each do |i|
            min_idx = i
            (i+1).upto(count-1).each do |j|
                min_idx = j if ary[min_idx] > ary[j]
            end
            ary.swap_values! i, min_idx unless i == min_idx
        end
    end
end
