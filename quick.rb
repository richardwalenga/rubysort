require_relative 'common'


class QuickSorter < BaseSorter
    def initialize
        super('Quick')
    end

    def sort(ary, count = nil)
        count = ary.size if count.nil?
        self.sort_between_indexes(ary, 0, count-1)
    end

    private

    def sort_between_indexes(ary, low, high)
        if low < high
            pivot_index = self.partition(ary, low, high)
            self.sort_between_indexes(ary, low, pivot_index-1)
            self.sort_between_indexes(ary, pivot_index+1, high)
        end
    end

    # Organizes the values between the high and low indexes where the
    # chosen pivot is moved to a new index where all values greater than
    # the pivot are to its right. The new index for the pivot is returned.
    def partition(ary, low, high)
        pivot = ary[high]
        # initialize the index below low because the index is guaranteed
        # to be incremented before the pivot is moved to its new home.
        new_pivot_index = low - 1
        low.upto(high-1).each do |i|
            if ary[i] <= pivot
                new_pivot_index += 1
                ary.swap_values! new_pivot_index, i
            end
        end
        # There will always be at least one swap call since if this is the
        # first time, it means every value checked is greater than the pivot.
        new_pivot_index += 1
        ary.swap_values! new_pivot_index, high
        new_pivot_index
    end
end
