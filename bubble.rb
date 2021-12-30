require_relative 'common'


class BubbleSorter < BaseSorter
    def initialize(name = 'Bubble')
        super(name)
    end

    def sort(ary, count = nil)
        count = ary.size if count.nil?
        return if count < 2

        while self.ltr_sort ary, count
        end
    end

    protected

    def ltr_sort(ary, count)
        swapped = false
        1.upto(count-1).each do |i|
            if ary[i - 1] > ary[i]
                ary.swap_values! i - 1, i
                swapped = true
            end
        end
        swapped
    end
end


class CocktailShakerSorter < BubbleSorter
    # By applying a bitmask of 1 less than a power of 2, I can cleanly
    # alternate sorting left to right followed by right to left.
    BITMASK = 1

    def initialize
        @sort_methods = [:ltr_sort, :rtl_sort]
        super('Cocktail Shaker')
    end
    
    def sort(ary, count = nil)
        count = ary.size if count.nil?
        return if count < 2

        i = 0
        loop do
            break unless send @sort_methods[i], ary, count
            i = (i + 1) & BITMASK
        end
    end

    private

    def rtl_sort(ary, count)
        swapped = false
        (count - 1).downto(1).each do |i|
            if ary[i] < ary[i - 1]
                ary.swap_values! i - 1, i
                swapped = true
            end
        end
        swapped
    end
end
