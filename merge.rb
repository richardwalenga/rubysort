require_relative 'common'


class MergeSorter < BaseSorter
    def initialize(small_sorter)
        super('Merge')
        @small_sorter = small_sorter
    end

    def sort(ary, count = nil)
        count = ary.size if count.nil?
        return @small_sorter.sort(ary, count) if count < 10

        mid_idx = count / 2
        x, y = ary[0...mid_idx], ary[mid_idx..-1]
        x_idx, y_idx, x_cnt, y_cnt = 0, 0, x.size, y.size
        self.sort(x, x_cnt)
        self.sort(y, y_cnt)
        0.upto(count-1).each do |i|
            can_take_x, can_take_y = x_idx < x_cnt, y_idx < y_cnt
            if can_take_x and (not can_take_y or x[x_idx] <= y[y_idx])
                ary[i] = x[x_idx]
                x_idx += 1
            else
                ary[i] = y[y_idx]
                y_idx += 1
            end
        end
    end
end
